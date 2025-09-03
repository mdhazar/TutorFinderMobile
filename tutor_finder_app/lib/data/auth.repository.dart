import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final Dio dio;
  final FlutterSecureStorage storage;
  AuthRepository(this.dio, this.storage);

  Future<void> register({
    required String username,
    required String password,
    required String role, // "student" | "tutor"
    String? email,
  }) async {
    await dio.post(
      '/auth/register/',
      data: {
        'username': username,
        'password': password,
        'role': role,
        if (email != null) 'email': email,
      },
    );
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final res = await dio.post(
      '/token/',
      data: {'username': username, 'password': password},
    );
    await storage.write(key: 'access', value: res.data['access']);
    await storage.write(key: 'refresh', value: res.data['refresh']);
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }
}
