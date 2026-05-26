import pandas as pd
import os
import requests
import re
import unicodedata
import traceback
import json
import math
import sys
from datetime import datetime
from typing import Optional, List, Dict, Any
from sqlalchemy import create_engine, text
from sqlmodel import Session, select

# Adjust path to import from app
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.core.models import Book, SearchCache
from app.core.database import DATABASE_URL
from app.services.google_books_client import GoogleBooksClient
from sentence_transformers import SentenceTransformer
import torch
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configuration
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
EXCEL_PATH = os.path.join(ROOT_DIR, "assets", "books_master.xlsx")
COVER_DIR = os.path.join(ROOT_DIR, "assets", "covers")
LOG_DIR = os.path.join(ROOT_DIR, "backend", "logs")
REPORT_PATH = os.path.join(LOG_DIR, "sync_report.log")

# Resource Limits to prevent out-of-memory or rate-limiting
LIMIT_ENRICH = 100       # Max API calls to Google Books per run
LIMIT_VECTOR = 1000     # Max records to vectorize per run

# Ensure directories exist
os.makedirs(COVER_DIR, exist_ok=True)
os.makedirs(LOG_DIR, exist_ok=True)

def slugify(text: str) -> str:
    """Normalize book title and replace special characters with single underscores."""
    if not text or pd.isna(text):
        return "unknown"
    # Pre-process curly apostrophes and common special chars
    text = str(text).replace('’', "'").replace('‘', "'").replace('–', '-')
    # Normalize unicode to strip accents
    normalized = unicodedata.normalize('NFKD', text).encode('ascii', 'ignore').decode('ascii')
    # Replace all non-alphanumeric with underscores
    slug = re.sub(r'[^a-zA-Z0-9]+', '_', normalized).lower()
    # Collapse multiple underscores and strip
    slug = re.sub(r'_+', '_', slug).strip('_')
    return slug

def clean_text(text: str) -> str:
    """Clean and normalize text for database safety."""
    if not text or pd.isna(text):
        return ""
    return unicodedata.normalize('NFKD', str(text)).encode('ascii', 'ignore').decode('ascii').strip()

def download_cover(url: str, filename: str) -> bool:
    """Download cover image to local assets folder."""
    target_path = os.path.join(COVER_DIR, filename)
    if os.path.exists(target_path):
        return True
    try:
        response = requests.get(url, timeout=15)
        response.raise_for_status()
        with open(target_path, "wb") as f:
            f.write(response.content)
        return True
    except Exception as e:
        print(f"DEBUG: Failed to download cover from {url}: {e}")
        return False

def fetch_book_metadata(client: GoogleBooksClient, title: str, author: str, isbn: str) -> Dict[str, Any]:
    """Helper function to fetch book metadata from Google Books API."""
    try:
        # Try ISBN search first
        if isbn:
            result = client.search_by_isbn(isbn)
            if result:
                result["status"] = "success"
                return result
        
        # Fallback to title and author search
        if title:
            result = client.search_by_title_and_author(title, author)
            if result:
                result["status"] = "success"
                return result
    except Exception as e:
        return {"status": "error", "error": str(e)}
    return {"status": "not_found"}

def safe_int(val, default=0):
    try:
        if pd.isna(val): return default
        # Remove floating point from string representation
        s_val = str(val).split('.')[0].strip()
        return int(s_val)
    except:
        return default

def safe_float(val, default=0.0):
    try:
        if pd.isna(val): return default
        f_val = float(val)
        if math.isnan(f_val) or math.isinf(f_val):
            return default
        return f_val
    except:
        return default

def ingest_and_hydrate():
    start_time = datetime.now()
    print(f"--- LibriStack Ingestion & Hydration Engine Started ({start_time.isoformat()}) ---")
    
    if not os.path.exists(EXCEL_PATH):
        print(f"CRITICAL: Excel SSOT not found at {EXCEL_PATH}")
        return

    # 1. READ EXCEL
    print("Reading Excel SSOT...")
    df = pd.read_excel(EXCEL_PATH)
    total_excel_rows = len(df)
    print(f"Loaded {total_excel_rows} rows from Excel.")
    
    # Ensure metadata columns exist
    for col in ['description', 'cover_local_path', 'google_books_id', 'metadata_source']:
        if col not in df.columns:
            df[col] = None

    client = GoogleBooksClient()
    engine = create_engine(DATABASE_URL, connect_args={"options": "-c client_encoding=utf8"})
    
    modified_excel = False
    sync_report = {
        "timestamp": start_time.isoformat(),
        "total_excel_rows": total_excel_rows,
        "enriched": 0,
        "localized": 0,
        "errors": []
    }
    
    # PHASE 1: Controlled Enrichment (Google Books API)
    print(f"Phase 1: Controlled Enrichment (LIMIT_ENRICH={LIMIT_ENRICH})...")
    to_enrich = []
    for idx, row in df.iterrows():
        # Only enrich if google_books_id is missing AND description is empty
        desc = str(row.get('description', '')).strip()
        gb_id = row.get('google_books_id')
        if (pd.isna(gb_id) or not gb_id) and (not desc or desc == 'nan' or desc.startswith('[TBD')):
            title = clean_text(str(row.get('Name', '')))
            author = clean_text(str(row.get('Authors', '')))
            
            # Clean ISBN
            isbn_raw = row.get('ISBN')
            isbn = client.clean_isbn(isbn_raw)
            
            if title:
                to_enrich.append((idx, title, author, isbn))
                if len(to_enrich) >= LIMIT_ENRICH:
                    break

    print(f"Found {len(to_enrich)} rows needing enrichment in this batch.")
    if to_enrich:
        # Run queries sequentially or in parallel threadpool
        with ThreadPoolExecutor(max_workers=5) as executor:
            future_to_idx = {executor.submit(fetch_book_metadata, client, t, a, i): idx for idx, t, a, i in to_enrich}
            for future in as_completed(future_to_idx):
                idx = future_to_idx[future]
                result = future.result()
                
                title = df.at[idx, 'Name']
                
                if result["status"] == "success":
                    timestamp = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
                    df.at[idx, 'google_books_id'] = result["google_books_id"]
                    
                    # Fill description
                    if result["description"]:
                        df.at[idx, 'description'] = clean_text(result["description"])
                    else:
                        df.at[idx, 'description'] = "[TBD: Google Books description missing]"
                    
                    # Overwrite empty ratings, publishers, pages, authors if needed
                    if result["rating"] and (pd.isna(df.at[idx, 'Rating']) or df.at[idx, 'Rating'] == 0.0):
                        df.at[idx, 'Rating'] = result["rating"]
                    
                    if result["publisher"] and (pd.isna(df.at[idx, 'Publisher']) or df.at[idx, 'Publisher'] == ""):
                        df.at[idx, 'Publisher'] = clean_text(result["publisher"])
                        
                    if result["pages"] and (pd.isna(df.at[idx, 'pagesNumber']) or df.at[idx, 'pagesNumber'] == 0):
                        df.at[idx, 'pagesNumber'] = result["pages"]

                    if result["authors"] and (pd.isna(df.at[idx, 'Authors']) or df.at[idx, 'Authors'] == ""):
                        df.at[idx, 'Authors'] = clean_text(result["authors"])
                    
                    df.at[idx, 'metadata_source'] = f"google_books_v1_{timestamp}"
                    df.at[idx, '_temp_cover_url'] = result["cover_url"]
                    sync_report["enriched"] += 1
                    modified_excel = True
                else:
                    df.at[idx, 'google_books_id'] = "NOT_FOUND"
                    df.at[idx, 'description'] = "[TBD: Google Books metadata not found]"
                    df.at[idx, 'metadata_source'] = "google_books_not_found"
                    modified_excel = True

    # SSOT Integrity: Save Excel before moving to DB sync
    if modified_excel:
        print(f"SSOT Update: Writing enriched metadata to {EXCEL_PATH}...")
        save_df = df.copy()
        if '_temp_cover_url' in save_df.columns: 
            save_df.drop(columns=['_temp_cover_url'], inplace=True)
        save_df.to_excel(EXCEL_PATH, index=False)
        print(f"SUCCESS: Excel SSOT saved.")

    # PHASE 2: Cover Media Localization
    print(f"Phase 2: Cover Media Localization...")
    for idx, row in df.iterrows():
        title = clean_text(str(row.get('Name', '')))
        
        # Clean ISBN
        isbn_raw = row.get('ISBN')
        isbn = client.clean_isbn(isbn_raw)
        if not isbn:
            isbn = "unknown"
            
        if not title or title.lower() == 'nan': 
            continue
        
        sanitized_name = f"{slugify(title)}_{isbn}.jpg"
        db_path = f"/assets/covers/{sanitized_name}"
        local_file_path = os.path.join(COVER_DIR, sanitized_name)
        
        # Download if doesn't exist locally
        if not os.path.exists(local_file_path):
            url = row.get('_temp_cover_url') if '_temp_cover_url' in row else None
            # If temp_cover_url is empty, we don't have active download links, skip
            if pd.notna(url) and str(url).startswith('http'):
                if download_cover(url, sanitized_name):
                    df.at[idx, 'cover_local_path'] = db_path
                    sync_report["localized"] += 1
                    modified_excel = True
        else:
            # Already exists, sync local path
            if pd.isna(df.at[idx, 'cover_local_path']) or df.at[idx, 'cover_local_path'] != db_path:
                df.at[idx, 'cover_local_path'] = db_path
                modified_excel = True

    # Save Excel after cover localization
    if modified_excel:
        save_df = df.copy()
        if '_temp_cover_url' in save_df.columns: 
            save_df.drop(columns=['_temp_cover_url'], inplace=True)
        save_df.to_excel(EXCEL_PATH, index=False)
        print("SSOT covers path synchronized.")

    # PHASE 3: Database Sync (Upsert)
    print(f"Phase 3: Database Synchronization (Upserting {total_excel_rows} rows)...")
    
    # We do a batch execution to prevent connection timeouts or locking issues
    batch_size = 1000
    with Session(engine) as session:
        session.execute(text("SET client_encoding TO 'UTF8'"))
        
        for i in range(0, total_excel_rows, batch_size):
            chunk = df.iloc[i : i + batch_size]
            print(f"  [DB] Syncing rows {i} to {min(i + batch_size, total_excel_rows)}...")
            
            for idx, row in chunk.iterrows():
                book_id = safe_int(row.get('Id'))
                name = clean_text(str(row.get('Name', '')))
                if not name or book_id == 0:
                    continue
                
                # Check if book exists
                stmt = select(Book).where(Book.id == book_id)
                book = session.exec(stmt).first()
                
                # Extract new values
                new_authors = clean_text(row.get('Authors'))
                new_pages = safe_int(row.get('pagesNumber'))
                new_publisher = clean_text(row.get('Publisher'))
                new_reviews = safe_int(row.get('CountsOfReview'))
                new_publish_year = safe_int(row.get('PublishYear'))
                new_rating = safe_float(row.get('Rating'))
                new_isbn = client.clean_isbn(row.get('ISBN'))
                new_desc = clean_text(row.get('description'))
                
                raw_cover = row.get('cover_local_path')
                new_cover = str(raw_cover) if pd.notna(raw_cover) and str(raw_cover).strip() != "" and str(raw_cover).lower() != 'nan' else None
                
                raw_gb_id = row.get('google_books_id')
                new_gb_id = str(raw_gb_id) if pd.notna(raw_gb_id) and str(raw_gb_id).strip() != "" and str(raw_gb_id).lower() != 'nan' else None
                
                raw_source = row.get('metadata_source')
                new_source = str(raw_source) if pd.notna(raw_source) and str(raw_source).strip() != "" and str(raw_source).lower() != 'nan' else 'excel'
                
                # Check for changes in text fields which requires re-embedding
                text_changed = False
                
                if not book:
                    # Insert new record
                    book = Book(
                        id=book_id,
                        name=name,
                        authors=new_authors,
                        pages=new_pages,
                        publisher=new_publisher,
                        reviews=new_reviews,
                        publish_year=new_publish_year,
                        rating=new_rating,
                        isbn=new_isbn,
                        description=new_desc,
                        cover_local_path=new_cover,
                        google_books_id=new_gb_id,
                        metadata_source=new_source,
                        embedding=None
                    )
                else:
                    # Update existing record (Dirty field check)
                    text_changed = (
                        book.name != name or
                        book.description != new_desc or
                        book.authors != new_authors or
                        book.publisher != new_publisher
                    )
                    
                    if text_changed:
                        book.embedding = None # Trigger re-embedding
                    
                    book.name = name
                    book.authors = new_authors
                    book.pages = new_pages
                    book.publisher = new_publisher
                    book.reviews = new_reviews
                    book.publish_year = new_publish_year
                    book.rating = new_rating
                    book.isbn = new_isbn
                    book.description = new_desc
                    book.cover_local_path = new_cover
                    book.google_books_id = new_gb_id
                    book.metadata_source = new_source
                
                session.add(book)
            
            # Commit the batch
            session.commit()
            
        # Parity check
        db_count = session.execute(text("SELECT count(*) FROM book")).scalar()
        sync_report["db_final_count"] = db_count
        sync_report["parity_match"] = (db_count == total_excel_rows)
        print(f"Database contains {db_count} books. Excel has {total_excel_rows} books.")
        
    # PHASE 4: AI Activation & Embeddings
    print("Phase 4: AI Activation & local embeddings generation...")
    try:
        device = "cuda" if torch.cuda.is_available() else "cpu"
        print(f"Loading SentenceTransformer model 'all-mpnet-base-v2' on {device}...")
        model = SentenceTransformer('all-mpnet-base-v2', device=device)
        
        with Session(engine) as session:
            # Query books missing embeddings that HAVE a description
            # To be efficient, we only embed records with actual descriptions and limit the count
            stmt = select(Book).where(Book.embedding == None, Book.description != "", Book.description != None).limit(LIMIT_VECTOR)
            new_books = session.exec(stmt).all()
            
            if new_books:
                print(f"  [AI] Vectorizing {len(new_books)} records on {device}...")
                for book in new_books:
                    index_text = f"Title: {book.name}. Description: {book.description}. Authors: {book.authors}. Publisher: {book.publisher}."
                    book.embedding = model.encode(index_text).tolist()
                    session.add(book)
                session.commit()
                print(f"Vectorized {len(new_books)} books.")
            else:
                print("No books require embedding generation in this batch.")
            
            # Truncate search cache
            print("  [ORACLE] Truncating search cache...")
            session.execute(text("TRUNCATE TABLE search_cache"))
            session.commit()
            
    except Exception as e:
        print(f"AI Activation Error: {e}")
        sync_report["errors"].append(f"AI Activation Error: {str(e)}")

    # Save final report
    with open(REPORT_PATH, "w") as f:
        json.dump(sync_report, f, indent=4)
        
    duration = datetime.now() - start_time
    print(f"--- Ingestion Complete (Duration: {duration}) ---")
    print(f"Detailed report saved to: {REPORT_PATH}")

if __name__ == "__main__":
    ingest_and_hydrate()
