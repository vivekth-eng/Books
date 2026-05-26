# Skill: [CROSS_PLATFORM_CORS_STITCH]

## Purpose
Enabling a Windows Browser (Host) to fetch binary media or API data from a Linux Private Network (WSL/Docker) without security blockade.

## Context
Chrome's Private Network Access (PNA) policy blocks requests from `localhost` to private IP ranges unless specific headers are present.

## Pattern: The PNA Handshake

### 1. FastAPI Middleware (Tier 2)
```python
@app.middleware("http")
async def add_private_network_header(request, call_next):
    response = await call_next(request)
    if request.method == "OPTIONS":
        # Required for Chrome PNA policy
        response.headers["Access-Control-Allow-Private-Network"] = "true"
    return response
```

### 2. CORSMiddleware Sequence
- **Rule:** `CORSMiddleware` MUST be declared BEFORE `StaticFiles` mounts.
- **Rule:** `allow_origins` should include the specific Flutter Web origin (e.g., `http://localhost:8080`).

### 3. Header Verification
- `Access-Control-Allow-Private-Network: true`
- `Access-Control-Allow-Origin: [origin]`
- `Vary: Origin`
