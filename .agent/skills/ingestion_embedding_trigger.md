# Skill: [INGESTION_EMBEDDING_TRIGGER]

## Purpose
Orchestrates the activation of the RTX 4050 GPU to generate local 768d embeddings immediately following a data ingestion or sync event.

## Trigger Mechanism
- **Event**: Successful completion of `scripts/ingest_and_hydrate.py`.
- **Target**: Records in the `movie` table where `embedding` is `NULL`.

## GPU Governance (RTX 4050)
- **Model**: `all-mpnet-base-v2` (768 dimensions).
- **Execution**: The script MUST prioritize CUDA execution if available.
- **Resource Guard**: Monitor VRAM usage. If VRAM > 5GB, process in smaller batches (e.g., 20 records) followed by `torch.cuda.empty_cache()`.

## Implementation Pattern
```python
def trigger_ai_activation():
    """
    1. Query DB for movies with NULL embeddings.
    2. Load SentenceTransformer on 'cuda' if available.
    3. Process batches of records.
    4. Update DB vectors.
    """
```

## Integration
This skill is automatically invoked at the end of the **One-Click Sync** workflow. It ensures that any movie added manually to the Excel file becomes semantically searchable within seconds.

## Performance Target
- **Latency**: < 200ms per movie on RTX 4050.
- **Throughput**: 1,700+ records processed in < 5 minutes if a full re-index is required.
