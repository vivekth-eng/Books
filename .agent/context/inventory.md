## 🗃️ .agent/context/inventory.md (Active Baseline)

### 1. Project Infrastructure

- **Infrastructure:** Native Windows (PostgreSQL 17 Service) — [MANDATORY]
- **Legacy:** Docker / WSL / VHDX — [DEPRECATED]
- **Storage:** `assets/covers/` (Local Windows Directory)
- **Backend:** `backend/` (Native Python 3.14.3 in `C:\PythonEnvs\.venv`)
- **Process Management:** Native Windows processes (PowerShell/CMD)

### 2. Operational Constants & Limits

| Placeholder           | Value             | Blueprint Match | Purpose                          |
| :-------------------- | :---------------- | :-------------- | :------------------------------- |
| `{{TIMEOUT_TIER_1}}`  | `10s`             | ✅              | Max duration for Edge Functions. |
| `{{WEB_INTEL_LIMIT}}` | `10 req/min`      | ✅              | Rate limit for research tools.   |
| `{{LINT_COMMAND}}`    | `flutter analyze` | ✅              | Atomic Refactor verification.    |
| `{{CLEANUP_COMMAND}}` | `flutter clean`   | ⚠️              | Ghost-Killer protocol.           |
| `{{PRIMARY_DEVICE}}`  | `Native Windows`  | ✅              | Optimized for 16GB RAM.          |
| `{{INTEL_TIER}}`      | `Postgres 17 + pgvector` | ✅         | Native vector search engine.     |
| `{{LOCAL_SEARCH_MODEL}}`| `all-mpnet-base-v2` | ✅         | 768-dim Semantic Search Model.   |
| `{{HOST_LOCAL_IP}}`   | `192.168.0.168`    | ✅         | Mobile Bridge IP (Port 8001).    |
| `{{WEB_RENDERER}}`    | `html`             | ✅         | Bypass CORS in Chrome.           |

_(Note: "Blueprint Match" indicates if the live value aligns with `master_plan.md`)_

### 3. Active Dependencies

- `flutter_riverpod: ^2.4.9`
- `fastapi: ^0.109.0`
- `psycopg2-binary: ^2.9.9` (Native Windows)
- `pgvector: (PostgreSQL Extension)`
- `sentence-transformers: ^2.5.1` (Local Inference)
- `pandas: ^2.2.0`
- `openpyxl: ^3.1.2`
- `requests: ^2.31.0`

### 4. Filesystem Map

| Category  | Path                 | Description                                      |
| :-------- | :------------------- | :----------------------------------------------- |
| **Brain** | `/.agent/`           | Rules, Context, and Agency Artifacts.            |
| **Temp**  | `/.agent/temp_logs/` | Disposable logs and WIP dumps.                   |
| **Specs** | `/.agent/*.md`       | Technical constraints, observability specs, etc. |
| **Prod**  | `/lib/`              | Flutter Source Code.                             |
| **Backend** | `/backend/`        | FastAPI Source Code.                             |

### 5. 3-Tier Sync Contract (Hardened)

- **Filtering:** 100% Server-Side. Flutter providers must not implement client-side filters (e.g., `where` clauses) for core categories.
- **Toggles:** Action-Based (`POST /books/{id}/toggle-reading-list`). Frontend must not send full object state for simple toggles.
- **State Invalidation:** UI must call `ref.invalidate()` immediately upon any successful `POST/PATCH` to maintain eventual consistency.
