# Skill: Project Archival & Export

## Overview
Protocol for consolidating a finished feature branch into the main branch and exporting the entire environment (code, images, data) to external storage for long-term preservation.

## 1. Git Consolidation
Ensure all progress is saved and the project is in a consistent state.

- **Check Current Status**: `git status`
- **Commit Changes**: `git add . && git commit -m "chore: final save before archival"`
- **Switch to Main**: `git checkout main`
- **Merge Feature Branch**: `git merge <feature_branch_name>`
- **Push to Remote**: `git push origin main`

## 2. Docker Image Export
Export the runtime environment as portable `.tar` archives.

- **Cleanup Containers**: `docker-compose down`
- **Save Images**:
  ```powershell
  docker save <backend_image_name> > E:\Archival\cinestack-backend.tar
  docker save <db_image_name> > E:\Archival\cinestack-db.tar
  ```
  *(Note: Backend images involving AI packages can exceed 10GB. Ensure the destination drive has sufficient space.)*

## 3. Persistent Data Backup
Direct volume backup to ensure database and embedding state are preserved.

- **Postgres Volume**:
  ```powershell
  docker run --rm -v <volume_name>:/volume -v E:\Archival:/backup busybox tar cvf /backup/postgres_data.tar /volume
  ```
- **ChromaDB / Local Vectors**:
  ```powershell
  Compress-Archive -Path './backend/chroma_db' -DestinationPath 'E:\Archival\chroma_db.zip'
  ```

## 4. Documentation
Create a `README_ARCHIVE.md` summarizing:
- Final technical stack.
- Key optimizations (e.g., Cloud Oracle, RAM governance).
- Verification steps for restoration.
