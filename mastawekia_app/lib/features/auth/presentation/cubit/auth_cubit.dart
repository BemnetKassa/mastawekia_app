// lib/features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  AuthCubit({
    required AuthRemoteDataSource remoteDataSource,
    FlutterSecureStorage? storage,
  })  : _remoteDataSource = remoteDataSource,
        _storage = storage ?? const FlutterSecureStorage(),
        super(AuthInitial());

  // Check if an existing JWT exists in device storage on launch
  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      // Optional: Fetch current user profile endpoint if needed
      // For now, mark as authenticated if token exists
      emit(Unauthenticated()); // Change to Authenticated once profile endpoint is connected
    } else {
      emit(Unauthenticated());
    }
  }

  // Handle Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final authResponse = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      emit(Authenticated(user: authResponse.user));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Handle Register
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AuthLoading());
    try {
      final authResponse = await _remoteDataSource.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      emit(Authenticated(user: authResponse.user));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Handle Logout
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    emit(Unauthenticated());
  }
}