import subprocess
import traceback
import json
import os
import sys

# We use temporary files to track sync progress across subprocesses
STATUS_FILE = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "sync_status.json"))
STATUS_FILE_COVERS = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "covers_sync_status.json"))

def write_status(state: str, details: str = ""):
    try:
        with open(STATUS_FILE, "w") as f:
            json.dump({"status": state, "details": details}, f)
    except Exception as e:
        print(f"DEBUG: Failed to write sync status: {e}")

def get_sync_status() -> dict:
    if not os.path.exists(STATUS_FILE):
        return {"status": "idle", "details": ""}
    try:
        with open(STATUS_FILE, "r") as f:
            return json.load(f)
    except:
        return {"status": "error", "details": "Corrupt status file"}

def run_sync_workflow():
    current_status = get_sync_status()
    if current_status.get("status") in ["ingesting", "vectorizing", "enriching"]:
        print("Sync already in progress. Ignoring duplicate trigger.")
        return

    try:
        print(f"Starting Books Ingestion & Hydration Sync (Native Windows)...")
        write_status("ingesting", "Executing Ingestion & Hydration (Excel SSOT + Google Books + RTX 4050)")
        
        # Native Windows execution
        backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
        script_path = os.path.join(backend_dir, "scripts", "ingest_and_hydrate.py")
        
        python_exe = r"C:\PythonEnvs\.venv\Scripts\python.exe"
        if not os.path.exists(python_exe):
            python_exe = sys.executable
            
        ingest_cmd = [python_exe, script_path]
        
        subprocess.run(ingest_cmd, check=True, cwd=backend_dir)
        
        write_status("complete", "Ingestion and Hydration successfully completed")
        print("Sync Workflow Complete!")
        
    except subprocess.CalledProcessError as e:
        print(f"Sync workflow failed with exit code {e.returncode}")
        traceback.print_exc()
        write_status("error", f"Process failed with exit code {e.returncode}")
    except Exception as e:
        print(f"Sync workflow encountered an unexpected error: {e}")
        traceback.print_exc()
        write_status("error", str(e))

def write_covers_status(state: str, details: str = ""):
    try:
        with open(STATUS_FILE_COVERS, "w") as f:
            json.dump({"status": state, "details": details}, f)
    except Exception as e:
        print(f"DEBUG: Failed to write covers sync status: {e}")

def get_covers_sync_status() -> dict:
    if not os.path.exists(STATUS_FILE_COVERS):
        return {"status": "idle", "details": ""}
    try:
        with open(STATUS_FILE_COVERS, "r") as f:
            return json.load(f)
    except:
        return {"status": "error", "details": "Corrupt status file"}

def run_cover_sync_workflow():
    current_status = get_covers_sync_status()
    if current_status.get("status") in ["syncing"]:
        print("Covers sync already in progress. Ignoring duplicate trigger.")
        return

    try:
        print(f"Starting Books Cover Ingestion Sync (Native Windows)...")
        write_covers_status("syncing", "Executing Google Books Cover Ingestion and Sanitization")
        
        # Native Windows execution
        backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
        script_path = os.path.join(backend_dir, "sync_covers.py")
        
        python_exe = r"C:\PythonEnvs\.venv\Scripts\python.exe"
        if not os.path.exists(python_exe):
            python_exe = sys.executable
            
        cmd = [python_exe, script_path]
        
        subprocess.run(cmd, check=True, cwd=backend_dir)
        
        write_covers_status("complete", "Covers ingestion successfully completed")
        print("Covers Sync Workflow Complete!")
        
    except subprocess.CalledProcessError as e:
        print(f"Covers sync failed with exit code {e.returncode}")
        traceback.print_exc()
        write_covers_status("error", f"Process failed with exit code {e.returncode}")
    except Exception as e:
        print(f"Covers sync encountered an unexpected error: {e}")
        traceback.print_exc()
        write_covers_status("error", str(e))
