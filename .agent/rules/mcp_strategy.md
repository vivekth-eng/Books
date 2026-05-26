# MCP Strategy: 3-Tier Architecture

## 1. Service Discovery Protocol
The AI Agent must understand the network topology between Host (Windows) and Guest (Docker/WSL).

- **Tier 1 (Host)**: The Agent operates here.
- **Tier 2 (Container)**: `fastapi-backend` running on `localhost:8001` (Mapped).
- **Tier 3 (Container)**: `postgres-db` running on `localhost:5432` (Mapped).

### Rule: "The Host is the Client"
- When inspecting the DB, use `localhost:5432`.
- When inspecting the API, use `localhost:8001`.
- Do NOT try to connect to internal Docker IPs (172.x) unless diagnosing bridge networking.

## 2. Port Management & Conflicts
- **Port 8001**: Reserved for FastAPI Backend (Host mapping).
- **Port 5432**: Reserved for PostgreSQL (Host mapping).
- **Conflict Resolution**: If ports are busy, inspect `docker ps` first. Do not blindly change `.env` ports without Agent confirmation.

## 3. Environment Synchronization
- **Source of Truth**: `backend/.env` is the master config.
- **Propagation**: Changes to `.env` require a `docker compose up -d --build` to take effect.
- **MCP Context**: The Agent must reload its file context after any environment variable change to ensure it doesn't use stale secrets.

## 4. Tool Usage Guidelines
- **Database**: Use the `postgres` server for query validation, but prefer `docker exec` for admin tasks (backups, restores).
- **Filesystem**: Restrict edits to `backend/` and `lib/`. Do not touch `node_modules` or `.dart_tool`.
- **Logs**: Always check `docker logs fastapi-backend` before assuming a code error.
