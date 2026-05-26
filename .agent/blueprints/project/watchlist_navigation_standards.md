SCOPE: PROJECT
ID: Watchlist Navigation Standards
CONTEXT: Movie_DB_v1.1

# 🔖 Watchlist Navigation Standards

> **MANDATE:** Ensure the Watchlist experience is distinct, persistent, and performance-optimized.

## 1. The "Persistence" Rule

**Rule:** The user's selection between "All Movies" and "Watchlist" views should be saved to local storage.

- **Objective:** Provide a seamless return experience (e.g., if a user only wants to see their favorites).
- **Implementation:** Use `shared_preferences` or similar local storage in the `FilterController`.

## 2. The "Zero-State" Rule

**Rule:** An empty watchlist must never result in a "Broken" or "Blank" UI state.

- **Action:** Implement a specific "Zero-State" graphic and copy (e.g., "Your watchlist is empty. Add movies from the main grid.").
- **Goal:** Drive user engagement by explaining *how* to use the feature.

## 3. The "i5" Performance Rule (Server-Side Filtering)

**Rule:** Global filtering (like "Only Watchlist") **MUST** be performed at the PostgreSQL level.

- **Reason:** Even with 1,738 records, client-side filtering in Flutter memory can cause jank on lower-end devices or increase initial load times.
- **Handshake:** `GET /movies?is_watchlist=true` should be the only source of truth.
⚓

