# ⚓ Blueprint: Git Hygiene & Presentation Standards

> **USAGE INSTRUCTION:** This blueprint defines the standards for code submission and UI architecture in the 1,774-movie library project.

---

## 1. Commit Hygiene

### A. The "Format-Before-Commit" Mandate
- **Rule**: No code shall be committed without running the appropriate formatter.
- **Protocol**:
    - **Flutter**: `dart format lib/`
    - **Backend**: `black backend/` (or equivalent formatter)
- **Validation**: Agents must ensure files are formatted before marking a task as "Done".

### B. The "Atomic Tiered" Commit
- **Standard**: Commit messages must reflect the tier-based changes.
- **Example**: `feat: add MOTD logic (UI + API + SQL)`

---

## 2. UI Presentation Standards

### A. The "Single-Return-Path" Rule
- **Standard**: Favor a single exit point in widget build methods to ensure consistent state management and debugging.
- **Goal**: Minimize "early return" patterns that lead to UI fragmentation or "Ghost Layouts".

### B. Asset-Aware Guarding
- **Rule**: All poster assets and media streams must use a `CachedNetworkImage` or a local file fallback with a shimmering loading state.
- **Standard**: The system must never show a "Broken Image" icon.

⚓
