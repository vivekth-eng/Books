SCOPE: PROJECT
ID: Null Safety Standards
CONTEXT: Movie_DB_v1.1 / FastAPI / Flutter

# 🛡️ Null Safety Standards

These standards prevent "Null is not a subtype of num" crashes and ensure a premium UI even when data is missing among the 1,738+ records.

## 1. The "Safe Default" Rule (Flutter Domain Models)
- **Standard:** All numeric fields in domain models MUST have a `@Default` value provided via Freezed.
- **Why:** Prevents runtime crashes when the JSON response contains `null` for a non-nullable Dart type.
- **Implementation:**
  ```dart
  @Default(0.0) double rating,
  @Default(0) int releaseYear,
  ```

## 2. The "Backend Guard" Rule (FastAPI Models)
- **Standard:** Pydantic/SQLModel models should avoid returning `None` for fields expected as numeric types by the frontend.
- **Implementation:** Define fields with non-optional types and clear defaults (e.g., `rating: float = Field(default=0.0)`).

## 3. The "Mobile UI" Standard (UX)
- **Standard:** Gracefully handle zero/default values in the UI to maintain a premium feel.
- **Rules:**
  - If `rating == 0.0`, display **"N/A"** instead of the rating number.
  - If `releaseYear == 0`, display **"Unknown"** or hide the year badge.
- **Design:** Ensure "N/A" states don't break layout or alignment in widgets like `MovieCard`.

## 4. Code Generation Requirement
- **Standard:** Any change to null-safety defaults in domain models MUST be followed by a clean `build_runner` execution:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
