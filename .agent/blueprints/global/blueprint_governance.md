SCOPE: GLOBAL
ID: Blueprint Governance
CONTEXT: General Developer Workflow

# 🏛️ Blueprint Governance

This document defines the rules for maintaining the `/.agent/blueprints/` directory structure, ensuring that generalized best practices are portable, and project-specific paths never leak into our "Developer Profile."

## 1. The Hierarchical Structure

The `/.agent/blueprints/` directory is strictly divided into two silos:

-   **/global/**: Contains portable, project-agnostic rules (e.g., Python PEP8 standards, Flutter Riverpod architecture, Git hygiene). These form the core Developer Profile.
-   **/project/**: Contains context-heavy, project-specific rules (e.g., WSL to Windows poster pathing for a specific app, integration scripts with hardcoded API keys).

## 2. The Header Mandate

**EVERY** markdown file in the `/.agent/blueprints/` directory (and its subdirectories) MUST start with this 3-line type tag:

```text
SCOPE: [GLOBAL | PROJECT]
ID: [Standard Name]
CONTEXT: [General Technology / Specific Project Version]
```

## 3. The "No Leakage" Rule

-   **Path Agnostic:** Files in `global/` must NEVER contain hardcoded user directory paths (`C:\Users\name\...` or `/home/name/...`), absolute IP addresses related to a specific local setup, or highly specific database table names designed for a single app.
-   **Variables:** If a global standard requires path referencing, it must use bracketed placeholders (e.g., `{{ROOT_DIR}}`, `{{DOCKER_MOUNT_PATH}}`) to be hydrated natively by the active workflow.

## 4. Promotion / Demotion

-   If a `project/` rule is found to be useful across multiple apps (e.g., a specific way we handle Dio interceptors), it must be stripped of its project-specific URLs/paths and moved to `global/`.
-   If a `global/` rule becomes bloated with exceptions for a specific app, that section must be extracted into a `project/` standard.
