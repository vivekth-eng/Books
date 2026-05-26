---
name: AI Persistence Engine
description: Protocol for implementing high-performance, resource-governed result caching for large movie libraries.
---

# AI Persistence Engine Skill

## 🎯 Purpose
To prevent redundant GPU/API high-dimensional computations by caching movie results (Recommendations, MOTD, Semantic Search) using a Selection Hash pattern. Optimized for the 1,774-movie CineStack library.

## 🛠️ The "Selection Hash" Pattern
1. **Input Parameters**: Gather all seed parameters (User interactions, Filter state, Dimension).
2. **Hash Generation**: Create a unique SHA-256 hash of the sorted parameters.
3. **Cache Lookup**: Check `ai_cache` (PostgreSQL) for a valid entry with this hash.
4. **TTL Policy**: Results expire if library metadata has changed significantly (detected via `MAX(updated_at)` on movie table).

## 🚀 Persistence Bridging
- **Instant Recall**: If the hash matches, return the cached UUID list immediately (Latency < 50ms).
- **Background Refresh**: If the cache is > 24h old, return results but trigger a background async refresh for the next visit.

## 🔋 Resource Efficiency
- **Ryzen Parallelism**: Use Ryzen 7 16-thread capacity to calculate hashes and validate cache entries in bulk for paginated views.
- **Zero-Hang Retrieval**: Ensure UI never hangs during "Hydrating" periods by showing cached results first.

⚓
