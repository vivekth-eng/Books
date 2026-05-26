from fastapi import APIRouter, Depends, Query, HTTPException, Request
from sqlmodel import Session, select, func, or_, col
from sqlalchemy.orm import defer
from sqlalchemy import exists, case
from typing import List, Optional
import os
import logging
import time

from app.core.database import get_session
from app.core.models import Book, User, ReadingList, UserInteraction
from app.core.auth import get_current_user, get_current_user_optional
from app.core.utils import book_to_dict, get_embedding, gpu_semaphore

router = APIRouter()
logger = logging.getLogger("books_api")

@router.get("/config")
def get_config():
    return {
        "has_semantic_search": True,
        "api_base_url": os.getenv("API_BASE_URL", "http://localhost:8000/"),
        "search_model": "all-mpnet-base-v2"
    }

@router.get("/books")
def get_books(
    session: Session = Depends(get_session),
    current_user: Optional[User] = Depends(get_current_user_optional),
    search: Optional[str] = None,
    semantic: bool = False,
    authors: Optional[str] = None,
    publisher: Optional[str] = None,
    year_min: Optional[int] = None,
    year_max: Optional[int] = None,
    reading_list: Optional[bool] = Query(None, alias="reading_list"),
    min_rating: Optional[float] = None,
    sort_by: str = "name",
    sort_order: str = "asc",
    offset: int = 0,
    limit: int = 20,
):
    
    # Base Query
    query = select(Book)
    similarity_col = None
    is_reading_list_col = None
    interaction_col = None
    
    if current_user:
        is_reading_list_col = exists().where(
            ReadingList.book_id == Book.id,
            ReadingList.user_id == current_user.id
        ).label("is_reading_list_user")
        
        interaction_col = select(UserInteraction.interaction_score).where(
            UserInteraction.book_id == Book.id,
            UserInteraction.user_id == current_user.id
        ).scalar_subquery().label("interaction_score_user")
        
        query = query.add_columns(is_reading_list_col, interaction_col)

    if search:
        search_clean = search.replace(':', ' ').replace('-', ' ').strip()
        search_clean = " ".join(search_clean.split())
        
        if semantic:
            embedding = get_embedding(search)
            if embedding:
                similarity_col = Book.embedding.cosine_distance(embedding).label("similarity")
                query = query.add_columns(similarity_col)
                # Apply 0.4 similarity threshold (0.6 cosine distance)
                query = query.where(similarity_col <= 0.6)
            else:
                # Text fallback
                keywords = [k.strip() for k in search.split() if len(k) > 2]
                if not keywords: 
                    keywords = search.split()
                text_filters = [col(Book.name).ilike(f"%{k}%") for k in keywords]
                query = query.where(or_(*text_filters))
        else:
            query = query.where(or_(
                col(Book.name).ilike(f"%{search}%"),
                col(Book.name).ilike(f"%{search_clean}%"),
                col(Book.authors).ilike(f"%{search}%")
            ))
        
        limit = min(limit, 50) # Limit search results to 50 for performance

    # Apply Filters
    if authors:
        query = query.where(col(Book.authors).ilike(f"%{authors}%"))
    if publisher:
        query = query.where(col(Book.publisher).ilike(f"%{publisher}%"))
    if year_min is not None:
        query = query.where(Book.publish_year >= year_min)
    if year_max is not None:
        query = query.where(Book.publish_year <= year_max)
    if min_rating is not None:
        query = query.where(Book.rating >= min_rating)
        
    if reading_list is not None:
        if current_user:
            query = query.where(exists().where(
                ReadingList.book_id == Book.id,
                ReadingList.user_id == current_user.id
            ))
        elif reading_list:
            return []

    # Handle Sorting
    cover_sort_case = case(
        (or_(Book.cover_name == None, Book.cover_name == ""), 1),
        else_=0
    )
    
    if similarity_col is not None:
        if sort_by in ['relevance', 'id'] or (sort_by == 'name' and sort_order == 'asc'):
            query = query.order_by(cover_sort_case.asc(), similarity_col.asc())
        else:
            sort_attr = {"name": Book.name, "year": Book.publish_year, "rating": Book.rating}.get(sort_by, Book.name)
            query = query.order_by(cover_sort_case.asc(), sort_attr.desc() if sort_order == "desc" else sort_attr.asc(), similarity_col.asc())
    else:
        sort_attr = {"id": Book.id, "name": Book.name, "year": Book.publish_year, "rating": Book.rating}.get(sort_by, Book.name)
        query = query.order_by(cover_sort_case.asc(), sort_attr.desc() if sort_order == "desc" else sort_attr.asc())

    try:
        results = session.execute(query.options(defer(Book.embedding)).offset(offset).limit(limit)).all()
        parsed_results = []
        
        for row in results:
            if isinstance(row, Book):
                book = row
                rl = False
                score = 0
                sim = 0.0
            else:
                book = row[0]
                current_idx = 1
                rl = False
                score = 0
                sim = 0.0
                
                if is_reading_list_col is not None:
                    rl = bool(row[current_idx])
                    current_idx += 1
                if interaction_col is not None:
                    score = int(row[current_idx]) if row[current_idx] is not None else 0
                    current_idx += 1
                if similarity_col is not None:
                    sim = float(row[current_idx]) if row[current_idx] is not None else 0.0
                    current_idx += 1
            
            parsed_results.append(book_to_dict(book, session=session, similarity=sim, is_reading_list_user=rl, interaction_score=score))
        
        return parsed_results

    except Exception as e:
        logger.error(f"Query failure: {e}", exc_info=True)
        fallback_query = select(Book).options(defer(Book.embedding)).offset(offset).limit(limit)
        fallback_results = session.exec(fallback_query).all()
        return [book_to_dict(b) for b in fallback_results]
@router.get("/api/v1/books/search/semantic")
def semantic_search(
    query: str, 
    limit: int = 20, 
    session: Session = Depends(get_session),
    current_user: Optional[User] = Depends(get_current_user_optional)
):
    from app.services.search_service import LocalSearchService
    try:
        query_vector = LocalSearchService.get_instance().get_embedding(query, model_name="all-MiniLM-L6-v2")
    except Exception as e:
        logger.error(f"Failed to generate query embedding: {e}")
        raise HTTPException(status_code=500, detail=f"Embedding generation failed: {e}")

    if not query_vector:
        raise HTTPException(status_code=500, detail="Query embedding could not be generated")

    # Define similarity column using description_vector
    similarity_col = Book.description_vector.cosine_distance(query_vector).label("similarity")

    # Order by cover presence first (books with covers first), then similarity distance ascending
    cover_sort_case = case(
        (or_(Book.cover_name == None, Book.cover_name == ""), 1),
        else_=0
    )

    query_select = select(Book).add_columns(similarity_col)
    
    # Check reading list and interaction if user is authenticated
    is_reading_list_col = None
    interaction_col = None
    if current_user:
        is_reading_list_col = exists().where(
            ReadingList.book_id == Book.id,
            ReadingList.user_id == current_user.id
        ).label("is_reading_list_user")
        
        interaction_col = select(UserInteraction.interaction_score).where(
            UserInteraction.book_id == Book.id,
            UserInteraction.user_id == current_user.id
        ).scalar_subquery().label("interaction_score_user")
        
        query_select = query_select.add_columns(is_reading_list_col, interaction_col)

    # Filter only books that have a vectorized description
    query_select = query_select.where(Book.description_vector != None)
    
    # Order by cover availability first, then similarity distance ascending
    query_select = query_select.order_by(cover_sort_case.asc(), similarity_col.asc()).limit(limit)

    try:
        results = session.execute(query_select).all()
        parsed_results = []
        for row in results:
            book = row[0]
            current_idx = 1
            rl = False
            score = 0
            sim = 0.0
            
            if is_reading_list_col is not None:
                rl = bool(row[current_idx])
                current_idx += 1
            if interaction_col is not None:
                score = int(row[current_idx]) if row[current_idx] is not None else 0
                current_idx += 1
            
            sim = float(row[current_idx]) if row[current_idx] is not None else 0.0
            
            parsed_results.append(book_to_dict(
                book, 
                session=session, 
                similarity=sim, 
                is_reading_list_user=rl, 
                interaction_score=score
            ))
        return parsed_results
    except Exception as e:
        logger.error(f"Semantic search query failed: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Database query failure: {e}")

@router.get("/api/v1/books/{isbn}")
def get_book(isbn: str, session: Session = Depends(get_session), current_user: Optional[User] = Depends(get_current_user_optional)):
    # Handle float ISBN truncation safety
    isbn_clean = isbn.strip()
    if isbn_clean.endswith(".0"):
        isbn_clean = isbn_clean[:-2]
    isbn_with_dot_zero = isbn_clean + ".0"

    query = select(Book).where(
        or_(
            Book.isbn == isbn,
            Book.isbn == isbn_clean,
            Book.isbn == isbn_with_dot_zero
        )
    )
    is_reading_list = None
    interaction_score = 0
    
    book = session.exec(query).first()
    if not book:
        raise HTTPException(status_code=404, detail="Book record not found")
        
    if current_user:
        is_reading_list = session.execute(
            select(exists().where(ReadingList.book_id == book.id, ReadingList.user_id == current_user.id))
        ).scalar()
        interaction_score = session.execute(
            select(UserInteraction.interaction_score).where(UserInteraction.book_id == book.id, UserInteraction.user_id == current_user.id)
        ).scalar() or 0
    
    res = book_to_dict(book, session=session, is_reading_list_user=is_reading_list, interaction_score=interaction_score)
    return res

@router.post("/books/{book_id}/reading-list")
async def toggle_reading_list_endpoint(
    book_id: int, 
    request: Request,
    current_user: User = Depends(get_current_user),
    session: Session = Depends(get_session)
):
    book = session.get(Book, book_id)
    if not book:
        raise HTTPException(status_code=404, detail="Book not found")
    
    try:
        data = await request.json()
    except:
        data = {}
    
    action = data.get("action", "add")
    
    existing = session.exec(
        select(ReadingList).where(ReadingList.user_id == current_user.id, ReadingList.book_id == book_id)
    ).first()

    if action == "remove":
        if not existing:
            return {"message": "Not in reading list"}
        session.delete(existing)
        session.commit()
        return {"message": "Removed from reading list"}
    else:
        if existing:
            return {"message": "Already in reading list"}
        reading_list_entry = ReadingList(user_id=current_user.id, book_id=book_id)
        session.add(reading_list_entry)
        session.commit()
        return {"message": "Added to reading list"}

@router.delete("/books/{book_id}/reading-list")
def remove_from_reading_list(
    book_id: int,
    current_user: User = Depends(get_current_user),
    session: Session = Depends(get_session)
):
    reading_list_entry = session.exec(
        select(ReadingList).where(ReadingList.user_id == current_user.id, ReadingList.book_id == book_id)
    ).first()
    if not reading_list_entry:
        raise HTTPException(status_code=404, detail="Not in reading list")
    
    session.delete(reading_list_entry)
    session.commit()
    return {"message": "Removed from reading list"}

@router.get("/reading-list")
def get_reading_list(
    current_user: User = Depends(get_current_user),
    session: Session = Depends(get_session)
):
    query = select(Book).join(ReadingList).where(ReadingList.user_id == current_user.id)
    results = session.exec(query).all()
    return [book_to_dict(b, is_reading_list_user=True) for b in results]

@router.post("/books/{book_id}/interact")
async def interact_book_endpoint(
    book_id: int,
    request: Request,
    current_user: User = Depends(get_current_user),
    session: Session = Depends(get_session)
):
    book = session.get(Book, book_id)
    if not book:
        raise HTTPException(status_code=404, detail="Book not found")
    
    try:
        data = await request.json()
    except:
        data = {}
    
    score = data.get("score", 0) # 0: None, 1: Reading, 2: Completed, 3: Favorite
    
    existing = session.exec(
        select(UserInteraction).where(UserInteraction.user_id == current_user.id, UserInteraction.book_id == book_id)
    ).first()
    
    if existing:
        existing.interaction_score = score
        existing.timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        session.add(existing)
    else:
        interaction = UserInteraction(
            user_id=current_user.id,
            book_id=book_id,
            interaction_score=score,
            timestamp=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        )
        session.add(interaction)
        
    session.commit()
    return {"message": "Interaction recorded", "score": score}

@router.get("/publishers")
def get_publishers(session: Session = Depends(get_session)):
    query = select(Book.publisher, func.count(Book.id)).group_by(Book.publisher)
    results = session.exec(query).all()
    result = [{"name": p, "count": c} for p, c in results if p]
    return sorted(result, key=lambda x: x["count"], reverse=True)
