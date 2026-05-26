# Skill: Tier 1 - Frontend (Flutter)

## Description
Standard patterns for a Flutter frontend connecting to a containerized FastAPI backend.

## 1. API Client Strategy
Use `Dio` with a `Provider` to manage the HTTP client. Centralize the `baseUrl` and Auth headers.

```dart
// lib/core/network/api_client_provider.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    // Use WSL IP (172.x) or Android localhost (10.0.2.2)
    // Use Localhost (127.0.0.1) or Host IP for mobile
    baseUrl: dotenv.env['APP_API_BASE_URL'] ?? 'http://127.0.0.1:8000', 
    connectTimeout: const Duration(seconds: 5),
  ));

  const storage = FlutterSecureStorage();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.read(key: 'auth_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));
  return dio;
});
```

## 2. Authentication Flow
- **Storage**: Use `flutter_secure_storage` for JWTs.
- **State**: Use `StreamController<User?>` in a Repository to broadcast auth state changes.
- **Handshake**: 
    1. Check storage for token on launch.
    2. If found, hit `/users/me` (Profile Endpoint).
    3. If 200 OK, restore session. If 401, clear token.

## 3. Chrome CORS Handling
- Flutter Web (Chrome) enforces CORS. 
- **Fix**: Ensure Backend sends `Access-Control-Allow-Origin: *` (Dev only).
- **Run Command**: `flutter run -d chrome --web-renderer html` (Optional: `--disable-web-security` for strict debug only).
