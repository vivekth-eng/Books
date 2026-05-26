# 🧪 Validation Testing Protocol V2.0

## Status: High-Performance Baseline
## Authority: Project Manager
## Hardware Profile: Ryzen 7 (16-Thread) | 16GB RAM | RTX 4050 (6GB VRAM)

---

### 1. The Testing Hierarchy
We categorize tests by their Execution Velocity and Hardware Affinity:

| Category | Type | Hardware Target | Objective |
| :--- | :--- | :--- | :--- |
| **Unit** | Lightweight | CPU (Ryzen Threads) | Logic validation (Sanitization, DTOs). |
| **Integration**| Medium | Postgres / Native | DB Handshake & Port 8000/5050 availability. |
| **Inference** | Heavy | RTX 4050 (CUDA) | Verify local vector generation integrity. |
| **Quota-Safe** | Mocked | Virtual | API workflow testing without token cost. |

---

### 2. The "Surgical" Validation Standards

- **Parallel Execution**: Leverage `pytest-xdist` to run tests across 8-12 threads.
- **VRAM Integrity**: Every Inference test must verify that the RTX 4050 is correctly utilized and that VRAM is released post-test.
- **Sanitization Bridge**: Test "Extreme Titles" (e.g., *The Discovery [2026]?*) to ensure the underscores match the physical file system.
- **Ghost Poster Audit**: Scan the 1,774-movie library for asset mismatches (Physical .jpg vs DB poster_path).

---

### 3. Execution Protocols

#### A. The "4GB Ceiling" Audit
- **Rule**: Total RAM usage during the test suite execution must be monitored.
- **Threshold**: Warning issued if Python process memory exceeds 4GB (Safe for 16GB host).

#### B. The "Deep Handshake" Test
- **Rule**: Verification of the 3-Tier bridge with a 60s timeout.
- **Rationale**: Accommodates the loading of heavy SentenceTransformer models on cold-start.

---

### 4. Governance
- All tests must pass BEFORE a feature branch is merged into `main`.
- Quota-safe mocks are MANDATORY for CI environments.
