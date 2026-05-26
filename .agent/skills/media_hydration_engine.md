# Skill: [MEDIA_HYDRATION_ENGINE]

## Purpose
Enforces 1:1 asset fulfillment on Native Windows. Orchestrates the transition from `NULL` or broken records to verified local files via TMDB, while ensuring the Excel SSOT is updated.

## Implementation Pattern: The "Surgical" Bridge

### Stage 1: TMDB-to-Excel Enrichment
- **Action**: For records in Excel missing `tmdb_id`, use `TMDBClient.search_movie()`.
- **Enrichment**: Fetch `director`, `actors`, and `metadata_source`.
- **Excel Persistence**: Use `pandas` and `openpyxl` to write these values back to `movies_master.xlsx`.

### Stage 2: Media Localization (Underscore Sanitization)
- **Constraint**: Every poster MUST be saved to `assets/posters/`.
- **Naming Rule**: `[slugify(title)]_[year].jpg`.
- **Slugify Routine**:
  ```python
  def slugify(text: str) -> str:
      import re
      import unicodedata
      text = unicodedata.normalize('NFKD', text).encode('ascii', 'ignore').decode('ascii')
      slug = re.sub(r'[^a-zA-Z0-9]+', '_', text).lower()
      return slug.strip('_')
  ```

### Stage 3: Database Sync
- **Action**: Upsert the enriched Excel data into PostgreSQL.
- **Verification**: Ensure `poster_local_path` in DB matches the physical file created in Stage 2.

## Prohibition
- **NO GHOST POSTERS**: Never set a path in the DB if the file does not exist on disk.
- **NO EXTERNAL URLS**: Production DB should strictly point to local paths `/assets/posters/...` once hydrated.

## Tooling
- `pandas`, `openpyxl`: For Excel manipulation.
- `requests`: For TMDB asset downloads.
- `SQLModel`: For database persistence.
- `RTX 4050`: Triggered in Phase 4 for vector generation.
