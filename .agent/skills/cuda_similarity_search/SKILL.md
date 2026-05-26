---
name: CUDA Similarity Search
description: A dedicated skill for the RTX 4050 to handle 768d and 3072d Gemini vectors locally with GPU governance.
---

# CUDA Similarity Search Skill

## 🎯 Purpose
To provide high-performance conceptual search and recommendation capabilities by leveraging the RTX 4050’s CUDA cores. This skill handles both local 768-dimensional embeddings and high-dimensional 3072-dimensional Gemini vectors locally.

## 🛠️ Architecture: The 3-Tier Bridge

1. **Tier 1 (Presentation)**:
   - `SemanticSearchBar` widget triggers a standard `Dio` request.
   - Handles `AsyncValue` states for search results.

2. **Tier 2 (Application)**:
   - FastAPI endpoint utilizing `LocalSearchService`.
   - Supports 3072d vector processing using NumPy and PyTorch (accelerated by CUDA).
   - Implements "Hybrid Fallback" if similarity results are sparse.

3. **Tier 3 (Data)**:
   - PostgreSQL (pgvector) stores vectors.
   - Table schema must support both dimensions or be partitioned correctly.

## 🔋 GPU Governance & Memory Policy (RTX 4050)
- **VRAM Persistence**: Keep the model loaded if active, but offload if idle for > 300s.
- **Float16 Mandate**: Use FP16 for all 3072d dimension operations to save VRAM.
- **Cache Management**: Trigger `torch.cuda.empty_cache()` precisely during offloading.

## 🧪 Verification Protocol
- Run `nvidia-smi` to monitor VRAM.
- Verify dimensional alignment: Ensure 3072d vectors don't collide with 768d search paths.

⚓
