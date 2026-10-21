// lib/features/auth/data/models/auth_response_model.dart
import 'package:jwt_decoder/jwt_decoder.dart';
import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final token = (json['access_token'] ?? json['accessToken']) as String;

    // If backend provided a nested 'user' object, use it; otherwise decode the JWT payload
    UserModel parsedUser;
    if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      parsedUser = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    } else {
      final decodedToken = JwtDecoder.decode(token);
      parsedUser = UserModel.fromJson(decodedToken);
    }

    return AuthResponseModel(
      accessToken: token,
      user: parsedUser,
    );
  }
}