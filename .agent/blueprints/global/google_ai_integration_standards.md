# Blueprint: Google AI Integration Standards (Native Windows)

## 1. Model Governance & Failover Chain (v3.2 Update)
- **Primary Logic**: `gemini-2.0-flash` (Audit/Strategy - High Reasoning).
- **Secondary (Health-Switch)**: `gemini-1.5-flash` or `gemini-flash-latest` (The stable workhorse).
- **Lite Fallback**: `gemini-2.0-flash-lite` (Routine Narratives).
- **Strict Adherence**: Always verify model availability via `genai.list_models()` for the specific API Key to avoid 404 Model Not Found errors.

## 2. Quota Management & "Memory-First" Resilience
- **Mandate**: All AI features MUST implement **Cache-Aside Persistence** using the `fund_insight` (or equivalent) SQLModel table.
- **Quota Resilience (v3.0)**:
  - Detect "limit: 0" or "quota" strings in 429 exceptions.
  - Implement a **Model Health Registry** (e.g., `IS_G2_AVAILABLE`) to de-register problematic models for the current session.
  - **Sanitization**: UI must prioritize "Memory" (cached insights) over "Error" (raw 429 messages). Only show errors if no cache exists.

## 3. Insight Persistence Lifecycle
- **Step 1: Check Cache**: Before calling the API, check the database for a matching `fund_name` (or resource ID).
- **Step 2: Conditional Fetch**: Only call Gemini if `force_refresh=true` OR no record exists.
- **Step 3: Upsert & Timestamp**: Always save the model name, timestamp, and a metadata snapshot (`alpha`, `beta`, `category`) with the insight text.
- **Step 4: Manual Trigger**: The UI must provide an explicit `🔄 REFRESH` button to bypass the cache.

## 4. Implementation Example (The "Hard-Switch")
```python
# AI-Endpoint-Hard-Switch-v3.0
IS_G2_AVAILABLE = True

def generate_with_failover(prompt, session):
    global IS_G2_AVAILABLE
    models = ["gemini-1.5-flash", "gemini-2.0-flash"]
    if not IS_G2_AVAILABLE:
        models = [m for m in models if m != "gemini-2.0-flash"]
        
    for m in models:
        try:
            return call_gemini(m, prompt)
        except Exception as e:
            if "limit" in str(e).lower() and m == "gemini-2.0-flash":
                IS_G2_AVAILABLE = False # De-register model
            continue
```

## 5. Token Efficiency (Context Pruning)
- **Rule**: Never pass raw, un-pruned text blobs to Gemini.
- **Strategy**: Use "Semantic Chunking" to ensure only the most relevant context is passed, keeping prompt costs low and staying within free-tier TPM limits.
- **Audit**: Log token usage totals in the `logs` table for observability.

⚓
