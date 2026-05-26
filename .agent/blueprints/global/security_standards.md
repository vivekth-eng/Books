SCOPE: GLOBAL
ID: Security Standards
CONTEXT: General Developer Workflow

# 🔒 Security Standards: Environment Hygiene

> **PURPOSE:** To protect sensitive credentials and environment-specific data from being leaked into the source control repository.

## 1. The "Template" Rule
Every project tier requiring environment variables must provide a `.env.example` file.
- **Content**: Contains all required keys with dummy or instructional values.
- **Tracking**: The `.env.example` file is tracked by Git.
- **Usage**: Developers copy the example to a local `.env` and populate it with their specific values.

## 2. The "Secret" Rule
The actual `.env` files containing secrets (API keys, DB passwords, WSL IPs) must NEVER be committed.
- **Tracking**: Strictly ignored via `.gitignore`.
- **Pre-Commit Check**: The `scripts/ext_audit.py` should warn if any `.env` file is accidentally staged.

## 3. Exclusion Guard
Reinforce the `.gitignore` with the following block to shield secrets:
```gitignore
# Ignore all environment variables and secrets
.env
.env.*
!.env.example
```

## 4. Remediation Protocol
If a `.env` file is accidentally committed, it must be removed from the index immediately:
```bash
git rm -r --cached **/.env
```
> [!WARNING]
> If a secret has been pushed to a remote repository, consider it compromised and rotate the credentials immediately.

⚓

