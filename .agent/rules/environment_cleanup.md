# Rule: Antigravity Environment Cleanup (Native Windows)

## Trigger
- **Frequency**: Once a week.
- **Size Threshold**: Run if `~/.gemini/antigravity` exceeds 2GB.
- **SSD Threshold**: Run if free SSD space falls below 366GB.

## Action
Run the native cleanup script to reclaim space while preserving project logic.

```powershell
# Native Cleanup Sequence
Remove-Item -Recurse -Force **/(__pycache__|.pytest_cache)
flutter clean
# Optional: Clear Windows temp
Remove-Item -Path "$env:TEMP\antigravity-*" -ErrorAction SilentlyContinue
```

## Policy
1. **Container Veto**: `docker system prune` and similar commands are forbidden.
2. **Native Focus**: Prioritize cleaning `.venv/`, `__pycache__/`, and `build/` (Flutter) if space is critical.
3. **Storage Monitoring**: Alert if the `movie_assets/` folder exceeds 50GB.
