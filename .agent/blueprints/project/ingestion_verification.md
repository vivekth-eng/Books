SCOPE: PROJECT
ID: Ingestion Verification
CONTEXT: Movie_DB_v1.1 / Mission Control

# 🛰️ Ingestion Verification (Mission Control)

This blueprint codifies the success criteria and audit protocol for the surgical ingestion engine.

## 1. The "Total-Parity" Rule
- **Mandate**: At the conclusion of every sync, the command `SELECT count(*) FROM movie` MUST match the total non-empty row count in `movies_master.xlsx`.
- **Validation**: Any mismatch results in a `CRITICAL` audit log entry and requires a forensic re-index.

## 2. The "Poster-Health" Mandate
- **Standard**: The sync script MUST produce a `sync_report.log` in the `backend/logs/` directory.
- **Success Criteria**: 
    - **Zero Ghost Posters**: Every record with a `poster_local_path` must have a corresponding physical file on internal storage.
    - **Naming Compliance**: 100% adherence to the `[slugified_title]_[year].jpg` pattern.

## 3. The "Oracle-Warm-up" Standard
- **Mechanism**: After data ingestion, the `search_cache` table MUST be truncated.
- **Objective**: Ensure the `ai_persistence_engine` reflects the updated library state immediately.
- **Expectation**: Retrieval of a newly added title (e.g., *Avatar: Fire And Ash*) within 60 seconds of ingestion completion.

## 4. Metadata-Lineage Tracking
- **Required Format**: The `metadata_source` field must adhere to: `tmdb_{API_VERSION}_{UTC_TIMESTAMP}`. 
- **Legacy Preservation**: For records missing TMDB data, the source remains `excel`.

## 5. Resource Governance (Ryzen 7)
- **Parallelism**: Ingestion must leverage `max_workers=16` during Phase 1 (TMDB Enrichment) to optimize network/processor throughput.
- **Memory Ceiling**: Python process memory must remain below 1.5GB to ensure CUDA-search headroom for the frontend.

⚓
