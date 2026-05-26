---
name: Native Windows Environment Management
description: Standards for managing .venv, PowerShell Execution Policies, and Windows Firewall.
---

# Native Windows Environment Management

This skill defines the standards for a pure Native Windows 11 high-performance setup without Docker or WSL overhead.

## 1. Python Virtual Environment (`.venv`)
- **Location strategy:** Utilize central environment management such as `C:\PythonEnvs` or local project `.venv`.
- **Initialization:** Use `python -m venv .venv`.
- **Activation:** `.\.venv\Scripts\Activate.ps1`. Ensure prompt reflects the activated environment before executing `pip install` or `uvicorn`.

## 2. PowerShell Execution Policies
- **Requirement:** Running scripts like `Activate.ps1` requires appropriate execution policies.
- **Command:** Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` as Admin if errors occur during activation.

## 4. Managed Background Processes
- **Mandate:** Always use a "Parent Lifecycle Script" (like `run_cinestack.ps1`) to manage background services.
- **Pattern:** Use a `try { ... } finally { ... }` block in PowerShell.
- **Start-Action:** Use `Start-Process -PassThru -WindowStyle Hidden` to track processes without terminal clutter.
  ```powershell
  $apiProc = Start-Process python -ArgumentList "backend/app/main.py" -PassThru -WindowStyle Hidden
  ```

## 5. Process Cleanup Module
- **Action:** Guaranteed cleanup in the `finally` block:
  ```powershell
  if ($null -ne $proc) { Stop-Process -Id $proc.Id -Force }
  ```
## 6. PowerShell Best Practices
- **Reserved Variables**: NEVER use reserved automatic variables as user-defined variables or loop iterators. Common reserved variables include:
    - `$pid` (The process ID of the current PowerShell session)
    - `$home` (Path to the user's home directory)
    - `$host` (The current host object)
    - `$profile` (Path to the current user's profile)
- **Variable Naming**: Always use descriptive, unique variable names (e.g., `$targetPid`, `$backendProc`, `$assetsPath`) to avoid collisions and improve script maintainability.
- **Error Handling**: Use `$ErrorActionPreference = "Stop"` and `try { ... } catch { ... }` blocks to ensure robust execution and graceful failures on Native Windows.

⚓
