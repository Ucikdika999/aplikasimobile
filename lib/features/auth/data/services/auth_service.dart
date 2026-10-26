import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(apiClientProvider);
  const secureStorage = FlutterSecureStorage();
  return AuthService(dio: dio, secureStorage: secureStorage);
});

class AuthService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AuthService({
    required this.dio,
    required this.secureStorage,
  });

  /// Melakukan login akun via Dio/Mock API dan menyimpan JWT token ke FlutterSecureStorage
  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    // Simulasi delay panggilan network API Dio
    await Future.delayed(const Duration(milliseconds: 900));

    // Validasi kredensial login (mock authentication)
    if (email.trim().isEmpty || password.length < 6) {
      throw Exception('Format email atau kata sandi tidak valid.');
    }

    // Role mockup berdasarkan prefix email (contoh: dosen@ / mahasiswa)
    final isDosen = email.toLowerCase().contains('dosen');
    final role = isDosen ? 'dosen' : 'mahasiswa';
    final name = isDosen ? 'Dr. Alex Pratama, M.Kom.' : 'Alex Pratama';

    // Dummy JWT Token
    final mockToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        '${base64Url.encode(utf8.encode('{"sub":"usr-001","email":"$email","role":"$role"}'))}.'
        'nexed_secure_sig_99x';

    final user = UserModel(
      id: 'usr-nexed-001',
      name: name,
      email: email.trim(),
      role: role,
      level: isDosen ? 12 : 4,
      totalXp: isDosen ? 12400 : 4850,
    );

    // Simpan token JWT dan informasi pengguna ke FlutterSecureStorage
    await secureStorage.write(key: AppConstants.tokenKey, value: mockToken);
    await secureStorage.write(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );

    return (user: user, token: mockToken);
  }

  /// Membaca JWT token tersimpan dari secure storage
  Future<String?> getSavedToken() async {
    return await secureStorage.read(key: AppConstants.tokenKey);
  }

  /// Membaca data UserModel tersimpan dari secure storage
  Future<UserModel?> getSavedUser() async {
    final userData = await secureStorage.read(key: AppConstants.userKey);
    if (userData != null && userData.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(userData);
        return UserModel.fromJson(json);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Menghapus sesi autentikasi dan token
  Future<void> logout() async {
    await secureStorage.delete(key: AppConstants.tokenKey);
    await secureStorage.delete(key: AppConstants.userKey);
  }
}
