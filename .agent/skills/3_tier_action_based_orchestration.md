# Skill: 3-Tier Action-Based Orchestration

## Description
A specialized pattern for decoupling UI interactions from complex backend schemas by using localized API triggers (Action Endpoints) instead of heavy state synchronization.

## 1. The Core Philosophy
"Tell the server **what happened**, not **what the state is**."

- **Bad:** `PATCH /todos/1` with `{ "is_completed": true, "title": "...", "date": "..." }`
- **Good:** `POST /todos/1/toggle-complete` with `{}`

## 2. Implementation Guide

### Backend (FastAPI)
Create lightweight endpoints that perform specific logic.

```python
@app.post("/todos/{todo_id}/toggle-complete")
def toggle_todo_complete(todo_id: UUID, db: Session = Depends(get_db)):
    todo = db.query(models.Todo).filter(models.Todo.id == todo_id).first()
    if not todo:
         raise HTTPException(status_code=404, detail="Todo not found")
    
    # Toggle Logic (Server-Side Source of Truth)
    todo.is_completed = not todo.is_completed
    db.commit()
    return todo
```

### Frontend (Flutter)
Trigger the action and immediately invalidate the list provider to fetch the new "Truth".

```dart
// repository.dart
Future<void> toggleComplete(String id) async {
  await _client.post('/todos/$id/toggle-complete');
}

// todo_tile.dart
onChanged: (value) async {
  // 1. Optimistic UI update (optional, or rely on fast server response)
  // 2. Fire and Forget
  await ref.read(todoRepositoryProvider).toggleComplete(todo.id);
  // 3. Resync (The "Handshake")
  ref.invalidate(todoListProvider); 
}
```

## 3. When to Use
- **Simple Toggles:** Completion, Importance, Archiving.
- **Micro-Interactions:** Likes, Votes, Stars.
- **Workflow Steps:** "Move to Done", "Assign to Me".

## 4. Troubleshooting
- **422 Errors?** You are likely sending a body when none is needed. Check `inventory.md`.
- **UI Reverts?** Ensure `ref.invalidate` is called *after* the `await` completes.
