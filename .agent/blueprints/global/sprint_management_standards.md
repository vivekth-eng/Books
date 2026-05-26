SCOPE: GLOBAL
ID: Sprint Management
CONTEXT: General Developer Workflow

# 🚦 Phased Feature Rollout Strategy

## Sprint Management Standards

1.  **The "One-Feature" Rule**: Only one major architectural change (e.g., a new database column or a new asset pipeline) should be implemented per PM command.
2.  **The "Validation" Rule**: Every sprint must conclude with a verification of the 1,738 records on the Intel i5 host and the Poco X7 Pro client.
3.  **The "Gemini Flash" Efficiency**: Use the Flash model for rapid iterations and code generation during each sprint to keep development momentum high.
4.  **Network Handshake Priority**: Stability of the 3-tier bridge (Flutter <-> FastAPI <-> PostgreSQL) is paramount. No new feature shall be implemented if the health handshake fails.

## 🏁 Definition of Done (DoD) - Native Windows
A feature is "Done" when:
1. **Connectivity**: `Test-NetConnection` successfully reaches Ports 8000 and 8001.
2. **UI Integrity**: No `RenderFlex` overflows are present in the target screens.
3. **Atomic Sync**: Tier 3 (DB), Tier 2 (API), and Tier 1 (UI) changes are captured in a single commit.
4. **Clean Logs**: No `CRITICAL` or `ERROR` level logs are generated during basic path testing.

⚓
