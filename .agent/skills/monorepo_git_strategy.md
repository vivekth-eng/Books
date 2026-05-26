---
description: Guide for managing a 3-tier Monorepo with Atomic Commits.
---

# Monorepo Strategy & Git Protocols

This skill documents how to manage a 3-tier application (Flutter, FastAPI, PostgreSQL) within a single Git repository ("Monorepo").

## 1. Unified Structure

Maintain a clean root directory where each tier lives in its own folder but shares the same version control history.

```text
/ (Project Root)
├── lib/                 # Tier 1: Flutter Frontend
├── backend/             # Tier 2: FastAPI Backend (Junction to WSL)
├── schema.sql           # Tier 3: Database Schema
├── docker-compose.yml   # Orchestration
├── .gitignore           # Unified ignore rules
└── ARCHITECTURE.md      # System Overview
```

## 2. The "Atomic Commit" Philosophy

In a 3-tier system, a feature often spans all layers. Avoid committing tiers separately. Instead, group related changes into a single "Atomic Commit".

### Why?
- **Rollback Safety**: If a feature breaks, you revert one commit, and the entire stack (DB, API, UI) rolls back together.
- **Context**: The commit message explains the *feature*, not just "updated api".

### Example Workflow: "Adding a 'Priority' Field"
1.  **DB**: Add `priority` column to `todos` table in `models.py`.
2.  **Backend**: Update `TodoCreate` Pydantic model (`main.py`) to accept `priority`.
3.  **Frontend**: Add `PrioritySelector` widget (`add_task_sheet.dart`) and update `TodoRepository`.
4.  **Commit**:
    ```bash
    git add .
    git commit -m "feat: implement task priority (DB schema + API + UI)"
    ```

## 3. Handling the WSL Junction (`backend/`)

The `backend/` folder on Windows is a **Directory Junction** pointing to WSL.
- **Git Behavior**: Git treats it as a normal folder. Changes made inside the WSL container are instantly visible to Windows Git.
- **Action**: Run `git status` in the Windows root. You will see modifications from the Linux environment appear automatically.

## 4. Branching Strategy
- **`main`**: Production-ready. All 3 tiers must be verified (Green Handshake).
- **`feature/xyz`**: Development. Can have broken states during work, but must be "Atomic" before merging.

## 5. Pre-Commit Checklist
Before pushing:
1.  **Frontend**: `flutter analyze` clean?
2.  **Backend**: `docker compose up` healthy?
3.  **Integration**: Do the tiers talk? (Handshake Verification).
⚓
