# 🧠 Blueprint: Memory & Resource Governance (Native)

> **USAGE INSTRUCTION:** This blueprint defines the memory lifecycle for the CineStack 3-Tier Native Stack. It strictly prohibits legacy WSL/Docker memory patterns.

---

## 1. Zero-Virtualization Standard
- **Rule**: All memory allocation must be bound to the **Native Windows Heap**.
- **Requirement**: No `vmmem` or `WSL` memory balloons are permitted. 
- **Action**: If WSL is detected as a high-memory consumer, the agent must alert the user to shut down the WSL instance.

---

## 2. VRAM Lifecycle (RTX 4050 6GB)

### A. The "3GB Ceiling"
- **Rule**: ML model persistence must never exceed 3GB of dedicated VRAM.
- **Protocol**: 
    - Use half-precision (`float16`) for large embedding models.
    - Implement aggressive garbage collection using `gc.collect()` and `torch.cuda.empty_cache()` after non-frequent ML tasks.

### B. Lazy Initialization
- **Rule**: GPU-bound models must remain in state `UNINITIALIZED` until the first interactive request.
- **Goal**: Minimize VRAM footprint during standard metadata CRUD operations.

---

## 3. RAM Guardrails (16GB DDR5)

| Tier | Target Allocation | Peak Threshold |
|------|-------------------|----------------|
| **Tier 1 (Flutter/Chrome)** | 2GB - 4GB | 6GB (Heavy UI) |
| **Tier 2 (FastAPI/Torch)** | 1GB - 2GB | 4GB (Inference) |
| **Tier 3 (PostgreSQL)** | 500MB - 1GB | 2GB (Vacuum) |

- **Emergency Alert**: If total system RAM usage crosses **90%**, the agent must pause non-essential background tasks (like asset streaming) and prioritize active development work.

⚓
