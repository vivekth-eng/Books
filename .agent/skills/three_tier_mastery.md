---
description: Advanced mastery of the 3-tier architecture (SQLModel, Freezed, Riverpod, Alembic)
---

# 🏆 Three-Tier Mastery: The Hardened Handshake

This skill documents the advanced proficiency required to maintain 100% synchronization and type safety across Tier 1 (Flutter), Tier 2 (FastAPI), and Tier 3 (PostgreSQL).

## 1. SQLModel Mastery (The Tier 2/3 Bridge)
- **Concept:** Unifying database schemas and API models into a single source of truth.
- **Workflow:** Derive both the DB table and the Pydantic schema from a single SQLModel class.
- **Benefit:** Eliminates "Missing Column" or "Type Mismatch" errors between the application and database layers.
- **Key Directive:** Always use `Optional` and `Field` explicitly to control OpenAPI nullability.

## 2. Freezed & build_runner (The Tier 1 Core)
- **Concept:** Automating null-safety and immutable state management on the client side.
- **Workflow:** Define domain models with Freezed `@Default(...)` values.
- **Benefit:** Prevents the dreaded `TypeError: null` or `Unexpected type: String` runtime crashes by providing a type-safe interface for API responses.
- **Key Directive:** Never edit `*.freezed.dart` or `*.g.dart` manually.

## 3. Alembic Proficiency (The Tier 3 Guardian)
- **Concept:** Using versioned migrations to maintain data integrity across all environments.
- **Workflow:** Use `alembic revision --autogenerate` for every schema change.
- **Benefit:** Guarantees that production, staging, and local databases are always in sync with the Application Tier.
- **Key Directive:** Perform a DB audit (`alembic current`) before starting any frontend implementation.

## 4. Riverpod Generation (The Presentation Glue)
- **Concept:** Using automated providers to sync UI state with backend logic without manual boilerplate.
- **Workflow:** Use the `@riverpod` annotation for all state management.
- **Benefit:** Ensures automatic dependency injection, proper provider disposal, and type-safe state access without manual `Provider` declarations.
- **Key Directive:** Use `ref.invalidate()` to trigger reactive refreshes after backend state changes.

## 5. The "Development Blockade" Standard
- **Rule:** **NO UI CODE** is written until the "Handshake" (models + generation) is verified.
- **Verification:** Confirm that `/openapi.json` matches the new database state and UI models reflect this matching.

---
⚓ *This skill is essential for maintaining production-grade 3-tier systems.*
