import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:libri_stack/core/config.dart';
import 'package:libri_stack/core/providers/core_providers.dart';
import 'package:libri_stack/features/auth/domain/user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this.dio);
  final Dio dio;

  Future<String> login(String email, String password) async {
    if (kMockDemoMode) {
      if (email == 'test000@example.com' && password == 'test000') {
        return 'mock_token_123';
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/token'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/token'),
            statusCode: 401,
            data: {'detail': 'Invalid credentials. Use test000@example.com / test000.'},
          ),
        );
      }
    }
    final response = await dio.post(
      '/auth/token',
      data: FormData.fromMap({
        'username': email,
        'password': password,
      }),
    );
    return response.data['access_token'];
  }

  Future<void> register(String email, String password, String? fullName) async {
    if (kMockDemoMode) {
      return;
    }
    await dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'full_name': fullName,
      },
    );
  }

  Future<User> getCurrentUser() async {
    if (kMockDemoMode) {
      return const User(
        id: 123,
        email: 'test000@example.com',
        fullName: 'Test User',
      );
    }
    final response = await dio.get('/users/me');
    return User.fromJson(response.data);
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
}
