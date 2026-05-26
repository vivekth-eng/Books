---
description: Advanced Git management for Windows-WSL hybrid environments.
---

# Git Management (Hybrid Protocols)

This skill codifies the protections required to maintain Git performance and directory integrity in a "Windows Host + WSL Backend" development environment.

## 🛡️ [HYBRID_GIT_PERFORMANCE_PROTECTION]

Cross-OS metadata operations (reading file properties from Windows on WSL-mounted folders) cause significant I/O hangs when dealing with large asset counts (e.g., 1,700+ images).

### 1. The "Logical Lock" Policy
To prevent system instability, the following commands are **STRICTLY FORBIDDEN** in heavy-asset directories (e.g., `backend/assets/posters/`):

- **DO NOT** run `ls -la` or `dir /s`. Metadata retrieval for thousands of files across the network bridge is a blocking operation.
- **DO NOT** run `git add .` if untracked assets are present. Git will attempt to calculate hashes for every file, leading to a "Git Hang".

### 2. SSoT .gitignore Enforcement
Before executing **any** bulk Git operation (`git add`, `git clean`, `git status`), the Agent **MUST** verify `.gitignore` integrity.

- **Mandatory Check**: Ensure `**/assets/posters/` or similar heavy paths are explicitly ignored.
- **Verification Command**: 
  ```powershell
  git check-ignore <path/to/asset.jpg>
  ```

## 🔗 Syncing WSL and Windows
When the backend is physically moved or symlinked, Git tracking may break if `.git` directories are nested.

- **Monorepo Rule**: There must be ONLY ONE `.git` directory at the project root.
- **Cleanup**: Physically remove `.git` folders from sub-projects (`movies_frontend`, `movies_backend`) once unified.

## 🚀 SSoT Execution Loop
1. **Audit**: Check `.gitignore` for asset exclusion.
2. **Target**: Use specific pathspecs (e.g., `git add lib/`) instead of global `.` when possible.
3. **Commit**: Use Atomic Commits across the 3-tier structure.

## 🏷️ Commit & Branch Standards (Native Windows)

### 1. Branch Naming Convention (Chronological)
Branches must follow the `type/DDMMYY-N-description` format:
- `feat/DDMMYY-N-feature-name` (e.g., `feat/220326-01-tmdb-hydration`)
- `fix/DDMMYY-N-bug-description` (e.g., `fix/220326-02-cors-handshake`)
- `refactor/DDMMYY-N-component`

**Hierarchical Sorting**: Use a two-digit index (`01`, `02`, etc.) to maintain chronological order and uniqueness for multiple branches created on the same day.

### 2. Commit Tagging (3-Tier)
Commits must be tagged by the primary tier affected:
- `feat(api):` New backend logic.
- `fix(ui):` UI bugs or layout fixes.
- `docs(db):` Schema documentation or SQL updates.
- `feat(global):` Cross-tier atomic releases or configuration changes.

⚓
