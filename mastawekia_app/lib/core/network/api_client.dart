// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mastawekia_app/core/constants/api_endpoints.dart';
import 'package:mastawekia_app/core/network/auth_interceptor.dart';

class ApiClient {
  late final Dio dio;
  final FlutterSecureStorage storage;

  ApiClient({FlutterSecureStorage? secureStorage})
      : storage = secureStorage ?? const FlutterSecureStorage() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage: storage));

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }
}