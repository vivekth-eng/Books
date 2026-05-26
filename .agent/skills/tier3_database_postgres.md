# Skill: Tier 3 - Database (PostgreSQL)

## Description
Best practices for running a persistent PostgreSQL database in a Docker environment.

## 1. Container Configuration
Use the official image and configure minimal ENV vars.

```yaml
# docker-compose.yml snippet
services:
  db:
    image: postgres:13
    container_name: postgres-db
    environment:
      POSTGRES_USER: ${APP_DB_USER}
      POSTGRES_PASSWORD: ${APP_DB_PASS}
      POSTGRES_DB: ${APP_DB_NAME}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./schema.sql:/docker-entrypoint-initdb.d/init.sql
```

## 2. Initialization Strategy
- **Schema**: Place `schema.sql` in `/docker-entrypoint-initdb.d/`. It runs *only* on the first volume creation.
- **Persistence**: ALWAYS use a named volume (`postgres_data`) to survive container restarts.
- **Connection**:
  - From Host (Windows/Mac): `localhost:5432`
  - From Backend (Docker): `postgres-db:5432` (Service Name)

## 3. SQLAlchemy Pattern
```python
# backend/database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

DATABASE_URL = f"postgresql://{user}:{password}@{host}/{db_name}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```
