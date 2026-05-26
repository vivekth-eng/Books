SCOPE: PROJECT
ID: Master File Ingestion
CONTEXT: Movie_DB_v1.1

# 📊 Master File Governance

This document defines the protocol for the "Master File Ingestion" workflow, ensuring that `movies_master.xlsx` remains the single, authoritative source of truth for all records in the CineStack database.

## 1. The Single Source of Truth

All movie metadata updates must originate in `backend/assets/movies_master.xlsx`. 
- **MANDATORY:** Never edit records directly in the PostgreSQL database via `psql` unless for emergency troubleshooting.
- **WORKFLOW:** To add or update a movie:
    1. Open `movies_master.xlsx`.
    2. Add/Edit the row.
    3. Save the file.
    4. Run `python3 scripts/ingest_update.py`.

## 2. Ingestion Logic (Idempotency)

The `ingest_master()` script in `backend/scripts/ingest_update.py` utilizes an **Upsert** strategy:
- **Identifier:** `(title, release_year)` is the unique composite key.
- **Update:** If a record matches, its metadata (Description, Genre, Rating, Disk) is overwritten by the Excel values.
- **Insert:** If no match is found, a new UID is generated and the record is added.

## 3. Poster Pathing Standards
- **Standard:** Every record in the Master File MUST correlate to a physical asset in `assets/posters/`.
- **Sanitization Protocol:** 
    - **Forbidden Characters:** `:`, `?`, `*`, `"`, `<`, `>`, `|`. These must be stripped during ingestion.
    - **Naming Convention:** `lowercased_title_year_index.jpg` (e.g., `the_batman_2022_0.jpg`).
    - **Verification:** The ingestion script MUST verify the file exists on the Windows filesystem before committing the path to the DB.

## 4. Maintenance & Audit (Native Windows)
- **Backup:** Periodically backup `movies_master.xlsx` to a secondary physical drive or cloud storage.
- **Health Check:** After every sync, verify the total row count in the PostgreSQL service:
    ```powershell
    psql -U postgres -d movie_database -c "SELECT count(*) FROM movie;"
    ```
- **Integrity Check:** Run `python backend/scripts/poster_integrity_audit.py` to ensure 100% record-to-asset alignment.

⚓
