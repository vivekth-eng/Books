---
trigger: always_on
---

# ☁️ Deployment Architecture: 3-Tier Hybrid (Native Windows)

> **USAGE INSTRUCTION:** This document defines the **Native-Only** standard. Containerization (Docker/WSL) is strictly prohibited.

---

## 🌐 PART 1: Global Deployment Standards (Native-Only)

### 1. Infrastructure Hierarchy (The 3-Tier Model)

#### Tier 1: Presentation (Client)
- **Platform:** Flutter Desktop/Web.
- **Connection:** `localhost:8001` (API).

#### Tier 2: Logic (API)
- **Platform:** FastAPI running as a Native Windows Process.
- **Environment:** Managed via local `.venv`.

#### Tier 3: Data (Persistence)
- **Platform:** PostgreSQL 17 running as a Windows Service.
- **Location:** Bound to `127.0.0.1`.

---

### 2. The "Native Shield" Policy
- **FORBIDDEN**: `docker`, `docker-compose`, `WSL`, `containerd`.
- **MANDATORY**: Any resource-intensive background task must check the 16GB RAM, 6GB VRAM, and 366GB SSD thresholds before execution.
- **STORAGE**: All assets must reside in `movie_assets/` on the native filesystem.

---

### 3. Development Workflow (Native Performance)

- **Source of Truth:**
  The Windows Filesystem is the authoritative source for all code. Virtual disks (VHDX) are abolished.

- **Zero-Virtualization Tax:**
  All performance is dedicated to native execution. Development tools (IDEs, debuggers) interact directly with native processes.

---

✂️ ------------------ PROJECT BLUEPRINT: Movies Database ------------------ ✂️

## Part 2. Project-Specific Architecture: "Movies Database"

### 1. System Topology

The Alpha-Todo system implements a **Local-First Native 3-Tier Monorepo**.

- **Frontend:** Flutter (`lib/`) running natively.
- **Backend:** FastAPI (`backend/`) running as a native Python process (`localhost:{{APP_API_PORT}}`).
- **Database:** PostgreSQL 17 running as a Windows Service (`localhost:5432`).

### 2. Service Discovery & Networking

- **Unified Loopback:**
  All tiers communicate via `localhost` (127.0.0.1).
- **Endpoints:**
  - **API:** `{{APP_API_BASE_URL}}`
  - **Postgres:** `postgres://{{APP_DB_USER}}:{{APP_DB_PASS}}@localhost:5432/{{APP_DB_NAME}}`

### 3. Project Variable Mapping

These specific keys must be present in `/.agent/context/variables.md` for this blueprint to function:

| Placeholder             | Alpha-Todo Mapping                    |
|-------------------------|---------------------------------------|
| `{{TIER_1_PLATFORM}}`   | Flutter (Riverpod)                    |
| `{{TIER_2_PLATFORM}}`   | FastAPI (Python 3.14.3)               |
| `{{TIER_3_PLATFORM}}`   | PostgreSQL 17 (Native)                |
| `{{LOG_TABLE}}`         | `logs` (SQL Table)                    |
⚓
