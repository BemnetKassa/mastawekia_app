// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  // Base URL for the NestJS backend
  // Can be configured at build/run time via --dart-define=API_BASE_URL=http://<host>:<port>
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  static const String refreshToken = '/auth/refresh';

  // Future feature endpoints
  static const String jobs = '/jobs';
  static const String applications = '/applications';
}
