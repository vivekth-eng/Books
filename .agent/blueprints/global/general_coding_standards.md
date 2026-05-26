SCOPE: GLOBAL
ID: General Coding Standards
CONTEXT: Python / Flutter / Git

# 💻 General Coding Standards

These are the foundational coding standards that apply to all projects, ensuring consistency, type safety, and maintainability across the 3-Tier stack.

## 1. Python (FastAPI / Server Scripts)

-   **PEP 8 Compliance:** Follow standard Python formatting.
-   **Type Hinting:** Mandatory for all function signatures and complex variables.
    ```python
    def calculate_total(items: List[Dict[str, int]]) -> int:
        pass
    ```
-   **Pydantic / SQLModel First:** Use schema-based validation for all incoming and outgoing data. Avoid raw dictionary manipulation when a model can provide safety.
-   **No Silent Failures:** Use robust `try/except` blocks and log failures gracefully. Do not use bare `except:` clauses.

## 2. Flutter / Dart

-   **State Management (Riverpod):** 
    -   Use `@riverpod` generator for all providers.
    -   UI files (`.dart` inside `presentation/widgets`) should contain **zero** business logic. They exclusively watch/read providers.
-   **Immutability (Freezed):** 
    -   All domain models MUST be generated using Freezed (`@freezed`).
    -   State classes for Riverpod Notifiers MUST be immutable.
-   **Code Generation Mandate:** 
    -   After modifying ANY model or Riverpod controller, executing `dart run build_runner build --delete-conflicting-outputs` is mandatory before running the app.
-   **UI Structure:** Use `const` constructors aggressively. Break down massive widgets into smaller, focused classes rather than returning complex trees from helper methods.

## 3. File & Directory Naming

-   **Snake Case for Files:** `my_movie_card.dart`, `database_config.py`.
-   **Pascal Case for Classes:** `MyMovieCard`, `DatabaseConfig`.
-   **Feature-First Architecture:** Group files by feature (e.g., `features/auth/presentation`, `features/auth/domain`) rather than component type (e.g., `controllers/`, `models/`).
