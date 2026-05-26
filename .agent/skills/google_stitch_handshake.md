# 🛠️ Skill: [GOOGLE_STITCH_HANDSHAKE]

> **Context:** Used when Google Stitch (Cloud) needs to interact with a local FastAPI backend running in WSL/Windows.

## 📋 Protocol: Establishing the Bridge

### 1. Tunneling (WSL-to-Public)
Since cloud tools cannot access `172.x.x.x` IPs directy:
- **Action:** Initiate a secure tunnel.
- **Command:** `ngrok http 8001` (run in WSL).
- **Verification:** Capture the generated `.ngrok-free.app` URL.

### 2. Configuration Injection
- **Target:** `mcp_config.json`
- **Action:** Update the `stitch` server configuration to point to the public tunnel URL.
- **JSON Snippet:**
```json
{
  "mcpServers": {
    "stitch": {
      "command": "wsl",
      "args": ["npx", "-y", "@_davideast/stitch-mcp", "proxy", "--url", "https://<ngrok-id>.ngrok-free.app/openapi.json"]
    }
  }
}
```

### 3. PNA Header Enforcement
- **Constraint:** Chrome blocks public-to-private requests by default.
- **Solution:** Inject the following middleware into `main.py`:
```python
# fastapi_pna_middleware_snippet.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_headers=["*"],
    expose_headers=["Access-Control-Allow-Private-Network"],
)
```
> [!IMPORTANT]  
> The `expose_headers` or an explicit preflight handler for `OPTIONS` must set `Access-Control-Allow-Private-Network: true`.

## 🚀 Troubleshooting the Handshake
- **403 Forbidden:** Ensure ngrok is not using an "Account Required" landing page (use `ngrok http 8001 --host-header=rewrite`).
- **404 Not Found:** Verify the tunnel URL correctly appends `/openapi.json`.
- **CORS Errors:** Verify `allow_origins=["*"]` in FastAPI `CORSMiddleware`.
