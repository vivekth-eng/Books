---
trigger: always_on
---

# Rule: Project Cost Efficiency

## 1. Local-First Development (The "Free Tier")

**Mandate:**
Prioritize **Local Native Development** over Cloud Resources to eliminate infrastructure costs during dev/test.

### Strategies:

| Component   | Cost Strategy               | Role in CineStack                                      |
|-------------|----------------------------|--------------------------------------------------------|
| Database    | PostgreSQL 17 (Native)     | Stores movie metadata & user watchlists.               |
| Storage     | Local Filesystem (movie_assets)| Stores high-res posters and Excel source files.        |
| UI Design   | Google Stitch (Free Tier)  | Provides the interface blueprint via MCP server.       |
| Backend     | Native FastAPI (.venv)     | Acts as the logic broker between data and UI.          |

- **Local API:**
  Run FastAPI locally (Port 8001) as a native Windows process. Do not deploy to cloud (Lambda/Fly.io) until Production release.

## 2. The Blueprint + Flash Workflow

**Mandate:** Use **Gemini 3 Flash** for all tasks covered by `master_plan.md`.

### Triggers for Pro (Escalation):
- Architectural pivots not in the Blueprint.
- Debugging circular dependencies > 2 iterations.

## 3. Token Saving Strategies

- **Inventory First:** Check `inventory.md` before importing new packages.
- **Concise Artifacts:** Output only the "Delta" (Changed lines) for file edits.
- **Context Caching:** Cache `master_plan.md` for multi-turn Sprint executions.
⚓