import os
import time
from sqlmodel import create_engine, Session, SQLModel
from dotenv import load_dotenv

# Path resolution: .env is in the project root
current_dir = os.path.dirname(os.path.abspath(__file__))
# backend/app/core -> app/core -> app -> backend -> root
root_env_path = os.path.abspath(os.path.join(current_dir, "..", "..", "..", ".env"))
load_dotenv(root_env_path, override=True)

user = os.getenv("DB_USER", "postgres")
password = os.getenv("DB_PASSWORD", "vikths")
host = os.getenv("DB_HOST", "localhost")
port = os.getenv("DB_PORT", "5432")
db_name = os.getenv("DB_NAME", "book_database")

# Use standard postgresql:// for maximum compatibility
DATABASE_URL = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"

# Performance-Hardened Engine (Native Windows 3-Tier)
engine = create_engine(
    DATABASE_URL, 
    echo=False, # Disable in production/debug to stay within 16GB threshold
    pool_size=10, 
    max_overflow=20,
    pool_pre_ping=True,
    connect_args={
        "options": "-c statement_timeout=15000" # 15s timeout to prevent grid hang
    }
)

def init_db():
    """Initialize database tables with retry logic."""
    max_retries = 5
    for i in range(max_retries):
        try:
            print(f"DEBUG: Connection attempt {i+1}/{max_retries} to {DATABASE_URL}")
            # Ensure pgvector extension exists
            with Session(engine) as session:
                from sqlalchemy import text
                session.execute(text("CREATE EXTENSION IF NOT EXISTS vector;"))
                session.execute(text("ALTER TABLE book ADD COLUMN IF NOT EXISTS description_vector vector(384);"))
                session.commit()
            
            SQLModel.metadata.create_all(engine)
            print("DEBUG: Database initialized successfully.")
            return
        except Exception as e:
            print(f"DEBUG: Database connection failed: {e}")
            if i < max_retries - 1:
                time.sleep(2)
            else:
                raise e

def get_session():
    with Session(engine) as session:
        yield session
