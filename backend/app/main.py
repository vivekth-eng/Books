from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse
import os
import logging
import mimetypes
import threading
from dotenv import load_dotenv

# Path resolution to load root .env
current_dir = os.path.dirname(os.path.abspath(__file__))
root_env_path = os.path.abspath(os.path.join(current_dir, "..", "..", ".env"))
load_dotenv(root_env_path, override=True)

from app.core.database import init_db
from app.services.sync_service import (
    run_sync_workflow, 
    get_sync_status, 
    run_cover_sync_workflow, 
    get_covers_sync_status
)
from app.api.v1 import auth, books

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(levelname)s: %(name)s: %(message)s"
)
logger = logging.getLogger("book_api")

# Ensure JPG/PNG are recognized
mimetypes.add_type('image/jpeg', '.jpg')
mimetypes.add_type('image/png', '.png')

app = FastAPI(title="LibriStack Books Database API")

# Hardened CORS for Native Windows
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"]
)

# Custom middleware for Private Network Access (CORS option request)
@app.middleware("http")
async def add_private_network_header(request, call_next):
    if request.method == "OPTIONS":
        response = await call_next(request)
        response.headers["Access-Control-Allow-Private-Network"] = "true"
        return response
    response = await call_next(request)
    response.headers["Access-Control-Allow-Private-Network"] = "true"
    return response

# Static Mount for Covers
# Mount assets/covers directory under /static/covers
COVER_PATH = os.path.abspath(os.path.join(current_dir, "..", "..", "assets", "covers"))
os.makedirs(COVER_PATH, exist_ok=True)
app.mount("/static/covers", StaticFiles(directory=COVER_PATH), name="covers")

@app.on_event("startup")
def on_startup():
    init_db()
    try:
        cover_count = len([f for f in os.listdir(COVER_PATH) if f.endswith(".jpg")])
        logger.info(f"COVER INTEGRITY: Found {cover_count} cover assets in {COVER_PATH}")
    except Exception as e:
        logger.error(f"COVER INTEGRITY ERROR: Could not reach covers folder: {e}")

@app.get("/")
def root():
    return RedirectResponse(url="/docs")

@app.get("/health")
def health():
    return {"status": "healthy"}

# Sync Endpoints
@app.get("/sync/status")
def sync_status():
    return get_sync_status()

@app.post("/sync/trigger")
def trigger_sync():
    # Run sync in background thread
    threading.Thread(target=run_sync_workflow).start()
    return {"message": "Sync started"}

@app.post("/api/v1/sync/covers")
def trigger_covers_sync():
    # Run cover sync in background thread
    threading.Thread(target=run_cover_sync_workflow).start()
    return {"message": "Cover sync started"}

@app.get("/api/v1/sync/covers/status")
def covers_sync_status():
    return get_covers_sync_status()

# Modular Routers
app.include_router(auth.router, tags=["Auth"])
app.include_router(books.router, tags=["Books"])
