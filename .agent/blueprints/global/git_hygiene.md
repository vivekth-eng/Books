SCOPE: GLOBAL
ID: Git Hygiene
CONTEXT: General Developer Workflow

# 🧹 Git Hygiene: The "Binary vs. Logic" Rule

> **PURPOSE:** To ensure the Git repository remains a clean record of application logic, free from environment memory and large static assets.

## 1. The Core Rule

- **Logic Tier (Tracked)**: Source code (`/lib`, `/backend`, `/frontend`), schema definitions, and production configurations are always tracked.
- **Environment Tier (Ignored)**: Internal AI memory (`/.agent/`), local logs, and development-only experiments are strictly excluded from the repository.
- **Data Tier (Ignored)**: Large binary assets (`/data/`) are never committed to Git; they are managed via external volumes or hydration scripts.
- **Native Windows Tier (Ignored)**: System-generated artifacts (`Thumbs.db`, `desktop.ini`), Python environments (`.venv/`, `__pycache__`), and VSCode/Antigravity metadata are strictly excluded.

## 2. Pre-Commit Verification
Before executing any commit, the Agent must:
1. Run `git status`.
2. Verify that no files from `/.agent/`, `/data/`, `.venv/`, or binary artifacts are listed under "Changes to be committed" or "Untracked files".

### 📜 PowerShell Startup Standards
- **Exclusion**: All local `.ps1` startup scripts (e.g., `run_app.ps1`, `run_cinestack.ps1`) MUST be ignored by `.gitignore` to prevent specific machine paths from leaking into the repository.
- **Templating**: Always provide a `run_app.ps1.example` or `run_project.ps1.example` with generic paths (e.g., `{{PYTHON_EXE}}`).
- **Standardized Ignored Extensions**: `.ps1`, `.venv/`, `__pycache__`, `.env`.

## 3. Exclusion Protocol
If a sensitive directory accidentally enters the Git index:
```bash
git rm -r --cached <directory_path>
```
Followed by an immediate update to `.gitignore`.

⚓
