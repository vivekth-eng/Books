# Skill: Project Standards

## Description
Universal rules for folder structure, secrets, and error handling.

## 1. Folder Structure (3-Tier)
```text
/
├── .agent/              # AI Context & Skills
├── backend/             # Tier 2
│   ├── main.py
│   ├── models.py
│   └── Dockerfile
├── lib/                 # Tier 1 (Flutter)
│   ├── main.dart
│   └── core/network/
├── assets/              # Config
│   └── .env
├── docker-compose.yml   # Orchestration
├── schema.sql           # Tier 3 (Init)
└── README.md
```

## 2. Secret Management
- **Never Commit**: `.env` files.
- **Template**: Commit `.env.example` with dummy values.
- **Flow**: Docker injects ENV vars -> Backend reads `os.getenv` -> Frontend reads `flutter_dotenv`.

## 3. Error Protocol
- **Backend**: Always return JSON with `detail`.
  - `raise HTTPException(status_code=404, detail="Item not found")`
- **Frontend**: Catch `DioException`.
  - Display `e.response?.data['detail']` in `SnackBar` or `AlertDialog`.
