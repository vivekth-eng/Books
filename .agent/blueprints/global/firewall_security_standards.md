SCOPE: GLOBAL
ID: Firewall Security
CONTEXT: General Flutter/FastAPI

# Blueprint: Firewall & Security Standards (Hybrid 3-Tier)

This blueprint documents mandatory security and networking protocols for ensuring a seamless "Handshake" in hybrid environments (Windows + WSL + Docker).

## 1. The "0.0.0.0" Mandate
All backend services running in Docker/WSL must bind to `0.0.0.0`, not `localhost`.
- **Reason:** `localhost` within WSL only listens to internal WSL traffic. `0.0.0.0` allows the Windows host browser to reach the service via the WSL Virtual IP.

## 2. Windows Firewall Protocol
Windows Defender Firewall often blocks incoming traffic from the WSL network interface.
- **Action:** Create a targeted inbound rule for the API port.
- **Command:**
  ```powershell
  New-NetFirewallRule -DisplayName "WSL-3-Tier-Bridge" -Direction Inbound -LocalPort 8001 -Protocol TCP -Action Allow
  ```

## 3. The "PNA invitation" Requirement
Chrome/Edge require explicit permission for requests from `localhost` to private network IPs (WSL/LAN).
- **Middleware:** FastAPI must include:
  - `Access-Control-Allow-Private-Network: true` in the response headers.
  - Recognition of the `Access-Control-Request-Private-Network` pre-flight header.

## 4. Port Inventory
| Service | Port | Binding | Security Context |
|---------|------|---------|------------------|
| Frontend | 8080 | Localhost | Public |
| Backend | 8001 | 0.0.0.0 | Private Network Gateway |
| Database | 5432 | 127.0.0.1 | Internal Only (No Public Access) |

## 5. Troubleshooting Matrix
- **DioException (Connection Refused):** Check port binding (`netstat`) and Windows Firewall.
- **DioException (CORS):** Check `CORSMiddleware` origins.
- **DioException (PNA):** Check `Access-Control-Allow-Private-Network` header.

