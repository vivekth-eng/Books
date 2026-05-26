#!/bin/bash
# 🛠️ Skill: tunnel_handshake.sh

# Objective: Expose local WSL port 8001 to a public URL for Cloud-AI tools.

# Usage:
# 1. Run in Windows PowerShell:
#    npx localtunnel --port 8001

# 2. Capture the URL (e.g., https://fluffy-wolf-42.loca.lt)

# 3. Update mcp_config.json:
#    "url": "https://fluffy-wolf-42.loca.lt/openapi.json"

echo "Tunnel Protocol Initiated. Use the localtunnel URL for external AI access."
