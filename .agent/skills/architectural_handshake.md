# 🤝 Skill: Architectural Handshake (Contract-First)

> **Goal:** Eliminate synchronization errors between non-relational frontend models and formal backend schemas.

## Core Expertise

### 1. Contract-First Design (FastAPI + SQLModel)
- **Pattern:** Use a single class in `backend/models.py` to define both the database table and the Pydantic API schema.
- **Benefit:** Eliminates the "Double-Entry" problem where changing a DB column requires a separate schema update.
- **Handshake:** The live `openapi.json` from FastAPI is the ONLY source of truth for the frontend.

### 2. Automated Type Safety (Freezed)
- **Pattern:** Use **Freezed** in Flutter to generate immutable data classes.
- **Benefit:** Standardizes `fromJson` parsing and provides strict null-safety via `@Default()`.
- **Constraint:** Never write manual `fromJson` logic. Always use `build_runner`.

### 3. State Efficiency (Riverpod Generator)
- **Pattern:** Use `@riverpod` annotations to generate both functional and class-based providers.
- **Benefit:** Automates dependency injection and disposal, and simplifies reactive invalidation.
- **Constraint:** Prefer `AsyncNotifier` for complex state transitions to avoid circular dependencies.

### 4. Data Versioning (Alembic)
- **Pattern:** All database schema changes MUST be tracked via Alembic migration scripts.
- **Benefit:** Enables version-controlled schema evolution and safe deployments across environments.
- **Workflow:** `alembic revision --autogenerate` -> `alembic upgrade head`.

### 5. Route Matching Parity
- **Pattern: Character-for-Character Audit**: Ensure the route string in the Backend `@app` decorator exactly matches the Frontend `_client` call (including leading/trailing slashes).
- **Tool: OpenAPI Handshake**: Use the live `openapi.json` to verify that endpoints are registered exactly as expected by the frontend.
- **Troubleshooting: Stale Container Flush**: If routes match in code but return 404, force a Docker rebuild (`--build`) to ensure the container is running the latest routing table.

### 7. Docker-to-Docker DNS Resolution
- **Pattern:** Use **Docker Service Names** (defined in `docker-compose.yml`) as hostnames for inter-container communication.
- **Benefit:** Resolves the "Step 9 Connection Hang" by bypassing the unreliable Host-OS DNS bridge for internal traffic.
- **Sync Tax (The 127.0.0.1 Pitfall):** Using `127.0.0.1` or `localhost` inside a container refers to the container ITSELF, not the Host or other services. This creates a "Sync Tax" in debugging time when services appear "up" but remain unreachable.

### 6. Git Feature Isolation (Surgical Reset)
- **Pattern:** Every new feature MUST begin with `git checkout -b feature/[name]` from a clean `main` branch.
- **Benefit:** Prevents "Handshake Collisions" and ensures a modular, reviewable repository.
- **Protocol:** If a branch contains mixed logic, use `git reset --hard` to isolate the target feature logic into its own dedicated branch.

**Rule:** No UI code is written until backend models are finalized and frontend entities are successfully regenerated. 

## 3-Tier Sync Checklist
1. **Tier 3 (DB):** Update `models.py` and run Alembic.
2. **Tier 2 (Logic):** Verify `openapi.json` is in sync.
3. **Tier 1 (Presentation):** Run `build_runner` and update the Repository.
