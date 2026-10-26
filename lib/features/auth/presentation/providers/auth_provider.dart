import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';

enum AuthStatus {
  unauthenticated,
  loading,
  authenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? token;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.token,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(UserModel user, String token) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
        token: token,
      );
  factory AuthState.unauthenticated([String? error]) => AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error,
      );

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    _checkInitialAuth();
    return AuthState.initial();
  }

  /// Cek apakah sudah ada token tersimpan di storage saat startup
  Future<void> _checkInitialAuth() async {
    try {
      final token = await _authService.getSavedToken();
      final user = await _authService.getSavedUser();
      if (token != null && user != null) {
        state = AuthState.authenticated(user, token);
      }
    } catch (_) {
      state = AuthState.unauthenticated();
    }
  }

  /// Eksekusi proses login dengan validasi dan handling status
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();
    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(result.user, result.token);
      return true;
    } catch (e) {
      state = AuthState.unauthenticated(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  /// Logout akun
  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.unauthenticated();
  }
}

/// Provider Notifier resmi Riverpod 3 untuk AuthNotifier
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Alias provider untuk kemudahan akses
final authProvider = authNotifierProvider;
