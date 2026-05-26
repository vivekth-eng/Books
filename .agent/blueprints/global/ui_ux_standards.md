SCOPE: GLOBAL
ID: UI/UX Standards
CONTEXT: General Flutter

# UI/UX Standards: Surgical Movie Dashboard

This document defines the mandatory UI/UX standards for the CineStack Movie Database to ensure a premium, performant, and user-friendly experience.

## 1. The "Zero-Pop" Rule
To prevent visual jarring during network latency, all images must follow the "Zero-Pop" standard:
- **Mandatory Placeloaders:** Every image must display a `BlurHash` while loading.
- **Smooth Transitions:** Images must use a smooth fade-in effect upon completion.
- **Layout Stability:** Placeholders must maintain the exact aspect ratio (2:3 for posters) to prevent layout shifts.

## 2. The "Disk-Aware" UI
Since CineStack manages physical media, the UI must treat Disk ID as a primary data point:
- **High Visibility:** Disk IDs must be prominently displayed on movie cards.
- **Contrast:** Use high-contrast color coding (e.g., Blue Accent) for disk tags.
- **Quick Scannability:** The tag should be located consistently (e.g., top-right corner).

## 3. The "Description-First" Hover
Movie descriptions are core to browsing and must be easily accessible:
- **Half-Overlay Cap:** On hover, a semi-transparent black overlay must appear, capping at **50% of the total card height**. This ensures the top half of the poster remains visible.
- **Full Readability:** The overlay should provide enough vertical space (within the 50% cap) for the description to be readable.
- **High Contrast:** Ensure white text on a dark overlay for maximum readability.
- **Interaction:** Hover should be responsive and smooth (e.g., 200ms transition).

