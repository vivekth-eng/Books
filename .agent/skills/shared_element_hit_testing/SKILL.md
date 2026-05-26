---
name: Advanced Gesture & Hit-Testing
description: Logic for resolving event conflicts in complex UI stacks with Hero widgets and BackdropFilters.
---

# Advanced Gesture & Hit-Testing Skill

## 🎯 Purpose
To ensure that complex, layered UIs (using Stack, BackdropFilter, and Hero) remain responsive to fine-grained user input, specifically when secondary actions (like a watchlist toggle) are nested within larger primary targets (like a navigation card).

## 🛠️ The "Stack-Prioritization" Pattern
When a large `InkWell` (for whole-card navigation) blocks a smaller button (for status toggle):

1. **Avoid Nesting**: Do not nest the toggle `IconButton` inside the card's main `InkWell`.
2. **Prioritized Stack**: Use a `Stack` at the root of the widget.
3. **Positioned Layering**: Place the toggle `Positioned` as the *last* child in the `Stack`. This ensures it resides at the highest Z-index for hit-testing.

```dart
Stack(
  children: [
    Card(... child: InkWell(onTap: openDetails)), // Background layer
    Positioned(
      bottom: 8, right: 8,
      child: IconButton(onPressed: toggleWatchlist), // Foreground layer (receives clicks)
    ),
  ],
)
```

## 🚨 BackdropFilter & Hero Pitfalls
- **BackdropFilter**: Can sometimes swallow events if the `Child` of the filter is not explicitly `HitTestBehavior.translucent`. Ensure the interactive buttons are placed *outside* or *above* the filter layer if transparency is issues.
- **Hero Tags**: Ensure every Hero in a grid has a **Unique Tag** based on the data ID (e.g., `'poster_${movie.id}'`). Duplicate tags will cause a build crash during navigation transitions.

## 🧪 Verification Protocol
- **The "Edge Test"**: Click the absolute edge of the toggle button. It should NOT trigger the card's background navigation logic.
- **The "Modal Refresh"**: Toggling a state inside a modal must immediately invalidate the corresponding provider (`ref.invalidate`) to ensure the parent grid reflects the change instantly.

⚓
