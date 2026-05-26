# 📐 Testing Standards (CineStack)

## Authority: Project Manager
## Context: Power-User Standards for Native 3-Tier Execution

---

### 1. The "Thread-Sovereignty" Rule
- **Standard**: When running bulk re-vectorization tests or data ingestion audits, `pytest` must limit threads to **n-4**.
- **Rationale**: This preserves 4 threads on the Ryzen 7 to keep the Flutter UI and OS responsive during long test runs.

---

### 2. The "VRAM Flush" Mandate
- **Standard**: All Inference and Semantic tests MUST include a teardown function to clear the RTX 4050 cache.
- **Logic**: `import torch; torch.cuda.empty_cache()`
- **Rationale**: Prevents VRAM fragmentation and ensures subsequent AI tasks (like the CineStack Oracle) have full access to the 6GB VRAM.

---

### 3. The "Mock-by-Default" Standard
- **Standard**: Live Gemini API and TMDB calls are STRICTLY FORBIDDEN by default.
- **Requirement**: All external calls must be gated by the `@pytest.mark.live_api` marker.
- **Enforcement**: CI/CD and default local runs MUST use the mocks provided in `conftest.py` to preserve the 1,500-request daily quota.

---

### 4. The "Surgical" Sanitization Rule
- **Standard**: Titles containing special characters (`:`, `?`, `*`, `[`, `]`) must be verified against the physical file system.
- **Protocol**: If `slugify(title)` does not match an existing `.jpg` in `movie_assets/posters`, the test must fail and log the "Ghost Poster" mismatch.

---

### 5. Thread-Safety & Lifecycle Standards
- **The "Microtask" Rule**: Any provider state modification triggered by a UI event (scroll, navigation, init) MUST be encapsulated in a `Future.microtask` or `addPostFrameCallback` to prevent frame-collision errors.
- **The "Navigation-Idempotency" Standard**: Returning to a screen must never trigger a "Full Fetch" if valid data is already present in the provider, preserving the user's focus and scroll position.
- **The "Zero-setState-in-Build" Mandate**: Agents are strictly forbidden from calling logic that updates providers directly within a widget's build method or a `NotificationListener` without an asynchronous delay.
