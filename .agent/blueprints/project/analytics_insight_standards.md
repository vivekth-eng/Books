# 📊 Analytics & Watchlist Insight Standards

## 1. Aggregation Strategy (Tier 2/3)

- **Performance First**: Analytics queries involving 1,700+ records MUST use SQLAlchemy's `func.count()`, `func.avg()`, and `group_by()` to ensure the database handles the heavy lifting, not the Python runtime.
- **Genre Unnesting**: Since `genre_raw` is a comma-separated string, genre analytics should use `string_to_array` and `unnest` where possible, or perform one-pass aggregation in Python for multi-genre distribution.
- **Endpoint**: All analytics metrics must be served via a single `/api/v1/analytics/summary` endpoint to minimize network calls for a full dashboard load.

## 2. Visualization Standards (Tier 1)

- **Library**: `fl_chart` is the mandated library for all data visualizations.
- **Color Palette**: Use the "CineStack Signature" Palette:
    - **Total**: `Colors.blueAccent`
    - **Watchlist**: `Colors.orangeAccent`
    - **Ratings**: `Colors.greenAccent`
- **Responsiveness**: Charts must adapt to screen size. On mobile, charts should stack vertically; on web/tablet, they should use a grid or multi-column layout.

## 3. Data Consistency

- **Watchlist Sync**: The Analytics Dashboard must automatically refresh or invalidate its provider whenever `toggle_watchlist` is called to ensure the counts are always accurate.
- **Cache Header**: Analytics responses should have low `max-age` (e.g., 60 seconds) to ensure fresh data after user interactions.

## 4. Metric Definitions

| Metric | Definition |
| :--- | :--- |
| **Total Coverage** | Physical posters / Total records (Target: 100%). |
| **Watchlist Saturation** | (Watchlist Count / Total Count) * 100. |
| **Top Genres** | Count of appearances of each genre across the selected subset. |
| **Collection Value** | Weighted average of user ratings. |
⚓
