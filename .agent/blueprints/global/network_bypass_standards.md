SCOPE: GLOBAL
ID: Network Bypass
CONTEXT: General FastAPI/Flutter

# Blueprint: Network Bypass Standards (Hybrid Dev)

This blueprint documents surgical strategies for bypassing environment abstractions when troubleshooting complex hybrid (Windows + WSL + Docker) network paths.

## 1. The "Direct-Hit" Rule
Always verify the API endpoint directly in the Windows browser before debugging Flutter or Backend code.
- **Goal:** Isolate whether the failure is at the OS Network layer (Firewall/DNS) or Application layer (Logic/CORS).
- **Test:** Navigate to `http://<WSL_IP>:<PORT>/health` in Chrome.

## 2. The "Surgical Bypass" Pattern
When `.env` loading or asset bundling is suspected of being stale, temporarily hardcode constants in the source code.
- **Protocol:**
  1. Comment out the `dotenv` lookup.
  2. Hardcode the absolute `baseUrl`.
  3. Add aggressive timeouts (`connectTimeout: 5s`) to provide faster loopback feedback.

## 3. The "Hybrid Gateway" Checklist
- **Windows Firewall:** Ensure Port 8001 is open for incoming WSL traffic.
- **CORS PNA Header:** Browser-to-WSL requests require `Access-Control-Allow-Private-Network: true`.
- **Internal DNS:** Docker-to-Docker connections must use the exact Service/Container name (e.g., `postgres_db-postgres_db-1`) or the internal IP (`172.x.x.x`).

## 4. Error Matrix (F12 DevTools)
| Error Content | Root Cause | Fix Action |
|---------------|------------|------------|
| `Connection Refused` | Port not listening or Firewall block | Check Docker port mapping / Firewall |
| `CORS Error` | Missing Origin headers | Update FastAPI `CORSMiddleware` |
| `PNA Block` | Missing Private Network header | Add `Access-Control-Allow-Private-Network` |
| `500 Internal Error` | Backend Logic/DB Crash | Check `docker logs` |

