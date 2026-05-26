# Governance

## 1. Architecture Principles
- **Local-First**: Additional latency is unacceptable. All reads/writes must happen against the local `postgres` instance.
- **Offline-Capable**: The app must function fully without internet. Sync is a future concern.
- **Sensitive Data**: Passwords must be hashed (Argon2 or bcrypt) before storage. No plain-text secrets in the database or logs.
- **Hardware Longevity**: Minimize unnecessary SSD write cycles. Perform `flutter clean` weekly rather than daily.

## 2. Infrastructure
- **Provider**: Local Docker (PostgreSQL).
- **Environment**: Managed via `.env` files. NO secrets in version control.
- **Telemetry**: All critical actions must be logged to the `logs` table locally.
- **On-Demand Capacity**: CineStack services (Docker) must be deactivated when the IDE is closed to maintain 16GB RAM headroom.
- **16GB Threshold Management**: Proactively close unused browser tabs when Docker, Chrome (Flutter Debug), and Ollama are active.
- **AI VRAM Priority**: Prioritize static analysis over runtime builds when the LLM is active to preserve 6GB VRAM for inference.

## 3. Code Quality
- **Type Safety**: strict linting rules.
- **Dependency Minimization**: Use pure Dart/Flutter packages where possible.
