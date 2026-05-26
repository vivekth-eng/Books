# Skill: Media Handling & Optimization (Native Windows)

## Context
This skill defines the standard for high-performance media handling in the Native Windows 3-tier CineStack architecture.

## Implementation Standards

### 1. The Media Widget (Flutter)
Always use `CachedNetworkImage` for movie posters to minimize bandwidth and latency.
- **Placeholder:** Use `BlurHash` for a premium loading experience.
- **Error State:** Fallback to a themed placeholder or "image not found" asset.
- **Fit:** Use `BoxFit.cover` for grid posters.
- **Origin Mandate:** All media URLs MUST target `127.0.0.1:8001` (Static Assets) directly to prevent IPv6 resolution lag.

```dart
CachedNetworkImage(
  imageUrl: "http://127.0.0.1:8001/posters/${movie.posterUrl}",
  placeholder: (context, url) => AspectRatio(
    aspectRatio: 2/3,
    child: BlurHash(hash: movie.blurHash ?? 'L6PZfS_f.AyD_N%MIp4n%May4m%M'),
  ),
  errorWidget: (context, url, error) => const Icon(Icons.movie_filter),
  fit: BoxFit.cover,
)
```

### 2. Backend Asset Serving (FastAPI - Native)
- **Mount Point:** `app.mount("/posters", StaticFiles(directory=Config.POSTER_DIR), name="posters")`
- **Port Isolation:** Assets MUST be served on **Port 8001**, separate from the API on **Port 8000**.
- **CORS Protocol:** The Asset Server (8001) MUST explicitly declare its origin as distinct from the API (8000).
- **Cache-Control:** Ensure the middleware adds `Cache-Control: public, max-age=31536000` for all asset requests.

### 3. Windows Path Normalization
- **Standard:** Use `pathlib` for all asset path resolution to handle Windows backslashes (`\`) and drive letters (e.g., `C:\`).
- **IP Target:** Hardcode internal health checks and service-to-service calls to `127.0.0.1` to bypass Windows 11 `localhost` resolution overhead.

### 4. Deterministic Asset Guarantee
- **Rule:** If a database record exists with a non-null `poster_local_path`, the system GUARANTEES the physical presence of that file. 
- **Validation:** High-volume ingestions must verify disk-write before DB commit. 
- **Fallback:** Runtime logic must fallback to `placeholder.jpg` on Port 8001 if a mapping is broken (see `media_serving_standards.md`).

⚓
