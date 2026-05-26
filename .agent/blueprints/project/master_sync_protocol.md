# 🏛️ Master Sync Protocol (V2.5)

## Authority: Project Manager
## Context: Automated ingestion and cloud-vectorization for `movies_master.xlsx`.

### Phase 1: The SSoT Data Entry
- **The Manual Step**: The user updates the Excel file (`movies_master.xlsx`) with new titles, ratings, or descriptions.
- **Naming Convention**: New movie records must include a unique `movie_id` and a `poster_path` that matches the filename.
- **Special Character Handling**: The ingestion script uses a **"Sanitization Bridge"**.
  - **Rule**: Filenames will replace symbols (e.g., `:`, `?`, `*`) with underscores `_` to remain punctuation-safe for both Windows and Docker volumes.

### Phase 1b: Asset Migration & Sync (The Bridging Step)
- **Automated Sync**: If the Excel file contains a valid `Poster_URL`, the system can automatically download the image via `sync_assets.py`.
- **Manual Migration**: If no URL exists, physical `.jpg` files MUST be moved from the Windows source (e.g., Downloads/Desktop) to the WSL asset folder: `\\wsl.localhost\Ubuntu\home\vikths\movie_assets\posters`.
- **Validation**: Visual parity depends on matching the sanitized filename (e.g., `[Rec]` (2007) -> `rec_2007.jpg`).

### Phase 2: Poster Assets & Tier 3 Ingestion
- **Asset Placement**: Drop `.jpg` files into the `movie_assets/posters` folder.
- **Ingestion Script (`ingest_master.py`)**:
  - Reads the Excel file and performs a "UPSERT" (Update or Insert).
  - **Asset-First Rule**: If a physical `.jpg` is missing, the record is flagged in `missing_posters.log`.
- **Database Backup**: Immediately after ingestion, the script executes `pg_dump` to create a timestamped `.sql` backup inside the `/backups` volume.

### Phase 3: Semantic Cloud Hydration (Vectorization)
- **The Unified Vector Standard**: The embedding column must always represent the full metadata set (Title + Director + Cast + Description) to prevent "Information Blindness" in semantic search.
- **The TMDB-First Dependency**: Vectorization should only trigger (or be rebuilt) after TMDB enrichment is fully complete for a record.
- **The Vectorizer (`sync_embeddings.py` / `rebuild_vectors.py`)**:
  - Scans the database for any records where `metadata_source == 'tmdb'` to ensure cast-awareness.
  - Sends specific "Delta" records to the Gemini API in batches of 50 with 2s sleep to preserve daily quota.

### Phase 4: Data Enrichment
- **The "Auto-Fill" Standard**: Any mandatory field missing from `movies_master.xlsx` (specifically descriptions) will trigger a "Discovery Task" via `enrich_metadata.py`.
- **Intelligence Layer**: Uses Gemini with Google Search grounding to fetch accurate, 2-sentence synopses.
- **Enrichment Toggle**: Controlled via the Flutter UI "Enrich Metadata" switch.

### Phase 5: Attribute Mapping (TMDB Sync)
- **The Librarian Rule**: All objective, static metadata (Director, Cast, TMDB ID, Release Date) must be sourced from the TMDB API as the primary authority. Gemini is strictly reserved for "Semantic Meaning" and "Conceptual Discovery."
- **The Actor-Safe Formatting**: Actors must be stored as a comma-separated string (Top 5 leads) to enable high-speed local filtering on mobile devices.
- **The Metadata Tagging Policy**: All records modified by the TMDB bridge must be tagged as `metadata_source: 'tmdb'` to distinguish them from manual Excel entries.

### Operational Roadmap: Library Hydration
- **Current Status**: **[v1.4]** - TMDB Integration Bridge active (Directed Metadata).
- **The "Full-Library" Standard**: Conceptual search is now the default discovery mode for all movies, enriched with both TMDB facts and Gemini-derived semantic vectors.

- **The "Relative-Path" Standard**: All asset folders (Posters/Backups) must use relative project paths in Docker (e.g., `./movie_assets/posters`) to ensure cross-platform compatibility between Windows and WSL.
- **The "Mount-Check" Protocol**: The 'Sync Master Data' button must now perform a "Healthy Mount" check (verifying the `posters` folder isn't empty) before starting the ingestion.
- **The "Zero-Wait" UI**: Now that posters are loading locally via direct mount, remove any "Loading" placeholders for movies that have a confirmed `.jpg` on disk.
- **The "Zero-Broken-Link" Rule**: No sync is complete until the backend verifies the physical existence of the `.jpg` on the WSL disk.
- **The "Sanitization Bridge"**: Any title containing special characters must be automatically converted to underscores (`_`) in both the database and the filename.

---

### Phase 6: Safe Launch Protocol (V1.0)
- **The "Dual-Stream" Log Standard**: All managed services (API, Assets) must use separate `.log` files for output (`stdout`) and errors (`stderr`) to ensure the Intel i5 can uniquely record crashes without file-locking contention.
- **The "Non-Blocking" Start**: Processes started via PowerShell `Start-Process` must use the `-WindowStyle Hidden` (or `-NoNewWindow` where visibility is required) but must NEVER contend for the same stdout/stderr file handle.
- **The "Lifecycle Lock"**: Every startup script must perform a post-handshake audit of the `stderr` logs. If any data exists, the user must be flagged with a Non-Critical Warning even if the `health check` passes.
- **The "Heartbeat Calibration"**: Health check timeouts must be set to at least 30s for native cold-starts to allow for database initialization and cache hydration.
- **The "Port-Sovereignty" Rule**: Port 5000 is officially banned from CineStack usage to avoid Windows system service interference (OS Error 10048). The Presentation Tier (Flutter Web) is pinned to **Port 5050**.
- **The "Clean Exit" Guarantee**: The Lifecycle Cleanup block must verify that all background PIDs (API, Assets) are successfully terminated before releasing the port handles to prevent "Ghost Ports."
