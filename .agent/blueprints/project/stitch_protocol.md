SCOPE: PROJECT
ID: Stitch Protocol
CONTEXT: Movie_DB_v1.1

# 📘 Stitch Protocol: Cloud-to-Local Bridge

> **Mandate:** Always use a public tunnel for Cloud-AI UI tools; internal WSL IPs are inherently unreachable from public cloud contexts.

## 🌍 The Connectivity Truths
1. **IP Isolation:** Google Stitch and similar cloud tools cannot "see" private WSL IP ranges (172.x.x.x).
2. **Mandatory Tunneling:** A public HTTPS endpoint (via ngrok or localtunnel) is the ONLY reliable way to bridge the gap.
3. **PNA Security:** Modern browsers require explicit `Access-Control-Allow-Private-Network` headers for cloud-to-local requests.
4. **Poco X7 Pro Context:** For mobile UI testing, the device and the backend must share the same tunnel URL to bypass network isolation.

## 🛠️ Operational Setup
- **Tunnel:** `npx localtunnel --port 8001`
- **Config:** Update `mcp_config.json` with the generated `.loca.lt` URL.
- **Verification:** Ensure `/openapi.json` is reachable via the tunnel.

