# Skill: Orchestration (Docker Compose)

## Description
Defining the relationship between Tier 2 (Backend) and Tier 3 (Database).

## 1. Network Strategy
Use a default bridge network. Services can reach each other by **Service Name**.

- **Backend** can reach **DB** at `host: db` (or `postgres-db`).
- **Frontend (Host)** reaches **Backend** at `localhost:8000` (Release) or VPN IP (Debug).

## 2. Standard `docker-compose.yml`
```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    container_name: fastapi-backend
    ports:
      - "8001:8000" # Map Host 8001 -> Container 8000
    depends_on:
      - db
    env_file:
      - backend/.env
    volumes:
      - ./backend:/app # Hot Reload for Dev

  db:
    image: postgres:13
    container_name: postgres-db
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./schema.sql:/docker-entrypoint-initdb.d/init.sql

volumes:
  postgres_data:
```

## 3. Hot Reload Pattern
- Map the local directory (`./backend`) to the container (`/app`).
- Run `uvicorn` with `--reload`.
- **Note**: Requires Linux/WSL. Windows file notification events may not propagate to Docker Desktop.
