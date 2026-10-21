// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:mastawekia_app/core/constants/api_endpoints.dart';
import 'package:mastawekia_app/core/network/api_client.dart';
import 'package:mastawekia_app/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String role,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSourceImpl({required ApiClient client}) : _client = client;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await _client.storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );

      return authResponse;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Login failed';
      throw Exception(message is List ? message.first : message);
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'role': role.toUpperCase(), // Strictly 'USER' or 'CLIENT'
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      await _client.storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );

      return authResponse;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Registration failed';
      throw Exception(message is List ? message.first : message);
    }
  }
}