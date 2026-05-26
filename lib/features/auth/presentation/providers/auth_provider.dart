import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:libri_stack/core/providers/core_providers.dart';
import 'package:libri_stack/features/auth/data/auth_repository.dart';
import 'package:libri_stack/features/auth/presentation/providers/auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    final token = ref.watch(tokenStorageProvider);
    if (token != null) {
      // Auto-hydrate user profile if token exists
      _fetchUser();
    }
    return AuthState(token: token);
  }

  Future<void> _fetchUser() async {
    Future.microtask(() async {
      try {
        final repo = ref.read(authRepositoryProvider);
        final user = await repo.getCurrentUser();
        state = state.copyWith(user: user, isLoading: false);
      } catch (e) {
        // If fetch fails (token expired), the Dio interceptor will clear the token, triggering a rebuild.
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      final token = await repo.login(email, password);
      
      // Save token in SharedPreferences
      await ref.read(tokenStorageProvider.notifier).setToken(token);
      state = state.copyWith(token: token);

      final user = await repo.getCurrentUser();
      state = state.copyWith(user: user, isLoading: false);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        state = state.copyWith(
            isLoading: false,
            error: 'Cannot reach backend. Is the FastAPI server running on Port 8000?');
      } else {
        state = state.copyWith(
            isLoading: false,
            error: e.response?.data?['detail'] ?? e.message ?? e.toString());
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password, String? fullName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref
          .read(authRepositoryProvider)
          .register(email, password, fullName);
      // Auto-login after successful registration
      await login(email, password);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        state = state.copyWith(
            isLoading: false,
            error: 'Cannot reach backend. Is the FastAPI server running on Port 8000?');
      } else {
        state = state.copyWith(
            isLoading: false,
            error: e.response?.data?['detail'] ?? e.message ?? e.toString());
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await ref.read(tokenStorageProvider.notifier).setToken(null);
    state = const AuthState();
  }
}
