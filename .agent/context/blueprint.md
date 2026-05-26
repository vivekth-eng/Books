# Movies Database Architectural Blueprint

## 🏛️ The Hardened 3-Tier Stack
- **Tier 3 (Data):** PostgreSQL (`book_database`) running in `postgres_db` container + SQLModel + Alembic.
- **Tier 2 (App):** FastAPI + SQLModel in `backend` folder  + Pandas (Excel Ingestion).
- **Tier 1 (Presentation):** Flutter + Freezed.

## 📜 Hardened Developer Habits
- **Development Blockade:** No UI code until the Backend API contract is live.
- **Media Asset Handshake:** Before UI implementation, verify image availability via `/posters/{filename}` route.
- **Surgical Isolation:** `backend/assets/posters` is the authoritative local blob store.
- **Image Serving:** FastAPI `StaticFiles` serves assets with long-lived caching.
- **SSoT:** Excel file is the source for data; posters are matched by unidecoded titles.
- **Null-Safety:** All models must be Freezed/SQLModel; images use BlurHash placeholders.

## 🔑 Secret Access & Networking
- **Backend Secrets:** Root `.env` file (Gitignored).
- **Frontend Secrets:** `assets/env/.env` (Gitignored).
- **Networking:** - Internal: `postgres://user_name:password123@postgres_db:5432/book_database`
- External (Android): `http://10.0.2.2:8000`
