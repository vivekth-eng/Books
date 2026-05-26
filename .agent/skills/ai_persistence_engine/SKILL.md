# Skill: AI Persistence Engine (Cache-Aside)

## Overview
This skill implements high-performance, token-efficient AI text generation by prioritizing local database records over expensive, quota-limited API calls.

## Implementation Pattern

### 1. Database Schema (SQLModel)
- Define a table `fund_insight` (or resource_insight) to store:
    - `fund_name` (Unique ID)
    - `insight_text` (The AI output)
    - `model_version` (Metadata for audit)
    - `timestamp` (For checking freshness)
    - `metadata_snapshot` (JSON field capturing input metrics).

### 2. Logic Flow
```python
def get_persisted_insight(resource_id, force_refresh, session):
    # Step A: Cache Lookup
    if not force_refresh:
        record = session.get(ResourceInsight, resource_id)
        if record:
            return record # Zero token consumption

    # Step B: API Generation
    content = call_api(...)
    
    # Step C: Upsert
    save_to_db(resource_id, content, session)
    return content
```

### 3. UI Requirements
- **Always show the last valid record**: If a refresh fails, fallback to the existing `_insight` rather than showing an error state.
- **Audit Badge**: Display the `timestamp` in the UI (e.g., "Audit Captured: 2026-04-04") to build user trust.
- **Manual Trigger**: Provide a `REFRESH` button that explicitly sets `force_refresh=true`.

## Best Practices
- **Never Polling**: Do NOT refresh AI insights on a timer. Use manual user intent to minimize costs.
- **Model Badging**: If multiple models are used (failover), display which model generated the current insight.

⚓
