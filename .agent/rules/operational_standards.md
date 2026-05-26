---
trigger: always_on
---

# 📍 Operational Standards: The Structural Glue

> **🚀 CORE RESOURCE:** For the full architectural blueprint and migration checklists, see the [Master Project Blueprint](../blueprints/three_tier_boilerplate.md).

## 1. Approved Directory Structure (Monorepo)

- **Goal:** Unify Frontend, Backend, and DB in a single version-controlled root.
- **Reference:** See `/.agent/context/inventory.md` for exact file paths.

```text
/ (Root)
├── .agent/              # The "Brain" (Rules, Skills, Context)
├── lib/                 # Tier 1: Flutter Frontend
│   ├── core/            # Shared Providers (Dio, Auth), Router
│   ├── features/        # Feature-First Architecture
├── backend/             # Tier 2: FastAPI Backend (Native .venv)
│   ├── main.py
│   ├── models.py        # SQLModel (Tier 2/3 Unified Def)
│   └── auth.py
└── schema.sql           # Tier 3: Database Schema (Reference)
```

## 2. The "Atomic Commit" Protocol (Mandatory)

**Definition:**
A single git commit that captures all dependent changes across Tiers 1, 2, and 3.

**Rule:**
NEVER commit a Frontend change that depends on a Backend API update without including the Backend update in the *same* commit.

**Checklist:**
1.  **DB/API**: Updated `models.py` (SQLModel)?
2.  **Contract**: Confirmed `/openapi.json` is live?
3.  **UI**: Regenerated Models (`build_runner`) & Updated Repository?
4.  -> **Commit**: `feat: add priority field (Full Stack)`

## 3. Coding Standards

### State Management (Riverpod)
- **Zero Logic in UI:** Widgets consume Providers only.
- **Repository Pattern:** UI never talks to `Dio` directly. Always use a Repository.

### Backend Logic (FastAPI)
- **Validation:** Trust nothing. Validation is done via SQLModel classes.
- **Security:** `dep_user` dependency required for all protected routes.

## 4. The "State-Sync" Handoff

- Every turn must end with an update to `active_status.md` reflecting the new 3-tier reality.

## 5. Action-Based Communication (Mandatory)

**Definition:**
All state transitions (excluding simple CRUD updates) must use dedicated Action Endpoints.

**Protocol:**
1.  **Trigger:** UI sends `POST /resource/{id}/action` (e.g., `/toggle-complete`).
2.  **Payload:** Body must be empty or contain *only* action-specific parameters (no full object state).
3.  **Visuals:** UI optimistically updates local state via `TodoRepository`, then invalidates the provider (`ref.invalidate`) to resync with the server's "Truth".

**Why?** reduces `422 Unprocessable Entity` errors by decoupling simple user intents from complex schema validation.

## 6. Event-Driven Refreshing (Mandatory)

**Rule:**
FORBID background polling timers (e.g., `while(true)` + `Future.delayed`) unless explicitly required for real-time tracking (e.g., a stopwatch or live countdown).

**Protocol:**
1.  **On-Demand:** All data fetches must be single-fire `Future` or `FutureProvider` operations.
2.  **Trigger:** Re-fetching of data must be triggered *specifically* by:
    - Initial app/page load.
    - User switching categories/tabs.
    - Action-Based Invalidations (`ref.invalidate`) after a state change.
3.  **Logging:** Terminal logs in debug mode should be concise and status-oriented, not payload-heavy.
## 7. Contract-First Development (Mandatory)

**Rule:** 
Every feature implementation MUST follow the **Contract-First Handshake**:
1.  **Define** the data model in `backend/models.py` using **SQLModel**.
2.  **Verify** the API contract via the auto-generated `/openapi.json`.
3.  **Generate** the client-side entities via `build_runner` BEFORE touching UI code.

**Why?** This prevents "Model Drift" where the frontend expects data that the backend doesn't provide, or vice versa.

## 8. 3-Tier Data Integrity (Architectural Enforcement)

### A. Unified Backend Schemas (SQLModel)
**Requirement:** Every backend model MUST use **SQLModel**. A single class defines both the database table and the Pydantic API schema. This eliminates logic drift between Tier 2 and Tier 3.

### B. Immutable Frontend Models (Freezed)
**Requirement:** Every frontend domain model MUST use **Freezed**. This ensures null-safety (via `@Default`) and immutable state management, preventing runtime type crashes.

### C. Development Blockade (High Priority)
**Rule:** No Presentation Tier (Flutter) UI code shall be written or edited until:
1.  The Application Tier (FastAPI/SQLModel) changes are confirmed live.
2.  The Presentation Tier Models have been successfully regenerated via `build_runner`.

**Why?** This blockade guarantees that the UI is always built against a verified, live API contract.

### D. Code Generation Mandate
**Requirement:** All state management and database changes must be handled via **Code Generation tools** (Alembic/Freezed/Riverpod Generator).
- **Mandatory:** Alembic for all Tier 3 database schema changes.
- **Mandatory:** Freezed for all Tier 1 domain models.
- **Mandatory:** Riverpod Generator (`@riverpod`) for all Tier 1 business logic and state.
- **Forbidden:** Manual SQL migrations or manual `fromJson`/`toJson` parsing logic.

**Why?** This ensures 100% architectural consistency and eliminates human error during synchronization.

## 9. AI Resource Prioritization (Developer Tasking)

**Mandate:**
During active LLM processing/inference periods (LLM active), the agent MUST prioritize **Static Analysis** and **Contract Audits** over **Runtime Testing** (e.g., full app builds or integration tests).

**Reasoning:**
- **VRAM Conservation:** Keep 6GB VRAM available for AI inference.
- **System Stability:** Prevent system-wide lag by avoiding heavy compilation/emulation cycles when the 16GB RAM threshold or 366GB SSD storage thresholds are near.

**Execution:**
1.  **Stage 1 (LLM Active):** Perform `flutter analyze`, `mypy`, or `psql` audits.
2.  **Stage 2 (LLM Idle):** Proceed to `flutter run` or `pytest` only AFTER verification that resources are below the 16GB/90% threshold.

⚓

