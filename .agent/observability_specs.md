# 📡 Observability Specs: The specific Trace ID

> **Objective:** Ensure every database mutation can be traced back to a specific user action or background process.

## 1. The `trace_id` Anatomy

**Format:** UUID v4
**Generation Point:**

- **Client-Side (Flutter):** Generated immediately when the user clicks "Save" or "Update".
- **Server-Side (Cron):** Generated at the start of the Edge Function execution.

## 2. Propagation Flow

### Scenario A: User Creates Task (Governed Write)

1. **User** clicks FAB -> "Add Task".
2. **Flutter App** generates `trace_id = uuid.v4()`.
3. **Flutter App** sends POST to `/functions/v1/validate_task_creation`:
   ```json
   {
     "title": "Buy Milk",
     "priority": "HIGH",
     "trace_id": "123e4567-e89b-..."
   }
   ```
4. **Edge Function** receives request:
   - Logs "START" to `logs` table with `trace_id`.
   - Validates Rule (Count < 5).
   - If Pass: Inserts into `todos` (Note: `todos` table doesn't strictly need `trace_id` unless debugging, but `logs` MUST have it).
   - Logs "SUCCESS" or "ERROR" to `logs` table with `trace_id`.

### Scenario B: User Toggles "Important" (Fast Path / Direct Write)

_Note: V4 Prototype uses direct streams. Phase 1 governance suggests moving writes to Edge Functions, but for simple toggles (Starring), we might stick to RLS for speed. IF we use direct RLS, we rely on Trigger-based logging._

**Hybrid Approach for MVP:**

- **Critical Mutations (Create/Delete):** Go through Edge Function (The Processor).
- **Minor Mutations (Update Flags):** Go Direct to DB.
  - **Observability:** Postgres Trigger `after_update_todo` generates a log entry.
  - _Constraint:_ The Postgres Trigger acts as the generator of the `trace_id` (or uses the transaction ID) if the client can't pass it easily in a standard UPDATE call without a dedicated column.
  - _Refinement:_ To strictly enforce `trace_id` from client, we would need to add a `last_trace_id` column to `todos` that gets updated with every write.

## 3. Implementation Requirement (Design Lead Decision)

**Decision:** We will add `last_trace_id` to the `todos` table schema to ensure full end-to-end tracing even for direct updates.

**Updated Schema Requirement:**

- Add `last_trace_id` (UUID, Nullable) to `todos` table.

## 4. Log Levels

- **INFO:** "Task Created", "Task Completed".
- **WARNING:** "Stale Task Detected", "Near Capacity (4/5)".
- **ERROR:** "Capacity Reached (Rejected)", "Edge Function Timeout".
- **CRITICAL:** "RLS Violation Attempt", "Orphaned Log".
