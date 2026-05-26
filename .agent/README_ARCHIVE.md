# 📦 CineStack Project Archive

This document summarizes the final state of the CineStack project as of March 2026.

## 🌟 Final State: v2.7-premium-ux
The project has reached its stable milestone with a fully integrated 3-tier architecture.

### 🧠 Cloud Oracle via Gemini
- **Engine**: Powered by `gemini-1.5-flash` via LangChain.
- **RAG Architecture**: Uses ChromaDB for local vector storage, but offloads embedding generation to Google's cloud (`models/embedding-001`) to preserve local system resources.
- **Cinematic Intelligence**: The Oracle is tuned with specific narrative constraints to provide professional, review-style movie recommendations.

### ⚡ 16GB RAM Optimization
- **Cloud-Native Embeddings**: By using cloud APIs for heavy vector computations (embeddings/inference), the local footprint is kept minimal, allowing the full stack (Flutter, FastAPI, Postgres, ChromaDB) to run comfortably on 16GB RAM.
- **VRAM Governance**: A `gpu_semaphore` is implemented in the backend to prevent VRAM collisions between concurrent semantic search and chat operations.

## 📁 Archival Contents
- **Codebase**: Consolidated into the `main` branch.
- **Docker Images**: Exported as `.tar` files for portable deployment.
- **Persistent Data**: Database volumes (Postgres & ChromaDB) backed up as compressed archives.

---
*End of Line.*
