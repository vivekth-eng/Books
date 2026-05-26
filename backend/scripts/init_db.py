import os
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from sqlmodel import SQLModel, create_engine
from sqlalchemy import text

# Adjust path to import from app
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.core.database import DATABASE_URL, init_db
from app.core.models import Book, User, ReadingList, UserInteraction, SearchCache, SemanticCache, AuditLog

def check_and_create_db():
    user = os.getenv("DB_USER", "postgres")
    password = os.getenv("DB_PASSWORD", "vikths")
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5432")
    db_name = os.getenv("DB_NAME", "book_database")

    print("Checking database existence...")
    try:
        # Connect to default postgres DB
        conn = psycopg2.connect(
            dbname="postgres",
            user=user,
            password=password,
            host=host,
            port=port
        )
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        
        # Check if database exists
        cursor.execute(f"SELECT 1 FROM pg_catalog.pg_database WHERE datname = '{db_name}';")
        exists = cursor.fetchone()
        
        if not exists:
            print(f"Database '{db_name}' does not exist. Creating...")
            cursor.execute(f"CREATE DATABASE {db_name};")
            print("Database created successfully!")
        else:
            print(f"Database '{db_name}' already exists.")
            
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error checking/creating database: {e}")
        # Continue and try SQLModel initialization directly

if __name__ == "__main__":
    from dotenv import load_dotenv
    current_dir = os.path.dirname(os.path.abspath(__file__))
    load_dotenv(os.path.abspath(os.path.join(current_dir, "..", "..", ".env")), override=True)
    
    check_and_create_db()
    init_db()
