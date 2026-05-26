# 🧠 CineStack Recommendation Engine Standards

This document defines the architectural standards for the ML-powered recommendation engine, specifically optimized for the **RTX 4050 / Ryzen 7** workstation.

## 1. The "Non-Zero UI" Mandate
- **Rule**: No UI component is permitted to attempt a list-based render without a `.isNotEmpty` defensive guard.
- **Fail-Safe**: If a data provider returns an empty set, the UI MUST display a dedicated "Discovery Placeholder" or "Cold-Start Card" instead of throw errors or leaving empty space.

## 2. The "Hybrid Fallback" Standard
- **Objective**: Ensure the user always sees high-fidelity content, even when ML models have low confidence.
- **Tiered Approach**:
    1. **Personalized Centroid (GPU)**: Primary recommendations based on Weighted Cosine Similarity.
    2. **Metadata Boost**: Reranking based on shared Directors/Actors from the "Loved" list.
    3. **Popularity Fallback (Metadata)**: If similarity returns < 5 hits, the API must append the top 10 movies by global rating (TMDB metadata) to the response.

## 3. The "Cold-Start" Shield
- **Mechanism**: The ML inference pipeline is bypassed if a user has fewer than **10 interactions**.
- **Reasoning**: Centroid calculation with low-seed data leading to "mathematical noise." Bypassing inference saves VRAM and ensures the Ryzen 7 prioritizes system stability.
- **Experience**: Clean "Popular Movies" feed until the threshold is met.

## 4. Hardware Optimization (RTX 4050 / Ryzen 7)
- **Vector Sovereignty**: The engine must handle both 768d (local) and **3072d (Gemini)** vectors locally on the RTX 4050.
- **Lazy-Brain**: Torch contexts/CUDA are initialized only upon the first recommendation request to maintain fast API startup.
- **Memory Ceiling**: All inference operations must stay within a **4GB VRAM ceiling** to coexist with Flutter/Chrome processes.
- **Parallel Centroid**: Utilize Ryzen 7 multi-threading for calculating centroids across large interaction histories.

⚓
