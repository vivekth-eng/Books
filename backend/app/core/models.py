from typing import Optional, List, Any
from sqlmodel import SQLModel, Field, Column
from pydantic import computed_field, ConfigDict, field_validator
from pgvector.sqlalchemy import Vector
import os
import math
from dotenv import load_dotenv

load_dotenv()

class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True)
    hashed_password: str
    full_name: Optional[str] = Field(default=None)

class ReadingList(SQLModel, table=True):
    __tablename__ = "reading_list"
    user_id: int = Field(foreign_key="user.id", primary_key=True)
    book_id: int = Field(foreign_key="book.id", primary_key=True)

class UserInteraction(SQLModel, table=True):
    __tablename__ = "user_interaction"
    user_id: int = Field(foreign_key="user.id", primary_key=True)
    book_id: int = Field(foreign_key="book.id", primary_key=True)
    interaction_score: int = Field(default=0) # 0: None, 1: Reading, 2: Completed, 3: Favorite
    timestamp: Optional[str] = Field(default=None) # ISO format

class Book(SQLModel, table=True):
    __tablename__ = "book"
    model_config = ConfigDict(arbitrary_types_allowed=True)
    
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    authors: Optional[str] = Field(default="", index=True) # Stores comma-separated authors
    pages: Optional[int] = Field(default=0)
    publisher: Optional[str] = Field(default="", index=True)
    reviews: Optional[int] = Field(default=0)
    publish_year: Optional[int] = Field(default=0, index=True)
    rating: float = Field(default=0.0)
    isbn: Optional[str] = Field(default=None, index=True)
    description: Optional[str] = Field(default="")
    cover_local_path: Optional[str] = Field(default=None) # e.g. /assets/covers/slug.jpg
    cover_name: Optional[str] = Field(default=None) # e.g. slug.jpg
    google_books_id: Optional[str] = Field(default=None, index=True)
    metadata_source: str = Field(default="excel") # 'excel' or 'google_books'
    embedding: Optional[List[float]] = Field(default=None, sa_column=Column(Vector(768)))
    description_vector: Optional[List[float]] = Field(default=None, sa_column=Column(Vector(384)))

    @field_validator("rating", mode="before")
    @classmethod
    def validate_rating(cls, v: Any) -> float:
        if v is None:
            return 0.0
        try:
            val = float(v)
            if math.isnan(val) or math.isinf(val):
                return 0.0
            return val
        except (ValueError, TypeError):
            return 0.0

    @field_validator("pages", "reviews", "publish_year", mode="before")
    @classmethod
    def validate_integers(cls, v: Any) -> int:
        if v is None:
            return 0
        try:
            val = float(v)
            if math.isnan(val) or math.isinf(val):
                return 0
            return int(val)
        except (ValueError, TypeError):
            return 0

    @computed_field
    @property
    def cover_url(self) -> Optional[str]:
        # Return ONLY the relative filename if it exists
        if self.cover_local_path:
            return os.path.basename(self.cover_local_path)
        return None

    @computed_field
    @property
    def authors_list(self) -> List[str]:
        if not self.authors:
            return []
        return [a.strip() for a in self.authors.split(",")]

    @authors_list.setter
    def authors_list(self, value: List[str]):
        self.authors = ",".join(value)

    is_reading_list: bool = Field(default=False)

class SemanticCache(SQLModel, table=True):
    __tablename__ = "semantic_cache"
    id: Optional[int] = Field(default=None, primary_key=True)
    cache_key: str = Field(index=True, unique=True) # Hash of query or interaction set
    result_ids: str = Field(default="") # Comma-separated book IDs
    cache_type: str = Field(index=True) # 'recommendation' or 'search'
    timestamp: Optional[str] = Field(default=None) # ISO format

class SearchCache(SQLModel, table=True):
    __tablename__ = "search_cache"
    id: Optional[int] = Field(default=None, primary_key=True)
    cache_key: str = Field(index=True, unique=True) # SHA-256 hash of query + filters
    result_ids: str = Field(default="") # Comma-separated book IDs
    is_semantic: bool = Field(default=True)
    timestamp: Optional[str] = Field(default=None) # ISO format

class AuditLog(SQLModel, table=True):
    __tablename__ = "audit_log"
    id: Optional[int] = Field(default=None, primary_key=True)
    level: str = Field(index=True) # INFO, WARNING, ERROR, CRITICAL
    message: str
    context: Optional[str] = Field(default=None) # JSON-string of context
    timestamp: Optional[str] = Field(default=None) # ISO format
