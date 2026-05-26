SCOPE: GLOBAL
ID: Three-Tier Boilerplate
CONTEXT: General Flutter/FastAPI

# 🏗️ Master Project Blueprint: 3-Tier Architecture (v2)

> **Purpose:** A reusable resource base for future 3-tier projects, institutionalizing the **SQLModel + Freezed** architecture for 1-prompt feature implementations.

---

## 1. The "Handshake" Protocol (Contract-First)
**Goal:** Ensure 100% type safety and zero-error synchronization between Backend and Frontend.

1.  **Backend Definition:** Define the feature in `backend/models.py` using **SQLModel**.
2.  **DB Migration (Alembic):**
    - **Requirement:** All schema changes must use Alembic.
    - Generate: `alembic revision --autogenerate -m "feat: add feature_x"`
    - Apply: `alembic upgrade head`
3.  **Contract Export:** Verify `http://localhost:8000/openapi.json` or `backend/openapi.json`.
4.  **Frontend Inspection:** Read the schema to confirm field names and nullability.
5.  **Model/State Generation:** Update **Freezed** models and **@riverpod** providers.
6.  **Build Execution:** `flutter pub run build_runner build --delete-conflicting-outputs`.
7.  **Surgical Orchestration:** Only now implement the UI logic.

---

## 2. Network Handshake Standard (Localhost Loopback)
**Goal:** Ensure fast connectivity in Native Windows environments.

- **Mandatory Host Resolution:** All internal service communication (e.g., Backend to DB) MUST use Localhost Loopback (127.0.0.1).
- **Port Allocation**: API and Assets on Port **8001** (Unified Native Serve).
- **Service Parity:** Ensure the `DB_HOST` in the Application Tier exactly matches the Windows Native PostgreSQL 17 service address.


---

## 4. The Hybrid Media Protocol (Zero-Sync-Tax)
**Goal:** Prevent IO latency and connectivity regressions during high-volume asset streaming.

### A. The Native-Volume Rule
- **Definition:** All binary media (JPG, PNG, MP4) MUST reside in a dedicated Windows native folder, such as `movie_assets/`.
- **Reasoning:** Localhost streaming on Native Windows offers maximum IO performance.
- **Implementation:** Use local directory paths mapped to the FastAPI static file serving.

### B. The URL Normalization Standard
- **Definition:** Frontend builds must NEVER trust raw database strings for direct URL construction.
- **Standard:** Use a dedicated `MediaUrlBuilder` class in the Application Tier to:
    - Strip leading/trailing slashes.
    - Inject the dynamic API base URL.
    - Prevent "Double Slash" (e.g., `//assets`) 404 regressions.

---

- **Branch Creation:** Every new feature MUST begin with `git checkout -b feature/[name]` from a clean `main` branch.
- **No Collisions:** No two features shall share a branch. This prevents "Handshake Collisions" during the build process.
- **Atomic Commits:** Ensure each branch contains only the logic relevant to its specific feature.

---

## 2. Core Architectural Standards

### A. Backend: Unified Schemas (SQLModel)
- **Standard:** Use `SQLModel(table=True)` for entities.
- **Null-Safety:** Use type hints like `Optional[str] = Field(default=None)` to enforce explicit nullability in the API.
- **Efficiency:** endpoints should return SQLModel objects directly; FastAPI handles the serialization.

### B. Frontend: Immutable Models (Freezed)
- **Standard:** All domain models in `lib/features/.../domain/models/` must use **Freezed**.
- **Null-Safety:** Use `@Default()` for all optional fields to prevent `TypeError: null` crashes.
- **Contract Sync:** Ensure field names match `openapi.json` exactly (use `@JsonKey(name: '...')` if necessary).

### C. Presentation: Riverpod Generation (@riverpod)
- **Standard:** Use the `@riverpod` annotation for all providers to automate dependency injection and disposal.
- **Example (Functional Provider):**
  ```dart
  @riverpod
  Future<List<Item>> itemList(ItemListRef ref) async {
    final repository = ref.watch(itemRepositoryProvider);
    return repository.getItems();
  }
  ```
- **Example (Notifier Provider):**
  ```dart
  @riverpod
  class ItemFilterNotifier extends _$ItemFilterNotifier {
    @override
    ItemFilter build() => ItemFilter.all();
    void update(ItemFilter filter) => state = filter;
  }
  ```

### D. Reactive Invalidation (The Handshake)
- **Reads:** Use Riverpod `FutureProvider` (generated via `@riverpod`) for all GET requests.
- **Writes:** After a successful POST/PUT/DELETE, call `ref.invalidate(relevantProvider)` to trigger a server-side resync.
- **UI:** The UI must react to provider states via `.when()` or `ref.watch()`.

### E. Development Blockade (The Golden Rule)
> [!IMPORTANT]
> **NO UI CODE** shall be written until the Backend models are baked and Frontend models are regenerated. This prevents implementation against non-existent or stale contracts.

---

## 4. Checklist for Feature Implementation (The Hardened Build Order)

### Phase 1: Isolation (The Foundation)
- [ ] **1. Branch Creation:** `git checkout -b feature/[name]` from a clean `main` branch.

### Phase 2: Backend Architecture (The Definition)
- [ ] **2. Network Handshake:** Verify `DB_HOST` is set to `localhost` in `.env`.
- [ ] **3. Pre-Migration Audit:** Run `psql -h localhost -U [user] -c "SELECT 1;"` to verify connectivity to PostgreSQL 17 native service.
- [ ] **4. Database Migration:** Create and apply Alembic migration (`alembic revision --autogenerate`).
- [ ] **5. Application Tier:** Update `SQLModel` in `backend/models.py`. Ensure it's executed via the Windows Native `.venv` Python process.
- [ ] **6. OpenAPI Verify:** Ensure API responses match the definition in `main.py` directly from the Uvicorn host.

### Phase 3: Frontend Generation (The Sync)
- [ ] **5. Freezed Model:** Update the Flutter model in `domain/models/`.
- [ ] **6. Build Runner:** Execute `dart run build_runner build --delete-conflicting-outputs`.
- [ ] **7. Repository Tier:** Update repositories and Riverpod providers.

### Phase 4: Presentation Tier (The UI)
- [ ] **8. Widget Integration:** Build the UI reactively using the new providers.

---

## 5. Cleanup and Commit Rules
- **Generated Code:** Always commit `.g.dart` and `.freezed.dart` files to ensure build consistency across environments.
- **Data Privacy:** Database backups and SQLite files (e.g., `db_data_backup/`, `*.db`) must be strictly ignored in `.gitignore`.
- **Branch Hygiene:** Finalize feature development with a clean `build_runner` pass before merging.

---

## 6. Null-Safety Guardrails
- **Python:** `field: Optional[int] = None`
- **Dart:** `const factory Todo({@Default(0) int priority, ...}) = _Todo;`

👉 **Reference:** [Operational Standards](../rules/operational_standards.md) | [Architectural Handshake](../skills/architectural_handshake.md)
