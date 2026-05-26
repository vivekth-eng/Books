---
trigger: always_on
---

# 📡 Monitoring & Alerting Policy

> **USAGE INSTRUCTION:**
>
> - **Part 1** are GLOBAL standards.
> - **Part 2** is PROJECT-SPECIFIC (Movies Database 3-Tier).

---

## 🌐 Part 1. Global Logging Standards

### Central Storage
- All telemetry must be routed to the **Database Logs Table**.
- The primary destination is `{{LOG_TABLE}}` (SQL).

### Standardized Schema (SQL)
```sql
CREATE TABLE {{LOG_TABLE}} (
    id UUID PRIMARY KEY,
    level VARCHAR NOT NULL, -- INFO, WARNING, ERROR, CRITICAL
    message VARCHAR NOT NULL,
    context JSONB,          -- { "method": "GET", "path": "/todos", "duration": 0.12 }
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔗 Traceability
- **Trace ID:** Although optional for local dev, `trace_id` should be preferred for complex flows.

---

## 🚨 2. Severity Matrix

| Level     | Definition                                      | Action                                |
|-----------|-------------------------------------------------|---------------------------------------|
| CRITICAL  | DB or API Down (Handshake Failed)               | Restart Windows Services / .venv      |
| HIGH      | Business Logic Error (e.g., Auth failure)       | Fix Code                              |
| MEDIUM    | 4xx Client Errors (Validation)                  | Check Frontend                        |
| LOW       | Routine Access Logs                             | Ignore / Rotate                       |

---

## 🌐 3. Operational Integrity: The "Health Handshake"

**Mechanism:**
The system integrity is verified via a "3-Tier Handshake".

**Protocol:**
1.  **Tier 3 Check:** Can Backend reach DB? (SQLAlchemy connection).
2.  **Tier 2 Check:** Can Frontend reach Backend? (`/health` or `/docs` ok).
3.  **Tier 1 Check:** Does `GET /todos` return 200 OK?
*(Check `/.agent/context/variables.md` for specific `APP_API_PORT` to verify).*

**Veto Rule:**
If the Handshake fails, NO feature development can proceed. The Agent must switch to **RECOVERY MODE**.

---

✂️ ------------------ PROJECT SPECIFIC RULES ------------------ ✂️

## Part 2. Project-Specific Monitoring: "Movies Database"

### 1. Telemetry Targets

- **API Latency:** Target `< 200ms` for standard CRUD operations.
- **DB Connection:** Ensure `APP_DB_HOST` (localhost) resolves correctly for Native Postgres. <!-- test -->

### 2. Auth Monitoring

- **Login Failures:** Log `WARNING` on failed auth attempts.
- **Token Expiry:** Frontend should handle 401 gracefully via Interceptor.

### 3. Resource Governance (Ryzen 7 16GB RAM & RTX 4050 6GB VRAM)

- **16GB Threshold:** System-wide RAM must be monitored.
- **366GB SSD Threshold:** Monitor SSD space to ensure we remain within the 366GB limits for models and DB.
- **Critical Alert:** Trigger a suggestion to close browser tabs if `Flutter (Chrome)` + `FastAPI` + `Ollama/Torch` are active simultaneously.
- **VRAM Guard:** Monitor RTX 4050 6GB VRAM. If VRAM > 5GB, recommend clearing Torch cache.
- **Latency Guard:** If RAM > 90% (approx 14.4GB), prioritize Static Analysis over Runtime Testing to avoid swapping.
⚓
