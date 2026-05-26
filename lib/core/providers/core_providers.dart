import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libri_stack/core/config.dart';

part 'core_providers.g.dart';

@riverpod
class TokenStorage extends _$TokenStorage {
  static const _tokenKey = 'auth_token';

  @override
  String? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_tokenKey);
  }

  Future<void> setToken(String? token) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (token == null) {
      await prefs.remove(_tokenKey);
    } else {
      await prefs.setString(_tokenKey, token);
    }
    state = token;
  }
}

@riverpod
Dio dio(DioRef ref) {
  // FastAPI backend is on Port 8000 (from variables.md)
  final baseUrl = apiBaseUrl;

  final dioClient = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dioClient.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(tokenStorageProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        // Clear token on 401 Unauthorized
        await ref.read(tokenStorageProvider.notifier).setToken(null);
      }
      return handler.next(e);
    },
  ));

  return dioClient;
}

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}
