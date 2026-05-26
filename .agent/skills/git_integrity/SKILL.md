---
name: Git Integrity Check
description: Mandates a git branch and status check at session start to ensure 3-Tier alignment.
---

# Git Integrity Skill

## 🎯 Purpose
This skill ensures that the agent is working on the correct branch and that all local changes are accounted for, preventing "Version Drift" during multi-device development or migration.

## 🛠️ Mandatory Session Start Protocol

Every time a new session begins, or when hardware/environment changes are detected, the agent **MUST**:

1. **Check Local Status**:
   ```powershell
   git status
   ```
   *Goal: Ensure no uncommitted changes are blocking the workflow.*

2. **Audit Branches**:
   ```powershell
   git branch -a
   ```
   *Goal: Confirm the active branch matches the phase defined in `active_status.md`.*

3. **Verify Upstream Sync**:
   ```powershell
   git remote -v
   ```
   *Goal: Confirm the origin is correctly configured for pushing/pulling.*

## 🚨 Tier Alignment Check
If the active branch contains 3-Tier changes (SQL, API, UI), the agent must verify:
- **Alembic** (Tier 3) is at the latest revision.
- **SQLModel** (Tier 2) reflects the latest schema.
- **Build Runner** (Tier 1) has been executed to update Flutter models.

⚓
