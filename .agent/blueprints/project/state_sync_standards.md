# State Sync Standards (3-Tier Blueprint)

## The "Enum Export" Rule
All shared enums (like `SearchMode`) must be defined in the domain model file itself (e.g., `filter_state.dart`) to ensure they are inherently bundled, exported, and scoped alongside the state objects they control. Do not define them in isolated utility files unless globally shared across unrelated domains.

## The "Subtype Safety" Standard
Any change to a Freezed model or its constructor signature must be followed by a mandatory `dart run build_runner build --delete-conflicting-outputs` cycle. 
**Rule:** Ensure the models regenerate properly *before* attempting a `flutter run` or `flutter build`, otherwise the "isn't a subtype" discrepancy between the source model and generated `_$Factory` will crash the UI.

## The "Debounce Logic" Verification
For heavy backend operations (like Semantic Vector searches that hydrate the `SentenceTransformer` model on local hardware like an Intel i5), UI widgets *must* implement explicit type checks (e.g., `searchMode == SearchMode.semantic`) to dynamically adjust debounce thresholds.
- **Exact:** 500ms
- **Semantic:** 700ms (Minimum threshold required to prevent local AI backend saturation).
