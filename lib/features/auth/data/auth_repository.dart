import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:libri_stack/core/providers/core_providers.dart';
import 'package:libri_stack/features/auth/domain/user.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this.dio);
  final Dio dio;

  Future<String> login(String email, String password) async {
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
    final response = await dio.get('/users/me');
    return User.fromJson(response.data);
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
}
