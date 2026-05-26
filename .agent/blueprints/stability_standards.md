# 🛡️ Blueprint: CineStack Stability Standards

> **USAGE INSTRUCTION:** This blueprint defines the "Professional" stability standards for the 3-tier architecture. It records solutions to recurring problems to ensure they do not reappear.

---

## 1. UI Lifecycle & State Management

### A. The "Non-Zero UI" Mandate
- **Rule**: No UI component is permitted to attempt a list-based render without a `.isNotEmpty` defensive guard.
- **Protocol**: 
    - If a data provider (e.g., `recommendedMoviesProvider`) returns an empty set, the UI MUST display a dedicated "Discovery Placeholder" or "FallBack Card".
    - **Forbidden**: Returning `null` or an empty column that breaks the layout flow.

### B. Frame-Sync & Microtask Protection
- **Problem**: "State update during build" errors when providers modify state based on widget creation.
- **Solution**: All state modifications triggered by UI interactions must be wrapped in a microtask or a post-frame callback.
- **Standard**:
  ```dart
  Future.microtask(() => ref.read(myProvider.notifier).updateState());
  ```

### C. The "Explicit-Teardown" Loader Rule
- **Problem**: Async operations completing or throwing exceptions without resetting loading state flags, causing infinite spinners.
- **Rule**: Every presentation loader or progress state must be wrapped in a `try...finally` block that explicitly resets `isLoading = false` and `isHydrating = false` on all return paths (success, error, timeout).
- **Mandate**: No loading layout flag may rely on a background stream or callback completing silently.

### D. The "Visual-State-Parity" Standard
- **Problem**: Asynchronous UI state changes causing out-of-sync or overlapping UI indicators.
- **Rule**: All progress loaders, typing indicators, and text elements must derive their status from the exact same cohesive state model to ensure complete frame-by-frame synchronization.

---

## 2. API Resilience & Quota Governance

### A. The "Quota-Aware Retrieval" Pattern
- **Problem**: Gemini API rate limits (429) interrupting workflows.
- **Solution**: Implement a `try-except 429` block in all AI-enhanced services.
- **Action**: On a 429 error, the system must fallback to local metadata similarity or cached results instantly.

### B. The "Hybrid Fallback" Standard
- **Rule**: If a high-intent endpoint (like Semantic Search or Recommendations) returns fewer than **5 results**, the system must automatically append "Top Rated" or "Trending" items to the result set.
- **Goal**: Ensure the "Shelf" is never empty for the user.

---

## 3. Modular Sovereignty & Type Integrity

### A. Zero-Ghost Policy
- **Rule**: UI code cannot reference a Provider or Model that has not passed a successful `build_runner` cycle.
- **Mandate**: `flutter pub run build_runner build --delete-conflicting-outputs` is the gold standard for state synchronization.

### B. Single-Return-Path Pattern
- **Rule**: UI logic inside widgets must favor a single return path where possible.
- **Action**: Use exhaustive switch matching or `when` patterns (Riverpod `AsyncValue`) to handle `Data`, `Loading`, and `Error` states explicitly.

### B. Selection Hash Pattern
- **Standard**: Large-scale retrievals for the 1,774-movie library must utilize the "Selection Hash" pattern to bypass redundant AI inference. (See `ai_persistence_engine` skill).

---

## 4. Data Integrity & Sync

### A. The "Upsert-First" Interaction Pattern
- **Rule**: All user interactions (Likes, Watchlist toggles) must use an UPSERT (Update or Insert) logic on the backend.
- **Why**: Prevents duplicate entry errors if the UI sends multiple requests due to network lag.

### B. Vector Partitioning
- **Rule**: When handling both 768d and 3072d vectors, they must be stored in distinct columns with dimension-specific indices.
- **Protocol**: Never attempt to cast a 3072d Gemini vector into a 768d search path; this will trigger a DB distance error.

⚓
