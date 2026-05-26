SCOPE: GLOBAL
ID: Git Integrity
CONTEXT: General Developer Workflow

# ⚓ Git Integrity: The "Three-Tier Alignment" Rule

> **PURPOSE:** To ensure that all architectural tiers (UI, API, DB) are synchronized in every commit and branch transition.

## 🛠️ Mandatory Configuration & Lifecycle
- **STARTUP**: Every feature must include a local `.ps1` startup script check.
- **TEMPLATES**: The repository must provide `.ps1.example` templates for all local process management scripts.
- **HYGIENE**: Ensure `git status` reveals no un-ignored local `.ps1` files before marking a task as "Done".

## 1. The Synchronized Commit Protocol
No feature implementation is complete unless it includes:
1. **Tier 3 (DB)**: SQL migration or schema update confirmed in `models.py`.
2. **Tier 2 (API)**: Pydantic schemas and endpoints updated and verified via `/docs`.
3. **Tier 1 (UI)**: Models regenerated via `build_runner` and UI logic updated.

## 2. Integrity Verification (Native Windows)
Before pushing or merging, the Agent must verify:
- `Test-NetConnection -ComputerName localhost -Port 8000` (Frontend)
- `Test-NetConnection -ComputerName localhost -Port 8001` (Backend)
- `psql` connection to the local PostgreSQL 17 service is active.

## 3. The "Clean Bill of Health"
Every branch transition must be preceded by a "Clean Bill of Health" report, confirming all 3 tiers are functional and synchronized.

### 🏷️ Branch Naming
All branches must follow the `type/DDMMYY-N-slug` format defined in `git_management.md` to ensure chronological ordering and distinct daily indexing.

⚓
