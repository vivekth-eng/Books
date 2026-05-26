---
trigger: always_on
---

# 📘 Project Rules & Constitution (Books Database)

> **USAGE INSTRUCTION:**
>
> - **PART 1 (Top)** is the Immutable Constitution.
> - **PART 2 (Bottom)** is the Project Cartridge (Native Windows Specifics).

---

## 🌐 PART 1: Global Constitution

- **Contract-First Logic:**
  - **MANDATORY SQL AUDIT**: Before adding any feature, you MUST run `psql` to check the current table structure.
  - **NULL-SAFETY BY DEFAULT**: All new Flutter models must be written as Nullable (?) with default values (e.g., `?? ''`) to handle legacy data without crashing.
  - **SCHEMA-BACKED CODING**: Every feature must include a synchronized block of SQL `ALTER TABLE`, FastAPI Pydantic schema, and Flutter model changes.
  - **PORT 8001 LOCK**: Always verify the network bridge (CORS/Port 8001) is active and responding before marking a task as "Done".

- **Architectural Integrity**
  - **Goal-First Logic:**
    Every turn must begin by referencing the **current phase** in `active_status.md`.

- **Scope Lock:**
  Agents are strictly forbidden from modifying files outside of:
  - `{{TARGET_FEATURE}}`
  - `backend/`
  unless explicitly authorized.

---

### 2. Shared Artifacts & Versioning

- **Source of Truth:**
  - Database Schema: `models.py` (SQLModel) & `schema.sql`.
  - Documentation: `{{DOC_STORAGE}}`.

- **Consistency:**
  Agents must use:
  - `Dio` (Frontend)
  - `SQLAlchemy` / `SQLModel` (Backend)

---

## ✂️ Part 2: PROJECT CARTRIDGE - "Books Database (Native Windows Protocol)" ✂️

### 1. The 3-Tier Objective

Build a highly optimized, local-first Books Database app ("LibriStack") using **Flutter (Web/Desktop)**, **FastAPI**, and **PostgreSQL 17**.

### 2. Native Connectivity & Host Constraints

- **IP Addressing:**
  - **Browser/Host:** `localhost` (`127.0.0.1`)
  - **API Root:** `{{APP_API_BASE_URL}}`
  - **Android Endpoint:** `{{APP_ANDROID_EMULATOR_URL}}`

- **Port Allocations:**
  - Frontend: `8080` (Debug)
  - Backend: `{{APP_API_PORT}}` (8001)
  - Database: `5432` (PostgreSQL 17 Service)

### 3. Data Schema Specifications

The **Design Lead** must ensure `models.py` matches the UI requirements:

- **Enum:**
  `interaction_score` (`0`: None, `1`: Reading, `2`: Completed, `3`: Favorite) mapped to UI state.
- **Toggle:**
  `is_reading_list` (`Boolean`)
- **Relations:**
  `book_id` (Integer) ForeignKey to `book.id`.

### 4. Implementation Rules

- **Auth:**
  Use `OAuth2PasswordBearer` in FastAPI. Tokens are JWT.
- **CORS:**
  Must allow `*` (or specific localhost origins) for Flutter development.
- **Google Books Integration:**
  Hydrate descriptions and cover URLs from Google Books volume API by ISBN.
- **Local Asset Storage:**
  Save covers locally under `assets/covers/` using standard name-and-isbn underscore sanitization to prevent routing breaks.
⚓