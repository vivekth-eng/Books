# Blueprint: Google AI Integration Standards (Native Windows)

## 1. Model Governance
- **Primary Embedding**: `gemini-embedding-2-preview` (3072-dimensional) is the gold standard for high-fidelity RAG.
- **Secondary Embedding**: `text-embedding-004` (768-dimensional) may be used for low-resource or legacy components.
- **Strict Adherence**: All new collections must verify dimension alignment (`3072` or `768`) before upserting.

## 2. Quota Management (429 Resilience)
- **Mandate**: All `genai` API calls must use an **Exponential Backoff** wrapper.
- **Implementation**:
  ```python
  import time
  import google.generativeai as genai

  def call_with_backoff(func, *args, **kwargs):
      retries = 5
      wait = 2
      for i in range(retries):
          try:
              return func(*args, **kwargs)
          except Exception as e:
              if "429" in str(e):
                  print(f"QUOTA HIT: Retrying in {wait}s...")
                  time.sleep(wait)
                  wait *= 2
              else:
                  raise e
  ```

## 3. Token Efficiency (Context Pruning)
- **Rule**: Never pass raw, un-pruned text blobs to Gemini.
- **Strategy**: Use "Semantic Chunking" to ensure only the most relevant context is passed, keeping prompt costs low and staying within free-tier TPM limits.
- **Audit**: Log token usage totals in the `logs` table for observability.

⚓
