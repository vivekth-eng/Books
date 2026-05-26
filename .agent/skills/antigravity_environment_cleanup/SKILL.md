# Skill: Antigravity Environment Cleanup

Protocol for reducing the local disk footprint of AI artifacts without losing project-critical code.

## Objective
Automatically manage disk space by purging old recordings, screenshots, and orphaned conversations, and clearing browser cache while preserving authentications.

## Components

### 1. Cleanup Script
Location: `backend/scripts/cleanup_environment.py`

Handles:
- **Artifact Purge**: Deletes directories in `brain/` and `browser_recordings/` older than 7 days.
- **Temp Media Clear**: Clears `.tempmediaStorage` even in recent folders.
- **Conversation Maintenance**: Deletes `.pb` files in `conversations/` older than 30 days.
- **Browser Reset**: Clears `Cache`, `Code Cache`, and `GPUCache` in the browser profile.

## Usage

### Dry Run (Recommended first)
```powershell
python backend/scripts/cleanup_environment.py
```

### Execute Cleanup
```powershell
python backend/scripts/cleanup_environment.py --run
```

## Governance
- **Retention**: 7 days for task artifacts, 30 days for conversations.
- **Safety**: Never deletes the `Cookies` file to ensure Google AI Studio remains logged in.
