# SSOT Integrity Standards (CineStack)

This blueprint defines the standards for maintaining the integrity of the Excel Single Source of Truth (SSOT) and its reactive synchronization with the PostgreSQL database.

## 1. The "Conflict-Resolution" Mandate
- The **Excel file** is the absolute Source of Truth for all movie metadata.
- In case of a conflict between the Database and the Excel file, the **Excel value always wins**.
- The database is never allowed to hold a different "Disk Location" or "Rating" than what is specified in the Excel file.

## 2. The "Metadata-Only Speedrun" Standard
- Synchronization involving only non-textual changes (**Disk Info**, **File Path**, **Rating**, **Is Watched**) must bypass **Phase 4 (AI Activation)**.
- This ensures the UI remains responsive and saves VRAM on the RTX 4050 by skipping unnecessary embedding regeneration.
- Re-vectorization is only triggered if one of the following fields changes:
    - Title
    - Description
    - Genre/Tags
    - Director
    - Actors

## 3. The "Manual-Override" Standard
- If a field in Excel is manually populated by the user (e.g., "Disk" info), the **TMDB enrichment Phase 1** is forbidden from overwriting it.
- Enrichment logic must use a "Null-Preservation" pattern to ensure manual data is preserved.

## 4. Reactive UI Invalidation
- Every successful backend sync must be followed by a full invalidation of the frontend repositories (e.g., `ref.invalidate(movieGridProvider)`).
- This ensures that the user's manual Excel edits are visible in the app immediately after the sync completion.
