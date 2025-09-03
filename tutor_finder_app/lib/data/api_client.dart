import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutor_finder_app/config/api.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage storage;

  ApiClient(this.dio, this.storage) {
    dio.options.baseUrl = apiBaseUrl();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'access');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
}
