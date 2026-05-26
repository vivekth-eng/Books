# 📝 Incident Log: Missing Poster Assets (2026-03-02)

## Description
During the validation of the Master Sync Workflow (SSoT_SYNC_VALIDATION), 25 new movie records were successfully ingested into the database, and their semantic embeddings were hydrated via the Gemini API. However, the physical `.jpg` poster files were missing from the WSL asset directory (`/home/vikths/movie_assets/posters`), resulting in blank cards in the Flutter UI.

## Affected Records
- **IDs**: 1746 - 1774 (25 active records).
- **Titles**: Bugonia, Die My Love, Eternity, The Smashing Machine, etc.

## Root Cause
- The automated workflow performs an "UPSERT" based on Excel data but does not automatically fetch or move physical image files from Windows to WSL.
- This represents a "Manual Gap" where the user must provide the assets before triggering the sync.

## Resolution
- [ ] Locate source posters on Windows.
- [ ] Move posters to `\\wsl.localhost\Ubuntu\home\vikths\movie_assets\posters`.
- [ ] Harden `ingest_master.py` with an automated file-existence check to prevent future mismatches.

## Prevention
- Implemented the "Asset-First Verification" rule in `master_sync_protocol.md` V2.1.
