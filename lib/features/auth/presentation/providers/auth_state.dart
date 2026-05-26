import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:libri_stack/features/auth/domain/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    User? user,
    String? token,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;

  bool get isAuthenticated => user != null && token != null;
}
