# run_bookstack.ps1

param(
    [switch]$Sync = $false,
    [switch]$Build = $false,
    [string]$Device = "chrome"
)

$ErrorActionPreference = "Stop"

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "   LIBRISTACK SYSTEM BOOTSTRAPPER (3-Tier Local Architecture)     " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan

# 1. Verify PostgreSQL 17 Service
Write-Host "[1/4] Checking PostgreSQL 17 Service..." -ForegroundColor Yellow
$pgService = Get-Service -Name "postgresql-x64-17" -ErrorAction SilentlyContinue
if ($null -eq $pgService) {
    $pgService = Get-Service -Name "postgresql*" | Where-Object { $_.Status -eq "Running" } | Select-Object -First 1
}

if ($null -eq $pgService -or $pgService.Status -ne "Running") {
    Write-Host "ERROR: PostgreSQL is not running. Please start the 'postgresql-x64-17' service." -ForegroundColor Red
    exit 1
} else {
    Write-Host "SUCCESS: PostgreSQL is active." -ForegroundColor Green
}

# 2. Cleanup and Initial Variables
Write-Host "[2/4] Pre-launch Cleanup and Configuration..." -ForegroundColor Yellow

# Force Clear Port 8000 (FastAPI Backend)
$port = 8000
$portOwner = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Where-Object { $_.State -eq "Listen" }
if ($portOwner) {
    Write-Host "   Force-closing processes on Port $port..." -ForegroundColor Gray
    $pids = @($portOwner.OwningProcess) | Select-Object -Unique
    foreach ($targetPid in $pids) { 
        if (Get-Process -Id $targetPid -ErrorAction SilentlyContinue) {
            Stop-Process -Id $targetPid -Force -ErrorAction SilentlyContinue 
        }
    }
}

$pythonExe = "C:\PythonEnvs\.venv\Scripts\python.exe"
if (-not (Test-Path $pythonExe)) {
    $pythonExe = Join-Path $PSScriptRoot "backend\.venv\Scripts\python.exe"
}

if (-not (Test-Path $pythonExe)) {
    Write-Host "ERROR: Native .venv not found at $pythonExe." -ForegroundColor Red
    exit 1
}

# Ensure .env values don't leak into Git (Agentic Guardrail Check)
$ENV_FILE = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $ENV_FILE)) {
    Write-Error "CRITICAL FAILURE: .env file is missing in the root directory! Cannot parse secure credentials."
}

if (Test-Path (Join-Path $PSScriptRoot ".git")) {
    $gitCheck = git check-ignore .env 2>$null
    if ([string]::IsNullOrEmpty($gitCheck)) {
        Write-Host "   Fixing .gitignore leak guardrails..." -ForegroundColor Gray
        Add-Content (Join-Path $PSScriptRoot ".gitignore") "`n.env`n.venv/`n*.xlsx"
    }
}

# 2.5 Optional Code Generation (Flutter Build Runner)
if ($Build) {
    Write-Host "[2.5/4] Triggering [Build-Runner] Mandate..." -ForegroundColor Yellow
    flutter pub run build_runner build --delete-conflicting-outputs
}

# 2.6 Modular Integrity Check
Write-Host "   Verifying Modular Integrity..." -ForegroundColor Gray
$requiredInits = @(
    "backend\app\__init__.py",
    "backend\app\core\__init__.py",
    "backend\app\services\__init__.py"
)
foreach ($initFile in $requiredInits) {
    if (-not (Test-Path (Join-Path $PSScriptRoot $initFile))) {
        Write-Host "ERROR: Modular anchor missing: $initFile" -ForegroundColor Red
        exit 1
    }
}

# 2.7 Optional Data Ingestion and Google Books Sync
if ($Sync) {
    Write-Host "[2.7/4] Executing Spreadsheet Ingestion and Metadata Hydration..." -ForegroundColor Yellow
    # Running ingestion in foreground so the user sees progress logs for the 58k dataset
    Set-Location (Join-Path $PSScriptRoot "backend")
    & $pythonExe scripts/ingest_and_hydrate.py
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Spreadsheet ingestion failed. Review the logs in backend/logs/sync_report.log."
    }
    Set-Location $PSScriptRoot
}

$backendProc = $null

try {
    # 3. Silent Managed Launch (FastAPI Server)
    Write-Host "[3/4] Starting Background API Services..." -ForegroundColor Yellow
    
    # Start FastAPI on Port 8001 (Hidden) with Log Redirection
    $backendOut = Join-Path $PSScriptRoot "backend\backend_stdout.log"
    $backendErr = Join-Path $PSScriptRoot "backend\backend_stderr.log"
    
    # Remove old logs to prevent confusion
    if (Test-Path $backendOut) { Remove-Item $backendOut }
    if (Test-Path $backendErr) { Remove-Item $backendErr }
    
    $backendArgs = "-m uvicorn app.main:app --host 0.0.0.0 --port 8000"
    $backendProc = Start-Process $pythonExe -ArgumentList $backendArgs -WorkingDirectory (Join-Path $PSScriptRoot "backend") -PassThru -WindowStyle Hidden -RedirectStandardOutput $backendOut -RedirectStandardError $backendErr 
    
    Write-Host "   FastAPI Server (Port 8000) started (PID: $($backendProc.Id))." -ForegroundColor Gray
    Write-Host "   Logs redirected to backend_stdout.log and backend_stderr.log." -ForegroundColor Gray

    # 4. Wait for Backend Health Check
    Write-Host "   Waiting for http://127.0.0.1:8000/health connection (60s grace)..." -ForegroundColor Gray
    $healthy = $false
    for ($i = 0; $i -lt 60; $i++) {
        try {
            $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method Get -TimeoutSec 1
            if ($response.status -eq "healthy") { 
                $healthy = $true
                break 
            }
        } catch { 
            # Check if backend process died early
            if ($backendProc.HasExited) {
                Write-Host "ERROR: FastAPI process exited prematurely." -ForegroundColor Red
                break
            }
            Start-Sleep -Seconds 1 
        }
    }

    if (-not $healthy) { 
        Write-Host "CRITICAL ERROR: Backend failed to respond to health check." -ForegroundColor Red
        if (Test-Path $backendErr) {
            Write-Host "--- Backend Error Traceback (Last 20 lines) ---" -ForegroundColor Yellow
            Get-Content $backendErr -Tail 20
        }
        throw "Backend Handshake Failed." 
    }
    Write-Host "SUCCESS: 3-Tier Handshake complete." -ForegroundColor Green

    # Lifecycle Lock Check: Scan for errors in stderr logs
    if (Test-Path $backendErr) {
        $errContent = Get-Content $backendErr | Where-Object { $_ -notmatch "^INFO:" }
        if ($errContent) {
            Write-Host "WARNING: Non-critical log outputs in backend_stderr.log. Check for details." -ForegroundColor Yellow
        }
    }

    # 5. Launch Flutter (Primary UI Process)
    Write-Host "[4/4] Launching Flutter Client on Device: $Device..." -ForegroundColor Yellow
    flutter run -d $Device

} catch {
    Write-Host "CRITICAL ERROR: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # AUTOMATIC CLEANUP: Terminate background processes when Flutter exits or error occurs
    Write-Host "`n--- Script Terminating: Performing Lifecycle Cleanup ---" -ForegroundColor Cyan
    if ($null -ne $backendProc -and -not $backendProc.HasExited) {
        Write-Host "   Stopping FastAPI Server (PID: $($backendProc.Id))...." -ForegroundColor Gray
        Stop-Process -Id $backendProc.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "Cleanup finished. Port 8000 released." -ForegroundColor Green
}
