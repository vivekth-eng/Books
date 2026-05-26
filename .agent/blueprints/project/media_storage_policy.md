SCOPE: PROJECT
ID: Media Storage Policy
CONTEXT: Movie_DB_v1.1

# 📁 Media Storage Policy (Native Windows)

## 1. The Native Windows Standard
- **Exclusive Source of Truth:** `assets/posters/` relative to the project root.
- **Protocol:** All physical JPEG/PNG assets must reside in this directory. 
- **Prohibition:** Docker-style symlinks, relative pathing to external folders, and read-only bind mounts are strictly prohibited. The application interacts directly with the native Windows filesystem.

## 2. Directory Structure
```text
/ (Project Root)
├── backend/
├── assets/
│   └── posters/       <--- THE ABSOLUTE SOURCE OF TRUTH
├── .agent/            # Rules & Skills
└── .gitignore         # Hardened against media floods
```

## 3. Git Shielding
- **Standard:** The `.gitignore` must prevent large binary assets from entering version control while allowing the code that manages them.
- **Rule:** `assets/posters/` must be ignored, except for the `placeholder.jpg`.

## 4. Deterministic Ingestion & Sanitization
- **Standard:** Any script (TMDB Hydration, Ingestion) MUST verify the successful local write of an image to the "Source of Truth" before committing the filename to the `poster_local_path` column in PostgreSQL.
- **Fail-Fast:** If a file cannot be written due to permissions or disk space, the database record must remain `NULL`.
- **Underscore Sanitization (Bridge Rule):** All posters MUST be named using the `[clean_title]_[year].jpg` pattern. All non-alphanumeric characters (including spaces, colons, and hyphens) MUST be replaced by a single underscore `_` to prevent URI encoding issues in the Flutter UI.
  - *Example:* `Alien: Romulus` -> `alien_romulus_2024.jpg`

⚓
