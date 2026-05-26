# 📐 Modular Architecture Standards (CineStack)

## Authority: Project Manager
## Context: Performance & Resilience Standards for 3-Tier Flutter Apps

---

### 1. The "No-Scroll-Jump" Rule
- **Standard**: User UI interactions (Like, Love, Watchlist) MUST NOT trigger high-level provider invalidations (`ref.invalidate`).
- **Logic**: Use **Atomized State Mutation**. Update only the specific object in the local state list immediately after a successful API call.
- **Rationale**: Preserves the user's scroll position and eliminates unnecessary "Hydrating..." loading screens for simple state toggles.

---

### 2. The "Keyed-List" Mandate
- **Standard**: All scrollable surfaces containing infinite or paginated data (GridView, ListView) MUST utilize a `PageStorageKey`.
- **Constraint**: The key name must be unique to the feature (e.g., `PageStorageKey('movie_grid_paged')`).
- **Rationale**: Ensures the Flutter framework persists scroll offsets across widget tree rebuilds caused by navigation or modal overlays.

---

### 3. The "Smooth-Ingestion" Standard
- **Standard**: When new data pages are fetched, the new items must be **Appended** to the current state, never replace it.
- **Logic**: `state = AsyncData(current.copyWith(movies: [...current.movies, ...newMovies]))`
- **Rationale**: Maintains a contiguous scroll surface for large libraries (1,774+ movies).

---

### 4. Hardware-Aware Asset Optimization
- **Standard**: Applications running on high-performance hardware (16GB RAM+) must configure a minimum **50MB Image Cache**.
- **Implementation**: `PaintingBinding.instance.imageCache.maximumSize = 50 * 1024 * 1024;`
- **Rationale**: Prevents poster-reloading jitters when scrolling back through high-resolution cinematic assets.
