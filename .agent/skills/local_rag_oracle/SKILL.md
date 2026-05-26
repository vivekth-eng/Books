---
name: Local RAG Oracle Implementation
description: Protocol for implementing high-performance, resource-governed RAG systems on local hardware (Ollama + ChromaDB).
---

# Local RAG Oracle: Architectural Standards

This skill documents the implementation of the "Cinematic Oracle," a local Retrieval-Augmented Generation (RAG) system optimized for 16GB RAM/6GB VRAM environments.

## 🛠️ Technical Stack
- **Engine**: Ollama (Llama 3.1)
- **Framework**: LangChain (Python/FastAPI)
- **Vector Store**: ChromaDB (Persistent local storage)
- **Embeddings**: `all-MiniLM-L6-v2` (Hugging Face)

## 🏗️ Core Patterns

### 1. Intent-Aware Prompting (Scenario A/B)
The system avoids generic chat behaviors by explicitly categorizing user intent within the system prompt.
- **Scenario A (Listing)**: Triggered by "suggest," "recommend," or plural requests. Delivers high-density bulleted lists with `TITLE:` and `Loc:` headers.
- **Scenario B (Summarization)**: Triggered by requests for plots or specific film details. Delivers scannable, atmospheric summaries.
- **Sanitization Rule**: No emojis (🎬, etc.) to prevent rendering issues in terminal-driven or older browser environments.

### 2. Resource Governance (The 16GB Baseline)
To maintain system stability alongside Flutter Debug and Docker:
- **`num_ctx: 2048`**: Balances reasoning depth with memory safety.
- **`keep_alive: 5m`**: Prevents constant model reloading while freeing VRAM during idle periods.
- **`Flash Attention: 1`**: Enables efficient inference on NVIDIA consumer GPUs.
- **60-Word Threshold**: Strict prompt constraint to minimize token generation time and prevent system lag.

### 3. Metadata-Embedded Ingestion
Search context is enriched by flattening metadata directly into the searchable text chunk.
- **Format**: `MOVIE: {title}. DESCRIPTION: {description}. Loc: {disk_id}`
- **Chunking Strategy**: `chunk_size: 1000`, `overlap: 100` via `RecursiveCharacterTextSplitter`. This ensures that even descriptive summaries have enough adjacent context to be accurate.

## 🌉 Integration Protocol
In this workspace, the "Oracle" is the primary interface for complex data retrieval. 
- **Rule**: Prefer semantic search (Oracle) over standard SQL `LIKE %pattern%` queries for user-facing discovery or natural language intent.
- **Handoff**: Any UI change must accompany a verification of the `Thinking...` pulse in `OracleChatPanel.dart`.
