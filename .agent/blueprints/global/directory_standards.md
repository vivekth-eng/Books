SCOPE: GLOBAL
ID: Directory Standards
CONTEXT: General Flutter/FastAPI

# 📂 Directory Standards: Monorepo Allocation

> **PURPOSE:** To maintain clear separation between runtime application logic, maintenance utilities, and database evolution.

## 1. Directory Topology

### `/backend/app`
- **Purpose**: Pure FastAPI runtime logic.
- **Contents**: Routes, SQLModel classes, authentication dependencies, database connection logic.
- **Constraint**: Must remain clean of audit scripts or maintenance tools.

### `/lib`
- **Purpose**: Flutter presentation and state management tier.
- **Contents**: Feature-first layouts (`lib/features/`), Riverpod providers, Dio networking, app entry `main.dart`.

### `/backend/scripts`
- **Purpose**: Maintenance, ingestion, and auditing utilities.
- **Contents**: 
  - `ingest_and_hydrate.py`: The primary data sync engine.
  - `scripts/lab/`: Experimental scripts or scratchpads (ignored by Git).

### `/backend/migrations`
- **Purpose**: Database schema "Source of Truth" via Alembic.
- **Contents**:
  - `migrations/alembic.ini`: Configuration.
  - `migrations/versions/`: Immutable SQL migration history.

### `/assets`
- **Purpose**: Local file assets.
- **Contents**: 
  - `books_master.xlsx` / `books_master.csv`: The Excel Single Source of Truth.
  - `covers/`: Sanitized cover image assets downloaded locally.

## 2. Ignore Policy
- `backend/scripts/lab/` must be included in `.gitignore` to prevent experimental code leaking.
- Cover assets (`assets/covers/`) should be kept locally or handled according to Git LFS/ignore standards if repository sizes are exceeded.

⚓
