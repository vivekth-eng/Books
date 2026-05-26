# 📘 Blueprint: Testing & Validation Protocol (Resilient Startup)

> **USAGE INSTRUCTION:** This blueprint defines the standards for backend stability and service initialization in the CineStack 3-Tier Native Stack.

---

## 1. The "Resilient Startup" Standard

### A. The "Lazy-Brain" Mandate
- **Rule**: All GPU-intensive or heavy resource services (Recommendations, Oracle, Vector Inference) must utilize **Lazy Initialization**.
- **Execution**: The service object should be created at the module level, but its resource-heavy components (Device context, VRAM allocation, Model loading) must be deferred until the first method call.
- **Why**: Ensures the Port 8000/8001 health check takes priority over ML readiness, allowing the frontend to load immediate UI states while the "Brain" warms up in the background.

### B. The "Handshake-First" Rule
- **Rule**: No secondary feature is allowed to block the `main.py` entry point or the `/health` endpoint.
- **Protocol**: 
    1. FastAPI `main.py` must only perform vital router registrations.
    2. Use `app.add_event_handler("startup", ...)` for any non-blocking verification or pre-computation.
    3. The `/health` endpoint must return `{"status": "healthy"}` based purely on connectivity to the Database, not on ML model status.

### C. The "Clean-Log" Policy
- **Rule**: Startup failures must be diagnostic and transparent.
- **Action**: Any termination of the `run_cinestack.ps1` lifecycle during the health check phase MUST automatically dump the last 20 lines of the `backend_stderr.log` to the primary terminal.
- **Target**: Zero "Silent Crashes".

---

## 2. Resource & VRAM Governance

- **VRAM Ceiling**: Monitor and confirm that `vmmemWSL` (if applicable) or native PyTorch overhead remains below the **4GB ceiling** during initialization.
- **RTX 4050 Safety**: Services must explicitly check `torch.cuda.is_available()` and handle `RuntimeError` (e.g., OOM) with a clean transition to CPU rather than a process crash.

---

## 3. Atomic Validation Checklist

Every major backend change must be verified against this audit:
1.  **Handshake**: Does `Invoke-RestMethod` to `:8000/health` succeed in < 5s?
2.  **Modular Drift**: Is there any circular dependency between `app.api` and `app.features`?
3.  **Log Hygiene**: Are the `.log` files in the project root clean of `ImportError` or `ModuleNotFoundError`?
