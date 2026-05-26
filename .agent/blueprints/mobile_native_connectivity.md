# Mobile Native Connectivity Blueprint

## Overview
This blueprint defines the parameters for allowing physical mobile devices (e.g., Poco X7 Pro) to connect to the native Windows 11 backend services running the CineStack application without using Docker.

## Prerequisites
- Windows 11 host with FastAPI backend and PostgreSQL running natively.
- Mobile device connected to the exact same local Wi-Fi network as the Windows 11 host.

## 1. CORS Implementation Audit (Mandatory)
Before a mobile device can connect, the FastAPI backend must be configured to allow Cross-Origin Resource Sharing (CORS) from the device's IP address.

### FastAPI Configuration
Ensure the backend `main.py` explicitly allows all origins during development (`allow_origins=["*"]`).
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "*"  # Allow all during development. Production list for GitHub release: ["https://yourdomain.com", "http://localhost:8080"]
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 2. Dynamic IP Configuration
The Flutter application is running on the device, but the API lives on the Desktop. Use your Windows host's local IPv4 address.
- Flutter `ApiConstants` (or `BASE_URL`) must be explicitly set to `http://<YOUR_WINDOWS_IPv4>:8001`. Do not use `localhost` or `10.0.2.2` because it's a physical device on the LAN, not an emulator.

## 3. Host Firewall Settings
Ensure Windows Defender Firewall allows incoming connections on the necessary API ports (e.g., Port 8000 and 8001) for TCP traffic.

## 4. Error Handling Polish
The Flutter frontend handles connection errors gracefully using `DioException`. If the frontend cannot reach the backend (e.g., due to IP mismatch or firewall block), it catches `DioExceptionType.connectionError` and displays this user-friendly message:
`Cannot reach backend. Is the server running on Port 8000?`
