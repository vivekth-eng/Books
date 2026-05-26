---
description: How to perform Contract-First Development (Synchronized SQL, FastAPI, Flutter)
---

# Contract-First Development Workflow

## Step 0: Information Pre-Requisite
Before starting the contract definition, you MUST have the **API Recon Report** and **Logic Strategy** from the **Researcher**. This prevents designing endpoints that cannot be implemented or are cost-prohibitive.

## Step 1: Mandatory SQL Audit
Before proposing ANY schema change, you must verify the current state of the database.
// turbo
```powershell
docker exec postgres_db psql -U user_name -d my_database -c "\d todos"
```

## Step 2: Synchronized Schema definition
Deliver the change in a single block spanning all tiers.

### A. SQL Migration
Apply the change to the PostgreSQL container.
```sql
ALTER TABLE todos ADD COLUMN [column_name] [data_type] DEFAULT [default_value];
```

### B. FastAPI Pydantic & SQLAlchemy Models
Sync the SQLAlchemy model in `backend/models.py` and Pydantic schemas in `backend/main.py`.

### C. Flutter Model Update
Update the Dart model in `lib/features/todo/domain/models/todo.dart`.
**MANDATORY**: Use null-safe defaults in `fromJson`.
```dart
field: json['field_name'] ?? default_value,
```

## Step 3: Network Bridge Verification (Port 8001)
Verify that the backend is responding on port 8001.
// turbo
```powershell
Invoke-WebRequest -Uri "http://localhost:8001/todos" -Method Get -Headers @{"Authorization"="Bearer [TEST_TOKEN]"}
```

## Step 4: Verification
Confirm the new field is present in the API response and handled by the Flutter model without crashes.
