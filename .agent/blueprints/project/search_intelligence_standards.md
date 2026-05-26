SCOPE: PROJECT
ID: Search Intelligence Standards
CONTEXT: Movie_DB_v1.2 / FastAPI / Gemini Cloud AI / Flutter
STATUS: 1,400/1,745 records Live (Cloud Primary)

# 🧠 Search Intelligence Standards

To ensure optimal performance and conceptual discovery on consumer hardware (Intel i5 / Poco X7 Pro), these standards must be strictly enforced.

## 1. The "Hybrid" Discovery Standard
- **Rule**: All search interfaces MUST default to **Exact Title Matching** to save compute and API quota.
- **Protocol**: Offer a toggle (Psychology/Brain icon) to enable **Semantic Search** for conceptual discovery (e.g., searching "80s space adventure").

## 2. The "Vector" Standard (Gemini Cloud)
- **Standard**: Semantic embeddings MUST use the `models/gemini-embedding-001` model (3072 dimensions).
- **Implementation**: Text as `"{title}. {description}"` for retrieval-optimized results.
- **Why?**: Replaces 768-dim local models to reclaim 2GB of system RAM on the 8GB i5 laptop.

## 3. The "Mobile-First" Debounce Rule
- **Standard**: To protect the local i5 CPU and respect Cloud API rate limits, debouncing must be context-aware.
- **Values**:
  - **Exact Mode**: 500ms debounce.
  - **Semantic Mode**: 700ms debounce (due to the round-trip latency to Google Cloud Vertex AI).

## 4. Cloud Execution Policy
- **Standard**: All vector processing MUST happen via the Gemini `embedContent` API.
- **Constraint**: `sentence-transformers` are permanently banned from the local environment to preserve system memory (baseline target: < 300MB).
- **Pacing**: A mandatory 10-second sleep daemon per batch must be implemented to respect the 15 RPM Free Tier quota.

## 5. Metadata Sync & Hydration
- **Rule: Resume-First Standard**: All cloud-sync operations for the 1,745 records must support "Resume from ID" or `WHERE embedding IS NOT NULL` filters to handle daily server-side quota blocks (1,500 requests/day).
- **Status Check**: Current hydration is at 1,400/1,745. The remaining 345 will be processed after the daily quota reset.

## 6. Performance & UX Guardrails
- **The "Cloud Latency" Rule**: Semantic search response time is ~800ms-1.2s due to the dual-hop between the local backend and Google's inference servers.
- **The "Top-K" Limit**: Semantic results MUST be limited to the Top 50 most relevant matches locally to maintain high scroll performance on the Poco X7 Pro.
- **i5-Guardrail**: `vmmemWSL` must remain below 400MB during active search sessions to ensure UI responsiveness.
