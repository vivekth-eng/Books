---
trigger: always_on
---

# 🚦 Master Orchestration Plan (3-Tier Hybrid - Native)

> **USAGE INSTRUCTION:**
>
> - **PART 1:** Global Workflow.
> - **PART 2:** Project Schedule (Movies Database).

---

## 🌐 PART 1: The Assembly Line

### 🚀 Phase 0: Orchestration (Native) [COMPLETE]
- **Objective:** Verify Native Windows Services (Postgres 17) and Local Python `.venv`.
- **Legacy Purge**: Docker/WSL infrastructure removed. [COMPLETE]

### 📦 Phase 0.5: Migration (Vector Transition) [COMPLETE]
- **Current Goal**: Implement Hybrid Search (SQL + pgvector) on Native Stack.
- **Target**: Move semantic vector data to PostgreSQL `pgvector`. [COMPLETE]

### 📅 Phase 1: Definition
- **Design Lead:** Define Pydantic Models (`main.py`) and UI Widgets.
- **Handoff:** `schema.sql`, `wireframe.txt`.

### 🛠️ Phase 2: Implementation (Atomic)
- **Builder:** Implement Backend Endpoint -> Update Logic -> Update UI Repository.
- **Rule:** Atomic Commit required. No Docker/WSL commands allowed.

### 🧪 Phase 3: Validation
- **Tester:** Verify "Health Handshake" on `localhost`. Run `alignment_audit.py`.

---

✂️ ------------------ PROJECT ROADMAP: Movies Database ------------------ ✂️

## 📍 PART 2: Strategic Roadmap

### 🟢 v1.0: The "Hardened Core" (MVP) [COMPLETED]
- **Stack:** Flutter + FastAPI + Postgres (Native).
- **Auth:** JWT (Email/Pass).
- **Features:** CRUD Todos, Dynamic Lists.
- **LEGACY PURGE**: Docker/WSL infrastructure removed. [COMPLETED]

### 🔵 v1.1: Feature Expansion [CURRENT]
- **Objective:** Enhance Task Metadata and UX.
- **Tasks:**
  - [x] **MIGRATION**: Execute `chromadb` to `pgvector` handover. [COMPLETE]
  - [x] **ASSETS**: End-to-End Asset Streaming (Port 8001). [COMPLETE]
  - [x] **POSTERS**: Native Poster Discovery & Self-Healing. [OPERATIONAL]
  - [/] **VISUAL POLISH**: Phase 9: Visual Polish (Cinematic Premium). [IN_PROGRESS]

  - [ ] Add "Description" field to UI (Backend ready).
  - [ ] Implement "Smart Lists" (Today, Upcoming).
  - [ ] Add "Tags" support (Relation: `todo_tags`).

### 🟣 v1.2: Enterprise Features
- **Objective:** Multi-user collaboration.
- **Tasks:**
  - [ ] Shared Lists.
  - [ ] Audit Logs UI.

---
⚓