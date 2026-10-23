// lib/features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mastawekia_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mastawekia_app/features/auth/data/models/user_model.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  AuthCubit({
    required AuthRemoteDataSource remoteDataSource,
    FlutterSecureStorage? storage,
  })  : _remoteDataSource = remoteDataSource,
        _storage = storage ?? const FlutterSecureStorage(),
        super(AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
        final decodedToken = JwtDecoder.decode(token);
        final user = UserModel.fromJson(decodedToken);
        emit(Authenticated(user: user));
      } else {
        await _storage.delete(key: 'access_token');
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

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

  Future<void> register({
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AuthLoading());
    try {
      final authResponse = await _remoteDataSource.register(
        email: email,
        password: password,
        role: role,
      );
      emit(Authenticated(user: authResponse.user));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    emit(Unauthenticated());
  }
}