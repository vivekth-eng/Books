---
name: Glassmorphic UI Framework
description: Standards for creating high-premium blurred interfaces using Flutter BackdropFilters and Vibrancy palettes.
---

# Glassmorphic UI Framework Skill

## 🎯 Purpose
To implement consistent, premium "Glass" aesthetics across the CineStack ecosystem while maintaining high performance and avoiding common Flutter rendering pitfalls.

## 🛠️ The GlassCard Standard
Always use a dedicated `GlassCard` or `BackdropFilter` wrap to achieve the frosted glass effect.

### Configuration Specification
| Parameter | Value | Purpose |
|-----------|-------|---------|
| **Sigma X/Y** | `12.0` | Balanced depth blur. |
| **Opacity** | `0.15` | Ensures background visibility without washing out text. |
| **Border** | `1.0` | Thin, light stroke for edge definition. |
| **Border Color** | `Colors.white.withOpacity(0.1)` | Subtle highlight. |

## 🚨 The "Assertion Failed" Guard (Mandatory)
A common crash occurs when both a `color` and `decoration` are provided to a `Container`.

**Incorrect**:
```dart
Container(
  color: Colors.blue,
  decoration: BoxDecoration(...), // CRASH!
)
```

**Correct**:
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue, // Move color INSIDE decoration
    borderRadius: BorderRadius.circular(12),
  ),
)
```

## 🎨 Vibrancy Palette Logic
- **Primary Surface**: `AppTheme.deepCharcoal` (Base Layer).
- **Glass Overlay**: `AppTheme.deepCharcoal.withOpacity(0.4)` + `sigma: 12.0`.
- **Accent Glow**: Use `AppTheme.electricViolet` or `AppTheme.accentAmber` with low opacity (0.1) as a background glow inside the glass for brand consistency.

⚓
