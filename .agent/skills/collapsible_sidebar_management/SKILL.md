---
name: Collapsible Sidebar State Management
description: Standards for managing filtering persistence, dynamic counts, and expansion logic in sidebars.
---

# Collapsible Sidebar State Management Skill

## 🎯 Purpose
To provide a robust filtering experience in sidebars where multiple categories (Genres, Disks, Years) need to be managed without losing user context during navigation or state refreshes.

## 🛠️ State Persistence Logic
Sidebar states (Expanded vs. Collapsed) should be decoupled from the main filtering logic to prevent the sidebar from "jumping" or resetting when a filter is applied.

1. **Independent Providers**:
   - `SidebarExpansionProvider`: Stores a Map of `SectionName -> bool` (Expanded state).
   - `SidebarShowMoreProvider`: Stores a Map for the "See All" truncation logic.
   
2. **Persistence**:
   - Use `Riverpod` with `autoDispose` disabled for the sidebar states if consistency across screen transitions is required.
   - For high-value filters (like "Watchlist Only"), persist the boolean to `SharedPreferences`.

## 📈 High-Density Filtering Pattern
When lists are long (e.g., 50+ genres):
- **Initial View**: `take(5)` items.
- **Show More Branch**: A dedicated `TextButton` that toggles the `SidebarShowMoreProvider` for that section.
- **Search-in-Section**: Use a local `StatefulWidget` or `StateProvider` to filter the items locally before rendering the chips. This ensures snappy UI feedback even with large datasets.

## 🧪 Integration Checklist
- [ ] Does applying a filter (clicking a chip) keep the `ExpansionTile` open?
- [ ] Does switching between "Home" and "Watchlist" preserve which sidebar sections were open?
- [ ] Are dynamic counts (e.g., `Action (42)`) updated in real-time via `ref.watch(genreListProvider)`?

⚓
