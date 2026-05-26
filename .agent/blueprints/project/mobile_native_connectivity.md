# The "Poco Bridge" Blueprint: Mobile Native Connectivity

## 1. Objective
Ensure seamless network connectivity and asset hydration between the Flutter Android build (running on a Poco X7 Pro or emulator) and the Native Windows Host (running FastAPI).

## 2. IP Address Handshake Protocol
- **Localhost Limits:** The mobile device cannot use `127.0.0.1` or `localhost` to hit the Windows machine.
- **Wi-Fi Resolution:** You MUST obtain the Windows Host's IPv4 address on the local network (e.g., `192.168.1.x`).
- **Configuration:** Set the `{{APP_API_BASE_URL}}` in the `.env` or configuration file to `http://192.168.1.x:8001` before compiling `flutter run -d [Poco_Device_ID]`.

## 3. Asset Hydration (fullPosterPath Logic)
- **Issue:** If the backend returns `http://localhost:8001/assets/poster.jpg`, the mobile app will try to load from its own loopback interface and fail to display images.
- **Solution:** The FastAPI `MediaUrlBuilder` must dynamically prepend the host's actual network IP instead of `localhost` when the request originates from the mobile app, or the Mobile app must rewrite `localhost` to the correct base URL upon model hydration. 

## 4. Port & Firewall Checks
- Ensure Port 8001 is open in the Windows Defender Firewall.
- Ensure the network type is set to **Private**.
