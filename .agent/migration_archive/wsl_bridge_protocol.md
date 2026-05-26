---
description: Setup guide for Windows-to-WSL Directory Junctions to enable Docker hot-reload.
---

# WSL Bridge Protocol (Directory Junctions)

This skill documents the "Directory Junction" technique used to bridge a Windows IDE (like VS Code or Android Studio) with a Linux/Docker environment running in WSL2.

## 1. The Problem
- **Docker on Windows**: Slow filesystem performance if code lives on `/mnt/c/`.
- **Docker on WSL**: Fast performance, but file access from Windows tools can be tricky.
- **Goal**: Edit code in Windows, run fast in Linux Docker, with working Hot-Reload.

## 2. The Solution: Directory Junction (`mklink /j`)

A Junction is a hard link that makes a Windows folder point to a WSL directory. Tools see it as a local folder.

### Setup Architecture
1.  **Source of Truth**: The code lives in WSL (e.g., `\\wsl.localhost\Ubuntu\home\user\project\backend`).
2.  **The Bridge**: A Junction in the Windows project root points to that WSL path.

## 3. Implementation Steps

1.  **Move Code to WSL**:
    Move your backend folder to your WSL home directory.
    ```bash
    # In WSL terminal
    mv /mnt/c/Users/You/Project/backend ~/project/backend
    ```

2.  **Create Junction (Windows CMD)**:
    Open `cmd.exe` as Administrator.
    ```cmd
    cd C:\Users\You\Project
    mklink /j backend \\wsl.localhost\Ubuntu\home\user\project\backend
    ```

3.  **Result**:
    - Windows Explorer sees `backend` folder.
    - Docker (in WSL) sees `backend` folder.
    - **Hot-Reload**: When you save `main.py` in Windows, Linux receives the file change event *instantly*. Uvicorn reloads.

## 4. Troubleshooting

- **"Access Denied"**: Ensure you use `cmd` (Command Prompt), NOT PowerShell. PowerShell does not support `mklink` natively.
- **Git Status**: Git will track files inside the junction correctly.
- **Performance**: This method bypasses the slow `/mnt/c` mount, giving native Linux I/O speed to the container.
⚓
