# backend/sync_covers.py

import os
import sys
import re
import asyncio
import httpx
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlmodel import Session, select

# Adjust path to import from app
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.database import DATABASE_URL
from app.core.models import Book
from app.services.google_books_client import GoogleBooksClient

# Resolve directories
BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(BACKEND_DIR)
EXCEL_PATH = os.path.join(ROOT_DIR, "assets", "books_master.xlsx")

# Cache folder inside the project assets/covers
COVER_DIR = os.path.join(ROOT_DIR, "assets", "covers")
os.makedirs(COVER_DIR, exist_ok=True)

# Environment loading
ENV_FILE = os.path.join(ROOT_DIR, ".env")
load_dotenv(ENV_FILE, override=True)

# Retrieve Google Books API Key
api_key = os.getenv("GOOGLE_BOOKS_API_KEY") or os.getenv("GOOGLE_API_KEY")

# Exponential backoff retries count
backoff_retries = 0

# Helper function for safe integer conversions
def safe_int(val, default=0):
    try:
        if pd.isna(val):
            return default
        s_val = str(val).split('.')[0].strip()
        return int(s_val)
    except:
        return default

# 3. Underscore Sanitization Bridge (File-System Safety)
def sanitize_title(title: str) -> str:
    r"""
    Cleans book name to omit illegal Windows naming characters: \ / : * ? " < > |
    Replaces spaces with single underscores, collapses duplicate underscores, and strips.
    """
    if not title or pd.isna(title):
        return "unknown"
    # Remove Windows restricted character set
    cleaned = re.sub(r'[\/:*?"<>|]', '', str(title))
    # Replace spaces with underscores
    cleaned = cleaned.replace(' ', '_')
    # Collapse multiple underscores
    cleaned = re.sub(r'_+', '_', cleaned)
    # Strip leading/trailing underscores
    return cleaned.strip('_')

async def download_single_cover_async(client: httpx.AsyncClient, idx: int, book_id: int, title: str, isbn: str) -> dict:
    """
    Attempts to download a cover image for a single book.
    Queries Google Books first. If 429, empty, or misses, immediately routes to Open Library.
    """
    sanitized_name = sanitize_title(title)
    filename = f"{sanitized_name}_{isbn}.jpg"
    local_file_path = os.path.join(COVER_DIR, filename)
    db_path = f"covers/{filename}" # Relative database path

    # If the file already exists locally, we reuse it and save bandwidth
    if os.path.exists(local_file_path):
        return {
            "idx": idx, 
            "book_id": book_id, 
            "db_path": db_path, 
            "status": "success", 
            "source": "local_cache", 
            "title": title
        }

    cover_url = None
    source = "google_books"
    
    # 1. Query Google Books first (if API key is present)
    if api_key:
        gb_url = "https://www.googleapis.com/books/v1/volumes"
        params = {
            "q": f"isbn:{isbn}",
            "key": api_key
        }
        try:
            response = await client.get(gb_url, params=params, timeout=10)
            if response.status_code == 429:
                print(f"  Google Books API returned 429 Rate Limit for ISBN: {isbn}")
                raise httpx.HTTPStatusError("Rate Limit", request=response.request, response=response)
                
            response.raise_for_status()
            data = response.json()
            items = data.get("items", [])
            if items:
                volume_info = items[0].get("volumeInfo", {})
                image_links = volume_info.get("imageLinks", {})
                cover_url = (
                    image_links.get("thumbnail") or 
                    image_links.get("smallThumbnail") or 
                    image_links.get("medium") or 
                    image_links.get("large")
                )
        except httpx.HTTPStatusError as e:
            if e.response.status_code == 429:
                raise e
        except Exception:
            # Catch all network/timeout/parsing errors and trigger cascade
            pass

    # 2. Open Library Cascade:
    # If Google Books yields a 429, empty array, or misses, immediately query Open Library
    if not cover_url:
        source = "open_library"
        ol_url = f"https://covers.openlibrary.org/b/isbn/{isbn}-L.jpg?default=false"
        try:
            # Open Library cover details redirect to Archive.org, follow_redirects is needed
            response = await client.get(ol_url, timeout=12, follow_redirects=True)
            if response.status_code == 200:
                with open(local_file_path, "wb") as f:
                    f.write(response.content)
                return {
                    "idx": idx, 
                    "book_id": book_id, 
                    "db_path": db_path, 
                    "status": "success", 
                    "source": source, 
                    "title": title
                }
            elif response.status_code == 429:
                print(f"  Open Library API returned 429 Rate Limit for ISBN: {isbn}")
                raise httpx.HTTPStatusError("Rate Limit", request=response.request, response=response)
        except httpx.HTTPStatusError as e:
            if e.response.status_code == 429:
                raise e
        except Exception:
            pass
    else:
        # We got a cover URL from Google Books, download it
        try:
            if cover_url.startswith("http://"):
                cover_url = cover_url.replace("http://", "https://")
            response = await client.get(cover_url, timeout=15)
            if response.status_code == 200:
                with open(local_file_path, "wb") as f:
                    f.write(response.content)
                return {
                    "idx": idx, 
                    "book_id": book_id, 
                    "db_path": db_path, 
                    "status": "success", 
                    "source": source, 
                    "title": title
                }
            elif response.status_code == 429:
                raise httpx.HTTPStatusError("Rate Limit", request=response.request, response=response)
        except httpx.HTTPStatusError as e:
            if e.response.status_code == 429:
                raise e
        except Exception:
            pass

    return {
        "idx": idx, 
        "book_id": book_id, 
        "status": "not_found", 
        "title": title
    }

async def process_candidates_in_blocks(candidates, engine, df):
    global backoff_retries
    
    # Process candidates in blocks of 20 concurrently
    block_size = 20
    total_candidates = len(candidates)
    downloaded_results = []
    
    # We track how many we need to download
    already_synced = len([f for f in os.listdir(COVER_DIR) if f.endswith(".jpg")])
    target_total = 800
    needed = target_total - already_synced
    if needed <= 0:
        print(f"Target of {target_total} covers already achieved.")
        return 0
        
    success_count = 0
    
    async with httpx.AsyncClient() as client:
        i = 0
        while i < total_candidates and success_count < needed:
            # Only take what is needed up to block size
            current_needed = needed - success_count
            current_block_size = min(block_size, current_needed)
            
            block = candidates[i:i+current_block_size]
            print(f"Processing block {i // block_size + 1} ({len(block)} items)... Successes so far: {success_count}/{needed}")
            
            tasks = [
                download_single_cover_async(client, idx, book_id, title, isbn)
                for idx, book_id, title, isbn in block
            ]
            
            try:
                results = await asyncio.gather(*tasks)
                
                block_successes = []
                for res in results:
                    downloaded_results.append(res)
                    if res["status"] == "success":
                        print(f"  SUCCESS: Hydrated '{res['title']}' via {res['source']}")
                        block_successes.append(res)
                        success_count += 1
                    else:
                        print(f"  FAILED: Missing cover for '{res['title']}'")
                
                # Write back updates to Database and Excel periodically to prevent progress loss
                if block_successes:
                    print("  Persisting block updates to PostgreSQL...")
                    with Session(engine) as session:
                        for res in block_successes:
                            book = session.get(Book, res["book_id"])
                            if book:
                                book.cover_local_path = res["db_path"]
                                session.add(book)
                            df.at[res["idx"], "cover_local_path"] = res["db_path"]
                        session.commit()
                    
                    # Save Excel every 10 blocks (200 books), or when target is reached
                    if (i // block_size) % 10 == 0 or success_count >= needed or (i + current_block_size >= total_candidates):
                        print("  Persisting block updates to Excel...")
                        df.to_excel(EXCEL_PATH, index=False)
                
                backoff_retries = 0
                i += current_block_size
                
            except httpx.HTTPStatusError as e:
                if e.response.status_code == 429:
                    backoff_retries += 1
                    sleep_seconds = 5 * (2 ** (backoff_retries - 1))
                    print(f"\n[RATE LIMIT] Captured HTTP 429. Retrying in {sleep_seconds} seconds...")
                    await asyncio.sleep(sleep_seconds)
                else:
                    print(f"  HTTP error in block: {e}")
                    i += current_block_size
            except Exception as e:
                print(f"  Error processing block: {e}")
                i += current_block_size
                
            await asyncio.sleep(0.5)
            
    return success_count

def sync_covers():
    print("--- Starting Asynchronous Cascading Cover Ingestion (httpx) ---")
    
    if not os.path.exists(EXCEL_PATH):
        print(f"ERROR: Excel master file not found at {EXCEL_PATH}")
        sys.exit(1)
        
    print(f"Reading master dataset: {EXCEL_PATH}...")
    df = pd.read_excel(EXCEL_PATH)
    
    if "cover_local_path" not in df.columns:
        df["cover_local_path"] = None
        
    engine = create_engine(DATABASE_URL)
    client = GoogleBooksClient()
    
    # Audit local file state and build candidate list
    to_sync = []
    for idx, row in df.iterrows():
        isbn = client.clean_isbn(row.get("ISBN"))
        if not isbn:
            continue
            
        title = str(row.get("Name", "")).strip()
        if not title or title.lower() == 'nan':
            continue
            
        cover_path = row.get("cover_local_path")
        needs_sync = False
        
        if pd.isna(cover_path) or not str(cover_path).strip() or str(cover_path).lower() == 'nan':
            needs_sync = True
        else:
            filename = os.path.basename(str(cover_path))
            local_file = os.path.join(COVER_DIR, filename)
            if not os.path.exists(local_file):
                needs_sync = True
                
        if needs_sync:
            book_id = safe_int(row.get("Id"))
            to_sync.append((idx, book_id, title, isbn))
            
    print(f"Audit Complete: Found {len(to_sync)} records missing local cover files.")
    
    # Calculate how many covers already exist
    already_synced = len([f for f in os.listdir(COVER_DIR) if f.endswith(".jpg")])
    target_total = 800
    print(f"Current cover assets count on disk: {already_synced}")
    
    if already_synced >= target_total:
        print(f"Target of {target_total} book covers already achieved. No more downloads needed.")
        return
        
    candidates = to_sync
    
    print(f"Processing async cascading downloads to reach {target_total} total covers...")
    
    # Run async loop
    success_count = asyncio.run(process_candidates_in_blocks(candidates, engine, df))
            
    print(f"\n--- Ingestion Complete. Hydrated {success_count} cover assets. ---")

if __name__ == "__main__":
    sync_covers()
