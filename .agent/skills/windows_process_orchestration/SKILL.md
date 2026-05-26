# 🛠️ Skill: Windows Process Orchestration

## 🌐 Overview
Methods for managing multi-tier process lifecycles on a Native Windows 11 host. Focuses on silent execution, port governance, and automatic cleanup.

## 📦 Logic: PowerShell Lifecycle Template

### 1. Port Governance check
```powershell
# Verify Port availability and offer to force-close if occupied
foreach ($port in $TargetPorts) {
    if (Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue) {
        Write-Host "   Force-closing processes on Port $port..." -ForegroundColor Yellow
        $pids = (Get-NetTCPConnection -LocalPort $port).OwningProcess | Select-Object -Unique
        foreach ($p in $pids) { Stop-Process -Id $p -Force -ErrorAction SilentlyContinue }
    }
}
```

### 2. Silent Managed Launch (PassThru)
```powershell
# Launch as background tier with hidden window
$Proc = Start-Process $Exe -ArgumentList $Args -PassThru -WindowStyle Hidden
Write-Host "Service started (PID: $($Proc.Id))"
```

### 3. Parent Lifecycle Anchor (try/finally)
```powershell
try {
    # Launch main UI/Frontend process (Wait for it)
    flutter run -d chrome
} finally {
    # AUTOMATIC CLEANUP: Terminate background children
    if ($null -ne $Proc) { Stop-Process -Id $Proc.Id -Force }
}
```

## 📏 Implementation Standards
- **Silent Execution**: Never allow backend console windows to "pop up" during development.
- **ID Specificity**: Always use `$proc.Id` captured at launch.
- **Zero-Ghost Policy**: A successful run must result in zero additional background tasks after the script terminates.

⚓
