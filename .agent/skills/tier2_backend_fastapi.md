# Skill: Tier 2 - Backend (FastAPI)

## Description
Production-ready template for a containerized FastAPI application using SQLAlchemy and Pydantic.

## 1. Dockerfile Standard
Optimize for caching and size.

```dockerfile
# backend/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system deps (if needed for postgres)
RUN apt-get update && apt-get install -y libpq-dev gcc

# Copy requirements first (Caching layer)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY . .

# Expose port
EXPOSE 8000

# Run
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## 2. Requirements Essentials
```text
fastapi>=0.100.0
uvicorn>=0.20.0
sqlalchemy>=2.0.0
psycopg2-binary>=2.9.0
pydantic>=2.0.0
python-jose[cryptography]  # JWT
passlib[bcrypt]           # Hashing
python-multipart          # Form data
```

## 3. CORS Middleware Configuration
Essential for interacting with Flutter Web.

```python
# main.py
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Allow ALL for dev; restrict in Prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# Native Windows CORS Security (PNA Pre-flight)
@app.middleware("http")
async def add_private_network_header(request, call_next):
    response = await call_next(request)
    if request.method == "OPTIONS":
        # Required for Chrome's Private Network Access policy
        response.headers["Access-Control-Allow-Private-Network"] = "true"
    return response
```

## 4. Auth/Profile Pattern
- **Register**: `POST /signup` -> Creates User.
- **Token**: `POST /token` (OAuth2 form) -> Returns JWT.
- **Profile**: `GET /users/me` -> Returns `UserResponse` (Requires `Depends(get_current_user)`).
