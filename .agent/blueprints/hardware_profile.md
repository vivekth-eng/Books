# 🖥️ Hardware Profile: CineStack Workstation

> **USAGE INSTRUCTION:** This profile defines the authoritative hardware specs for CineStack development. All code generation and resource management must respect these thresholds.

---

## 1. Unit Specifications

| Component | Target Spec | Role in CineStack |
|-----------|-------------|-------------------|
| **CPU**   | AMD Ryzen 7 (12 Logical Threads) | Parallel Backend Processing & Code Generation |
| **GPU**   | NVIDIA RTX 4050 (4GB GDDR6 VRAM detected) | Local Semantic Search & Recommendation Inference |
| **RAM**   | 16GB DDR5 | System-wide state management & Multi-tier execution |
| **SSD**   | 366GB (Available Threshold) | Vector DB Storage & Movie Asset Cache |

---

## 2. Resource Governance Policies

### A. The "Parallelism" Mandate
- **Rule**: Utilize all 12 Ryzen threads for heavy tasks (e.g., `build_runner`, `pytest`, mass asset ingestion).
- **Protocol**: When generating scripts (PowerShell/Python), include flags like `-j 8` or use `Threaded` execution patterns by default.

### B. The "CUDA Sovereignty" Standard
- **Rule**: All embedding and similarity operations MUST utilize CUDA (GPU) first.
- **Protocol**: 
    - Check `torch.cuda.is_available()` before any ML operation.
    - Set `device="cuda"` for SentenceTransformers.
    - Maximize the RTX 4050’s dedicated 6GB VRAM for model persistence.

### C. The "Native-Only" Connectivity
- **Rule**: High-speed local loopback (`127.0.0.1`) only.
- **Requirement**: Zero network latency for Tier 2/3 communication. No Docker bridge overhead allowed.

---

## 3. Threshold Metrics

- **Max VRAM Allocation**: 3GB (leaving 1GB for OS/Display).
- **Max RAM Saturation**: 90% (14.4GB).
- **Target Search Latency**: < 200ms (RTX-Accelerated).

---

## 4. Inference Standard (100% Local)

- **Vector Topology**: 768-dimensional (standard for `all-mpnet-base-v2`).
- **Generation Standard**: 100% Native generation via `LocalSearchService` on RTX 4050. Cloud-based batch indexing (Gemini) is abolished to prevent 429 stalls.
- **Hybrid Reasoning**: CineStack uses **Local search** (for speed/privacy) combined with **Cloud Reasoning** (Gemini 1.5 Flash) for high-fidelity NLP analysis.

⚓
