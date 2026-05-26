SCOPE: PROJECT
ID: Book Ingestion Standard
CONTEXT: Book_DB_v1.0

# 📋 Book Ingestion Standard (Native Windows 3-Tier Sync)

This blueprint documents the surgical ingestion process for updating the LibriStack database via the `books_master.xlsx` Single Source of Truth (SSOT).

## 📚 Workflow Overview (The Surgical 4-Phase)

1.  **Phase 1: Excel Enrichment (Python)**: The ingestion script scans for new rows. It queries the Google Books API for missing description, authors, pages, publisher, and rating using the ISBN. These details are written back to `books_master.xlsx` to maintain the SSOT.
2.  **Phase 2: Media Localization**: Cover images are downloaded from the Google Books volume info (`imageLinks`) and saved to `/assets/covers/` using strict **Underscore Sanitization** logic: `[slugified_name]_[isbn].jpg` (e.g., `the_hobbit_9780261102217.jpg`).
3.  **Phase 3: Database Sync**: Enriched Excel rows are Upserted into the PostgreSQL `book` table using the unique Excel `Id` column as the primary identifier.
4.  **Phase 4: AI Activation**: The RTX 4050 local embedding engine generates high-fidelity 768d vectors for new records to ensure immediate availability in Semantic Search.

## 📂 Path & Variable Registry

### Filesystem Mappings (Native)
| Resource | Path | Description |
| :--- | :--- | :--- |
| **Excel SSOT** | `assets/books_master.xlsx` | The authoritative data source. |
| **Cover Storage** | `assets/covers/` | Local directory for sanitized .jpg assets. |
| **Ingestion Script** | `backend/scripts/ingest_and_hydrate.py` | The main execution engine. |

### Environment Variables (.env)
- `DB_HOST`: `localhost`
- `DB_USER`: `postgres`
- `DB_PASSWORD`: `vikths`
- `DB_NAME`: `book_database`
- `GOOGLE_API_KEY`: Required for enrichment.

## 🛠️ Execution Protocol

### 1. Manual Excel Update
Add new books and ISBNs to `books_master.xlsx`.

### 2. UI-Triggered Sync
Click the **"Sync Data"** button in the LibriStack Filters sidebar. This triggers the `POST /sync/ingest` endpoint which executes the `ingest_and_hydrate.py` script.

### 3. CLI Trigger (Fallback)
```powershell
& "C:\PythonEnvs\.venv\Scripts\python.exe" backend/scripts/ingest_and_hydrate.py
```

### 🧠 Ingestion Logic (Surgical Integrity)

#### Upsert Rule
- **Primary Key Matching**: Match database records using the Excel `Id`.
- **Sync**: All fields are updated to match Excel, ensuring the spreadsheet remains the source of truth.

#### Null-Preservation Policy
- The script is strictly forbidden from overwriting an existing non-empty Excel cell with a null value from Google Books.

#### TBD Placeholder Standard
- If Google Books returns empty metadata and the Excel cell is empty, populate with `[TBD: Google Books Pending]` to prevent UI crashes.

## 🚨 Troubleshooting
- **Permission Error**: Ensure `python.exe` has write access to both the Excel file and the covers directory.
- **Index Out of Range / Column Error**: Verify columns match standard keys: `Id`, `Name`, `pagesNumber`, `Publisher`, `CountsOfReview`, `PublishYear`, `Authors`, `Rating`, `ISBN`.
- **CUDA Warning**: If embeddings are slow, verify `torch.cuda.is_available()` returns `True`.
⚓
