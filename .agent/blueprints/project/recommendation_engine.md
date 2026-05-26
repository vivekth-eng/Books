# Recommendation Engine: Neural Collaborative Filtering (NCF) Standard

This document defines the "ML-Ready" standards for the CineStack recommendation engine, powered by the RTX 4050 GPU.

## The "Double-Weight" Rule
"Love" interactions (2 hearts) must be given a 2x multiplier in the loss function of the recommendation model. This prioritizes directors, actors, and genres from movies the user "Loves" over those they simply "Like".

## Hybrid-Feature Standard
Recommendations use a Hybrid Approach:
1.  **Collaborative Filtering**: Based on user `interaction_score`.
2.  **Content-Based**: Based on TMDB metadata (Director, Actors, Genres) and **Gemini 3072d Semantic Embeddings**.

## Hardware Safety Clause
- **GPU Governance**: All ML training on the RTX 4050 must keep VRAM usage within a **2GB safety limit** during active IDE sessions.
- **Latency Guard**: During training, the Antigravity IDE should avoid heavy re-indexing to prevent system lag on the Intel i5 CPU.

## Data Preparation Protocol
1.  **Join**: `user_interaction` table + `movie` metadata table + `ChromaDB` oracle_collection.
2.  **Vector Concatenation**: Features = [Genre_OneHot, Director_Embedding, Cast_Embedding, Semantic_3072d].
3.  **Target**: Predict `interaction_score`.
