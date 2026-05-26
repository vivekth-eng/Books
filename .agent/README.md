# CineStack: AI-Powered Movie Database

CineStack is a premium, 3-tier movie database application featuring high-performance semantic search, a vibrant cinema-inspired UI, and personalized user collections.

## 🚀 Key Features

- **Unified Dashboard**: A high-contrast "Cinema" theme (Deep Charcoal & Electric Violet).
- **AI-Powered Semantic Search**: Discover movies conceptually using natural language (e.g., "treasure hunt").
- **Vibrant Movie Posters**: Lazy-loaded, high-resolution posters with glassmorphic fallbacks.
- **Smart Filters**: Collapsible sidebar with frequency-based sorting for Genres and Disks.
- **Personalized Watchlist**: Secure user accounts with JWT-based authentication and persistent watchlists.
- **Dynamic Analytics**: Real-time insights into your movie library distribution.
- **One-Click Sync**: Automated synchronization between local Excel sources, posters, and cloud metadata.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Riverpod, Material 3, Google Fonts)
- **Backend**: FastAPI (Python, SQLModel, SQLAlchemy)
- **Database**: PostgreSQL with `pgvector` for AI embeddings.
- **Deployment**: Fully containerized with Docker and Docker Compose.

## 🏁 Getting Started

1.  **Configure Environment**: Copy `.env.example` to `assets/env/.env` and `backend/.env`.
2.  **Start Services**: Run `docker-compose up -d`.
3.  **Launch Dashboard**: Use `flutter run -d chrome`.

---
*Built with ❤️ for Movie Enthusiasts.*
