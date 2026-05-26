# Resource Management Standards: Native Windows Strategy

To ensure optimal performance on Native Windows 11 (16GB RAM threshold), the following standards must be adhered to.

## 1. The "Stateless-AI" Rule
- **Mandate**: The local backend MUST NEVER load large AI models (e.g., Torch, Transformers) into RAM.
- **Implementation**: Use external MCP servers or Cloud APIs (Google Gemini/Vertex AI) for embeddings and inference.
- **Benefit**: Reclaims ~2GB+ of system memory that would otherwise be consumed by heavy Python processes.

### 2. Resource Constraints & AI Strategy

- **Rule: Zero-Local-Tensor**: `torch` and `sentence-transformers` are permanently banned from the local environment to preserve system memory (baseline target: < 300MB idle).
- **Rule: Cloud-First Standard**: All heavy AI operations (embeddings, summaries, discovery) must be offloaded to Cloud APIs.
- **Rule: Zero-Local-AI Standard**: With 1,700+ movies, any attempt to run local sentence-transformers is a critical resource violation for the 16GB RAM threshold when balanced with Flutter and Chromium processes.
- **Rule: Baseline Reset**: If system performance degrades, monitor `python.exe` processes and restart the backend `.venv` if memory leak is suspected.
- **Rule: Native Performance**: Prioritize native SSD I/O paths (e.g., `C:/movie_assets`) over networked or virtualized storage.

## 3. The "Strict Handshake" Protocol
- **Mandate**: Every movie record fetched by the Tier 2 Backend MUST undergo a deterministic asset verification.
- **Rule**: If `poster_local_path` is `NULL`, empty, or points to a non-existent physical file, the record MUST be flagged as "Hydration Pending".
- **UX Guarantee**: The system will NEVER display a broken asset icon. It must fallback to `placeholder.jpg` or trigger a background TMDB hydration if valid metadata is present.

## 4. The "Batch-Checkpoint" Standard
- **Mandate**: Any bulk data operation (e.g., TMDB hydration, embedding generation) exceeding 100 records MUST implement "Save-and-Resume" logic.
- **Implementation**: Commit each record/batch individually to ensure persistence in a Native Windows environment subject to reboots.

## 5. Resilience & Quota Guardrails
- **Rule**: High-cost operations (Cloud AI/TMDB API) must be throttled to avoid hitting rate limits.
- **Rule**: Implement a local cache for TMDB responses to prevent redundant network calls during the 1:1 deterministic mapping verification.

## 6. Environment Baseline (Native Windows)
- **Target**: Total RAM usage for Backend + Postgres should stay below 1.5GB combined during idle.
- **Verification**: PowerShell `Get-Process python, postgres | Measure-Object -Property WorkingSet -Sum`.

## 7. Network Health Check Initialization
- **Rule**: All network-dependent features MUST implement a `Connection Health Check` endpoint (`/health`) that returns the 3-tier handshake status (DB Connected, API Ready).
## 10. Process Management & Port Recovery
- **Standard**: To recover from "Zombie" processes on Native Windows, always use a non-colliding variable (e.g., `$targetPid`) when iterating through `Get-NetTCPConnection` owners.
- **Action**: Use `(Get-NetTCPConnection -LocalPort 8000).OwningProcess` to identify the specific PID locking Port 8000 or 8001.
- **Safety**: Apply `Stop-Process -Force` with explicit `-Id` targeting to ensure zero drift and immediate port release.

⚓
