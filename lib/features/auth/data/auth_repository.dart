import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<bool> login(String email, String password) async {
    // Simulated authentication call
    await Future.delayed(const Duration(milliseconds: 600));
    return email.isNotEmpty && password.length >= 6;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
