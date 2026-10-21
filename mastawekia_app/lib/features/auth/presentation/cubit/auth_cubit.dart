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