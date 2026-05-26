# Modular Architecture Standards (CineStack)

This blueprint defines the communication and synchronization standards between disparate features in the CineStack modular architecture.

## 1. The "Invalidation-Bridge" Protocol
- Features are permitted to invalidate providers belonging to other features (e.g., the `sync` feature invalidating the `movie_grid_provider` in the `movie` feature).
- **MANDATORY**: Cross-feature invalidation MUST occur via the public feature entry point (e.g., `import 'package:movies_frontend/features/movie/movie.dart'`).
- Direct imports of internal presentation providers from other features are strictly forbidden to prevent modular drift.

## 2. The "SSOT-Reactive" Mandate
- Any operation that modifies the **Excel SSOT** or the **PostgreSQL movie table** (e.g., a "Sync Data" action) MUST trigger a state invalidation of the primary consumer providers:
    - `movieGridProvider`
    - `genreListProvider`
    - `diskListProvider`
- Validation logic must be implemented in the `SyncController` or the relevant feature controller to guarantee the UI reflects the "Source of Truth" instantly.

## 3. The "Ghost-Field" Prevention (2026+ Releases)
- UI components (Movie Cards, Details Panels) must implement safe fallbacks for movies with pending metadata.
- **Placeholder Standard**: The ingestion pipeline will populate missing metadata for future releases ($\ge 2026$) with `[TBD: TMDB Pending]`.
- Widgets MUST check for this string and display a themed placeholder (e.g., a "Coming Soon" badge or blurred description) rather than crashing or showing empty space.

## 4. The "Year-Buffer" Rule
- TMDB enrichment for films released in **2025 or earlier** requires an **exact year match**.
- Enrichment for films released in **2026 or later** allows for a **$\pm 1$ year buffer** during the search verification phase to account for scheduled release shifts.

## 5. The "Export-Gate" Standard
- Features are strictly forbidden from importing internal files from other features.
- All cross-feature communication must use the public `[feature_name].dart` entry point (the "Feature Gate").
- This prevents circular dependencies and provides a clean, documented interface for feature interaction.

## 6. The "Package-URI" Mandate
- Agents must exclusively use `package:movies_frontend/...` for all cross-feature imports.
- Relative imports (e.g., `../../movie/...`) are banned for cross-feature access as they break dependency tracking and modular isolation.
- Standard Package URIs ensure the Antigravity IDE correctly registers the dependency tree across the 16GB hardware environment.

