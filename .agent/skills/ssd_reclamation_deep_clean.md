# Skill: SSD Reclamation & Deep Clean

## Overview
Procedures for reclaiming high-volume SSD space (>35GB) after project archival or during long-term maintenance.

## 1. The "Nuclear" Docker Prune
Completely wipe the build cache and unused artifacts to reclaim 30-50GB.

- **Prune All**: `docker system prune -a -f`
- **Wipe Build Cache**: `docker builder prune -a -f`
- **Wipe Volumes**: `docker volume prune -f`

## 2. Windows VHDX Compaction Guide
On Windows, Docker consumes space via a `.vhdx` file that does not automatically shrink.

- **Stop Docker Desktop**.
- **Admin PowerShell**:
  ```powershell
  ls $env:LOCALAPPDATA\Docker\wsl\data\ext4.vhdx # Identify path
  diskpart
  select vdisk file="[PATH_TO_VHDX]"
  attach vdisk readonly
  compact vdisk
  detach vdisk
  exit
  ```
  > [!WARNING]
  > Failure to compact the VHDX means Disk C: free space will not increase even after a Docker prune.

## 3. Cache Purge Paths
Reclaim 2-5GB from package managers and IDEs.

- **Flutter/Pub**: `flutter clean` & `dart pub cache clean --force`
- **Global Pub Cache**: `C:\Users\vivek\AppData\Local\Pub\Cache`
- **Python/Pip**: `pip cache purge`
- **Android/Gradle**: 
    - Delete `C:\Users\vivek\.gradle\caches`
    - Delete `C:\Users\vivek\.gradle\wrapper`
- **Antigravity**: `C:\Users\vivek\.gemini\antigravity\browser_recordings`

## 4. Python Temporary Files
Search and destroy distributed cache folders:
```powershell
Get-ChildItem -Path . -Include .pytest_cache, __pycache__ -Recurse -Force | Remove-Item -Recurse -Force
```
