SCOPE: GLOBAL
ID: Project Structure
CONTEXT: Native Windows 11 (Monorepo)

# 🏗️ Project Structure: Monorepo Standard (Native)

> **PURPOSE:** To maintain a high-fidelity monorepo structure optimized for Native Windows 11, separating Flutter (Tier 1) and FastAPI (Tier 2).

## 1. Directory Topology

```text
/ (Project Root)
├── .agent/              # Rules, Blueprints, Skills, Context
├── lib/                 # Tier 1: Flutter Source (NATIVE)
├── backend/             # Tier 2: FastAPI Source (NATIVE .venv)
├── assets/              # Global Asset Store (Posters, Excel)
├── scripts/             # Native Lifecycle Management (run_cinestack.ps1)
├── .git/                # Version control
├── .gitignore           # Global ignores
├── .env                 # Variables (Root & Backend)
└── pubspec.yaml         # Flutter config
```

## 2. Pathing & Execution Constraints (Native)

### A. Asset Serving
The backend MUST serve assets from the monorepo root:
- **Mount Point**: `Root/assets`
- **FastAPI Config**: `app.mount("/assets", StaticFiles(directory=ASSETS_PATH))`
- **Standard**: All database entries for `poster_local_path` must be relative to this mount (e.g., `/assets/posters/movie.jpg`).

### B. Poster Integrity Check (Mandatory)
The backend `on_startup` sequence MUST verify the visibility of static assets.
- **Log Pattern**: `POSTER INTEGRITY: Found X visible assets...`
- **Trigger**: Any drop in asset count below the expected 1,700 threshold triggers a critical alert.

### C. Execution Context
- **Backend**: Run from `backend/` using the native `.venv`.
- **Frontend**: Run from the root using `flutter run` (Standard CLI).

⚓
