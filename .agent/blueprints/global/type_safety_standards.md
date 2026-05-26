SCOPE: GLOBAL
ID: Type Safety Standards
CONTEXT: General Flutter/FastAPI

# 🛡️ Type Safety Standards

> **MANDATE:** Ensure 100% type alignment across the 3-tier bridge (FastAPI -> Dio -> Riverpod -> UI).

## 1. Generated Code Rule (The "Freshness" Protocol)

**Rule:** Any time a domain model (like `CategoryMetadata`) is added or changed, the agent **MUST** force a `build_runner` refresh to keep the bridge intact.

- **Trigger:** Modification of any file containing `@freezed`, `@jsonSerializable`, or `@riverpod`.
- **Action:** Run `dart run build_runner build --delete-conflicting-outputs`.
- **Escalation:** If types remain mismatched, run `flutter clean` before the build.

## 2. Widget Casting Protocol

**Rule:** Sidebar widgets and list builders must use explicit types to ensure the UI handles complex objects (1,738+ records) without runtime crashes.

- **Explicit Watches:** When watching providers, explicitly define the expecting data type where possible.
- **Null Safety:** Always use default values (`?? ''`, `?? 0`) and proper null checks when accessing repository data.

## 3. The "Network-to-UI" Audit

Before marking a feature as done, verify:
1.  **Backend:** OpenAPI schema matches `models.py`.
2.  **Repo:** Repository methods return the specific domain model, not raw dynamic/string types.
3.  **UI:** Widgets access domain properties (e.g., `.name`, `.count`) instead of raw data.
⚓

