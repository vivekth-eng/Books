# Optimize Polling Efficiency Skill

## Philosophy
The ability to synchronize 3-tier state changes using **Action-Based Invalidations** (Event-Driven Refresh) instead of high-frequency **Short Polling**. This reduces system overhead, network traffic, and terminal noise.

## Implementation Guide

### 1. Repository Pattern (Tier 2/3)
Convert polling `Stream` methods that use `while(true)` or `Timer` into single-fetch `Future` methods.

```dart
// [DONE] Reactive Implementation
Future<List<Todo>> getTodos() async {
  final response = await _client.get('/todos');
  return (response.data as List).map((j) => Todo.fromJson(j)).toList();
}
```

### 2. Provider Strategy (Tier 1)
Use `FutureProvider` instead of `StreamProvider` for data that does not change at a fixed frequency.

### 3. Action-Based Handshake
Trigger a re-fetch only when a state-changing action occurs by calling `ref.invalidate(provider)`.

```dart
onPressed: () async {
  await ref.read(repo).toggleComplete(id);
  // THE HANDSHAKE:
  ref.invalidate(todoListProvider); 
}
```

## Use Cases
- Standard CRUD operations (Create, Update, Delete).
- Category or tab switching.
- User-initiated refreshes.

## Troubleshooting
- **Stale Data**: Ensure `ref.invalidate` is called after EVERY state-changing API call.
- **Excessive Fetches**: Ensure `ref.watch` is used correctly to avoid rebuilding providers unnecessarily.
