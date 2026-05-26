---
name: Database Administration (Native)
description: Shift focus from Docker Volumes to Native Postgres PG_DATA and pg_dump/psql utilities.
---

# Database Administration (Native PostgreSQL)

## 1. Core Architecture
- **Platform:** PostgreSQL 17 running natively as a Windows Service.
- **Data Location:** All database files are stored in the Native Windows `PG_DATA` directory.
- **Docker Ban:** Docker Volumes (`docker-compose down -v`) must no longer be used.

## 2. Utilities

## 3. Native Path Sanitization (Windows 11)
- **Goal:** Ensure database strings remain platform-agnostic while the backend handles runtime prefixing.
- **Rule:** Store ONLY the filename (e.g., `movie_poster.jpg`) in the `poster_local_path` column.
- **Sanitization:** 
    - Strip all leading `/assets/posters/` or `\\wsl.localhost\...` prefixes.
    - Prohibit the string literal `"None"`. If no asset is present, the column MUST be `NULL`.
    - Forbidden characters: `:`, `?`, `*`, `"`, `<`, `>`, `|`.
- **Ingestion Policy:** Any ingestion script MUST use `pathlib.Path(save_path).exists()` to verify the physical presence of a file before committing the record to SQL.

## 4. Integrity Maintenance
- **Audit Tool:** Periodically run `backend/scripts/poster_integrity_audit.py`.
- **Action:** Any broken 1:1 mapping must be investigated. Do not rely on runtime heuristics to fix data drift.
