SCOPE: GLOBAL
ID: State Sync
CONTEXT: General Flutter/FastAPI

# 🔄 State Sync Standards

> **MANDATE:** Maintain strict synchronization between domain models, generated code, and the 3-tier bridge.

## 1. The "Runner" Rule (Model Change Protocol)

**Rule:** Any change to a `@freezed` domain model (e.g., adding `isWatchlist` or `tags`) **MUST** be followed by a `build_runner` execution before running `flutter run`.

- **Trigger:** Adding/Removing fields in `domain/models/*.dart`.
- **Command:** `dart run build_runner build --delete-conflicting-outputs`.
- **Why:** Prevents "subtype" errors and missing property getters in the UI.

## 2. Boolean Defaults (Safety First)

**Rule:** Always provide a default value for boolean fields in the model to prevent UI crashes when data is loaded.

- **Standard:** `@Default(false) bool fieldName`.
- **Context:** Especially critical for the 1,738+ records to ensure a consistent experience on high-performance devices like the Poco X7 Pro.

## 3. UI Safety & Interactions

- **Watchlist Property:** Use the `isWatchlist` property specifically for the **Long-Press** action (Mobile) or **Hover Overlay** (Web) to provide a tactile "Save" experience.
- **Haptic Feedback:** Consider adding haptic feedback on state changes (like watchlist toggle) for mobile users.
⚓

