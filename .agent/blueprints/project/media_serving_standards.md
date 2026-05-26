SCOPE: PROJECT
ID: Media Serving Standards
CONTEXT: Movie_DB_v1.1 / FastAPI / Flutter

# 🖼️ Media Serving Standards (Native Windows)

To ensure zero "Black Cards" and consistent asset delivery in the Native Windows environment, these standards must be strictly followed.

## 1. Unified Asset Mounting
- **Standard:** Serve assets directly via the main FastAPI app on Port 8000/8001. Avoid separate media ports to simplify networking.
- **Implementation:** `app.mount("/posters", StaticFiles(directory=Config.POSTER_DIR))`

## 2. The "Native Path" Rule
- **Standard:** Use absolute Windows paths for configuration and discovery.
- **Default:** `C:/movie_assets/posters`
- **Logic:** The backend must use `pathlib.Path` to resolve the absolute location of assets.

## 3. The "Deterministic Mapping" Standard
- **Standard:** The database `poster_local_path` is the Absolute Source of Truth.
- **Protocol:** 
  1. The backend reads the filename directly from the `poster_local_path` column.
  2. The backend verifies the file exists in the `POSTER_DIR`.
  3. If the file exists, the backend serves the direct mapping to Port 8001.
  4. If the file is missing or the path is `null`, the backend MUST return `placeholder.jpg`.
- **Zero-Tolerance:** Any "guessing," "fuzzy matching," or "title-to-file" heuristics are strictly prohibited in the production runtime.

## 4. The "None" String Prohibition
- **Standard:** The string literal `"None"` or `"none"` in `poster_local_path` is considered a data corruption error.
- **Action:** Any such records must be sanitized to `NULL` to trigger the deterministic placeholder fallback or TMDB hydration.

## 5. Metadata Sanitization (Underscore Bridge)
- **Standard:** All filenames in `poster_local_path` must comply with Windows filename constraints and URI safe-handling standards.
- **Forbidden:** `:`, `?`, `*`, `"`, `<`, `>`, `|`, ` `, `-`.
- **Enforcement:** `[clean_title]_[year].jpg` pattern using strict **Underscore Sanitization**. All non-alphanumeric characters MUST be replaced by a single underscore `_`.
  - *Internal Logic:* Use the `slugify()` routine from `media_hydration_engine.md` for consistency.

## 6. Verification & Auditing
- **Standard:** Use the `poster_integrity_audit.py` skill to identify broken mappings. 
- **Rule:** A record with a non-null `poster_local_path` GUARANTEES a visual asset. If the audit fails, the record is flagged for re-hydration.
        
