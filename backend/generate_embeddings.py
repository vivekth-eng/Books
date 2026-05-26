import os
import sys
import argparse
import logging
import gc

# Add the parent directory to the path so we can import app modules
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.database import engine
from app.core.models import Book
from sqlmodel import Session, select, func

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("generate_embeddings")

def main():
    parser = argparse.ArgumentParser(description="Generate description embeddings for LibriStack library catalog.")
    parser.add_argument("--limit", type=int, default=None, help="Max number of books to process.")
    parser.add_argument("--batch-size", type=int, default=500, help="Batch size for generating embeddings and DB updates.")
    args = parser.parse_args()

    # Detect device
    device = "cpu"
    try:
        import torch
        if torch.cuda.is_available():
            device = "cuda"
            logger.info(f"CUDA is available! Running inference on GPU: {torch.cuda.get_device_name(0)}")
        else:
            logger.info("CUDA not available. Running inference on CPU.")
    except ImportError:
        logger.info("PyTorch not installed. Running inference on CPU.")

    logger.info("Loading SentenceTransformer model 'all-MiniLM-L6-v2' (384 dimensions)...")
    try:
        from sentence_transformers import SentenceTransformer
        model = SentenceTransformer("all-MiniLM-L6-v2", device=device)
    except Exception as e:
        logger.error(f"Failed to load sentence-transformers model: {e}")
        sys.exit(1)

    # 1. Count remaining records to process
    with Session(engine) as session:
        remaining_count = session.exec(
            select(func.count(Book.id)).where(Book.description_vector == None)
        ).first() or 0
        logger.info(f"Total books needing embedding backfill: {remaining_count}")

    if remaining_count == 0:
        logger.info("All books are already vectorized. Nothing to do!")
        return

    # Adjust process limit
    process_limit = args.limit if args.limit is not None else remaining_count
    logger.info(f"Starting vectorization pipeline (Target: {process_limit} books, Batch Size: {args.batch_size})...")

    processed = 0
    raw_connection = engine.raw_connection()
    try:
        while processed < process_limit:
            current_limit = min(args.batch_size, process_limit - processed)
            
            # Fetch batch of books lacking embeddings (prioritizing books with covers first)
            from sqlalchemy import case, or_
            cover_sort_case = case(
                (or_(Book.cover_name == None, Book.cover_name == ""), 1),
                else_=0
            )
            with Session(engine) as session:
                books = session.exec(
                    select(Book)
                    .where(Book.description_vector == None)
                    .order_by(cover_sort_case.asc(), Book.id.asc())
                    .limit(current_limit)
                ).all()
            
            if not books:
                logger.info("No more books to process.")
                break

            logger.info(f"Processing batch {processed // args.batch_size + 1}: {len(books)} books...")
            
            # Prepare texts and map IDs
            texts = []
            book_ids = []
            for b in books:
                name = b.name or ""
                authors = b.authors or ""
                publisher = b.publisher or ""
                
                # Combine metadata as specified: Name + " by " + Authors + ". Published by " + Publisher
                text = f"{name} by {authors}. Published by {publisher}"
                texts.append(text)
                book_ids.append(b.id)

            # Generate embeddings (384-dimensional)
            embeddings = model.encode(texts, show_progress_bar=False).tolist()

            # Perform fast bulk updates using a cursor
            cursor = raw_connection.cursor()
            try:
                update_query = "UPDATE book SET description_vector = %s WHERE id = %s"
                update_data = []
                for b_id, emb in zip(book_ids, embeddings):
                    # Format as vector string e.g. '[0.1, 0.2, 0.3...]'
                    vector_str = "[" + ",".join(str(val) for val in emb) + "]"
                    update_data.append((vector_str, b_id))
                
                cursor.executemany(update_query, update_data)
                raw_connection.commit()
            except Exception as update_err:
                raw_connection.rollback()
                logger.error(f"Database batch update failed: {update_err}")
                raise update_err
            finally:
                cursor.close()

            processed += len(books)
            logger.info(f"Progress: {processed}/{process_limit} books vectorized.")

            # CineStack Memory Governance Policy: clear VRAM caches systematically
            if device == "cuda":
                try:
                    torch.cuda.empty_cache()
                except Exception as cache_err:
                    logger.warning(f"Failed to empty CUDA cache: {cache_err}")
            gc.collect()

        logger.info(f"Embedding backfill successfully completed. Vectorized {processed} books!")

    finally:
        raw_connection.close()

if __name__ == "__main__":
    main()
