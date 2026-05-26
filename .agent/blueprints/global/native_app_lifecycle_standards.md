# 🛡️ Native Windows Application Lifecycle Standards

## 🌐 1. Objective
Ensure every Native Windows project follows a standardized, resource-efficient, and professional process lifecycle. This prevents "Zombie" processes (background tasks that stay alive after the UI is closed) and minimizes developer friction.

## 📦 2. The Startup Engine (Parent Lifecycle Anchor)
Every application must include a single startup script (e.g., `run_app.ps1`) that acts as the lifecycle anchor. 

### Standards:
- **Dependency Audit**: Must verify that the required system services (PostgreSQL, Redis, etc.) are active before attempting to launch the app tiers.
- **Port Conflict Resolution**: Must perform a proactive `Get-NetTCPConnection` check on required Ports (e.g., 8000, 8001) and offer to force-close any processes currently holding those ports.
- **Silent Multi-Tier Launch**:
    - Backend tiers (API, Database Brokers, Asset Servers) must be launched using `Start-Process -WindowStyle Hidden` to reduce window clutter.
    - Capturing the `-PassThru` object is mandatory to track the process ID ($proc.Id).
- **Health Handshakes**: The script must perform a local network handshake (`Invoke-RestMethod` or `Test-NetConnection`) to verify that the background tiers are responding before the primary UI process is launched.

## 🧹 3. Determined Cleanup (The "Zombie Guard")
The lifecycle script must wrap the primary UI process in a `try/finally` block to ensure all background services are terminated upon exit.

### Standards:
- **ID Persistence**: Always use specific process objects ($proc.Id) for termination. **FORBIDDEN**: Using broad `Stop-Process -Name "python"` commands which may kill unrelated developer tools.
- **Automatic Port Release**: Ports held by background tiers must be released within 5 seconds of the primary UI process terminating.
- **Silent Cleanup**: Cleanup operations should provide feedback in the console without spawning new windows or popups.

## 📏 4. Environment Standardization
- **Local .venv Persistence**: Always resolve the local environment's Python executable from a known path or a standardized virtual environment name (`.venv`).
- **Templating**: Projects must provide a `run_project.ps1.example` (or similar) to ensure local paths can be customized without polluting the global codebase.

⚓
