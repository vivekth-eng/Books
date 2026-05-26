# Skill: Native Network Resilience (Windows 11)

## Context
Standard protocols for eliminating `DioException`, `XMLHttpRequest` failures, and IPv6 resolution lag in the Native Windows 3-tier architecture.

## 1. CORS Protocol (FastAPI)
Every backend must include a strict but multi-port inclusive CORS setup. Wildcards (`*`) are FORBIDDEN when `allow_credentials=True`.

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    # Standardize on 127.0.0.1 to avoid Windows 11 'localhost' resolution overhead
    allow_origin_regex=r"http://(127\.0\.0\.1|localhost)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 2. Process Verification (Pre-Flight)
Before initializing the Flutter app or running integration tests, verify the backend state via PowerShell:

- **Check API (8000)**: `netstat -ano | findstr :8000`
- **Check Assets (8001)**: `netstat -ano | findstr :8001`
- **Audit**: If no PID is returned, the service is DOWN. Use `./run_cinestack.ps1` to restart.

## 3. Chrome Private Network Access (PNA)
Modern Chrome requires specific headers for `localhost` -> `localhost` communication.

```python
@app.middleware("http")
async def add_private_network_header(request, call_next):
    response = await call_next(request)
    response.headers["Access-Control-Allow-Private-Network"] = "true"
    return response
```

## 4. IDE Lifecycle Management
- **Issue**: VS Code or Cursor may terminate the backend process without clearing the Port binding.
- **Action**: If "Address already in use" occurs, run:
  ```powershell
  Stop-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess -Force
  ```

## 5. Error Interpretation
- **XMLHttpRequest Error**: 95% of the time, this is a **CORS Mismatch** or **Service Down** event on Native Windows.
- **DioException [connection error]**: 100% of the time, this implies the server is not listening on the expected IP/Port.
- **Status 429 [Quota Limit]**: Specifically indicates a Google AI Quota Hit. TRIGGER: UI-friendly countdown timer (60s) for the user.

## 6. Premium Quota Handling
When a 429 occurs, the backend MUST alert the frontend. The frontend should:
1. Show a "Cooling Down" overlay.
2. Display a countdown timer (default 60s).
3. Auto-retry once the timer hits zero.

⚓
