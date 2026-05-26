import os
import logging
import threading
from typing import Optional, List
from pathlib import Path
from sqlmodel import Session
from app.core.models import Book
from app.services.search_service import LocalSearchService

logger = logging.getLogger("book_utils")

# GPU Semaphore to prevent resource collision between concurrent operations
gpu_semaphore = threading.Semaphore(1)

def get_embedding(text: str) -> Optional[List[float]]:
    """Local embedding generation using SentenceTransformers to keep search local and fast."""
    try:
        with gpu_semaphore:
            return LocalSearchService.get_instance().get_embedding(text)
    except Exception as e:
        logger.error(f"Error generating local embedding: {e}")
        return None

def book_to_dict(
    book: Book, 
    session: Optional[Session] = None, 
    similarity: Optional[float] = None, 
    is_reading_list_user: Optional[bool] = None, 
    interaction_score: Optional[int] = None
) -> dict:
    """Standardized book mapping for API responses, handling cover assets and user-specific relationships."""
    # Use by_alias=True if we want model configurations
    b_dict = book.model_dump()
    
    if similarity is not None:
        b_dict["similarity"] = similarity
        
    # Cover URL generation
    filename = book.cover_name or (os.path.basename(book.cover_local_path) if book.cover_local_path else "")
    if filename:
        clean_filename = os.path.basename(filename)
        
        # Verify physical cover file exists on Windows filesystem
        current_dir = Path(__file__).resolve().parent
        covers_dir = current_dir.parent.parent.parent / "assets" / "covers"
        abs_target = covers_dir / clean_filename
        
        if abs_target.exists():
            b_dict["cover_url"] = clean_filename
        else:
            b_dict["cover_url"] = None
    else:
        b_dict["cover_url"] = None
        
    b_dict["authors_list"] = book.authors_list
    b_dict["publish_year"] = book.publish_year
    b_dict["rating"] = book.rating
    
    # Map the per-user contextual properties
    b_dict["is_reading_list"] = bool(is_reading_list_user) if is_reading_list_user is not None else False
    b_dict["interaction_score"] = int(interaction_score) if interaction_score is not None else 0
    
    # Ensure raw embedding vector array is deleted to minimize transfer payload
    if "embedding" in b_dict: 
        del b_dict["embedding"]
    if "description_vector" in b_dict:
        del b_dict["description_vector"]
        
    return b_dict
