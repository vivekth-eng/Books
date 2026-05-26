---
description: Protocol for resolving code drift between Windows and WSL environments.
---

# Code Drift Management (Sync & Purge)

In hybrid development (Windows + WSL), "Code Drift" occurs when two versions of the same component (e.g., backend) evolve separately. This protocol defines how to resolve it.

## 1. Detection
Symptoms of drift:
- "Works on my machine" but fails in Docker.
- Missing files in one environment.
- `requirements.txt` mismatch (e.g., Windows has specific binaries, Linux has others).

## 2. The "Sync & Purge" Workflow

### Phase 1: Audit & Compare
Use file comparison logic to identify the "Superior Version".
- **Criteria**:
    - Which version supports the production OS (Linux)?
    - Which version has the most recent logical updates?
    - Which `requirements.txt` is Docker-compatible?

### Phase 2: Unify (The Handshake)
Once the Superior Version (usually WSL/Linux) is identified:
1.  **Migrate**: Copy unique logic from the *Inferior* (Windows) to the *Superior* (WSL).
2.  **Verify**: Run a "Handshake Audit" on the Superior version to ensure it works.

### Phase 3: Purge
**Ruthlessly eliminate the inferior copy.**
- **Archive**: Rename `backend` to `backend_legacy` (temporary safety net).
- **Junction**: Replace the local folder with a Directory Junction to the Superior path.
- **Delete**: Once verified, delete `backend_legacy`.

## 3. Prevention
- **Single Source of Truth**: NEVER maintain two copies. Always use Junctions.
- **Automated Checks**: Periodically run diff checks if not using Junctions.

## 4. Emergency Command
If you suspect drift, run the `Code Sync and Purge` PM command to automate this process.
⚓
