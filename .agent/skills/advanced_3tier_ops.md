---
description: Advanced operations for Environment, Orchestration, and Health Checks.
---

# Advanced 3-Tier Operations

This skill covers the "Day 2" operations of running a production-grade 3-tier system locally.

## 1. Environment Parity (.env)
Variables must be portable but secure.
- **`variables.md`**: The dictionary. Defines *what* variables exist (e.g., `APP_DB_HOST`).
- **`.env` (GitIgnored)**: The secrets. Contains actual passwords.
- **Docker Injection**:
    ```yaml
    # docker-compose.yml
    services:
      backend:
        env_file:
          - ./backend/.env
    ```
- **Rule**: Never hardcode secrets in `docker-compose.yml`. Always use `env_file`.

## 2. Service Orchestration
Ensure services start in order. The DB must be ready before the Backend starts.

```yaml
services:
  backend:
    depends_on:
      db:
        condition: service_started
    # For advanced production setup, use:
    # condition: service_healthy (requires healthcheck in DB service)
```

## 3. Health Check Automation
Don't guess if it works. Verify it.

### The "3-Tier Handshake" Script
Create a python script (`handshake.py`) that:
1.  **Tier 3 Check**: Pings the DB port (5432).
2.  **Tier 2 Check**: POSTs to `/login` to verify API + DB Auth.
3.  **Tier 1 Check**: Uses `dio` (or curl) to fetch `/todos`.

### Usage
```bash
python scripts/handshake.py
# Output:
# [DB] Connected ✅
# [API] Auth Valid ✅
# [SYS] Status: GREEN 🟢
```

## 4. Networking Magic
- **Host <-> Docker**: Use `localhost` (mapped ports).
- **Docker <-> Docker**: Use **Service Names** (`db`, `backend`).
    - *Example*: Backend connects to `postgres://user:pass@db:5432/db`.
- **Flutter <-> Docker**: Use `localhost` (if Chrome) or `10.0.2.2` (if Android Emulator).
⚓
