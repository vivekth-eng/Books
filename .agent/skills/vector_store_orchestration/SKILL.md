# Skill: Vector Store Orchestration (ChromaDB Native)

## 1. Verify Dimensions
Ensures the disk-store matches the model standard (3072 vs 768).

```python
def verify_dimensions(collection, expected=3072):
    sample = collection.get(limit=1, include=['embeddings'])
    if sample['embeddings']:
        actual = len(sample['embeddings'][0])
        if actual != expected:
            raise ValueError(f"Dimension Mismatch: Expected {expected}, got {actual}")
```

## 2. Safe Upsert (Memory Managed)
Batch-processes records to stay within 16GB RAM thresholds.

```python
def safe_upsert(collection, ids, embeddings, metadatas, batch_size=100):
    for i in range(0, len(ids), batch_size):
        collection.add(
            ids=ids[i:i+batch_size],
            embeddings=embeddings[i:i+batch_size],
            metadatas=metadatas[i:i+batch_size]
        )
```

## 3. Destructive Re-Index
A clean-start command to purge corrupted vector folders.

```python
import shutil

def destructive_reindex(db_path):
    if os.path.exists(db_path):
        shutil.rmtree(db_path)
    # Restart indexing script here
```

⚓
