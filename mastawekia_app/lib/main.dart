// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawekia_app/app/routes.dart';
import 'package:mastawekia_app/core/network/api_client.dart';
import 'package:mastawekia_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MastawekiaApp());
}

class MastawekiaApp extends StatefulWidget {
  const MastawekiaApp({super.key});

  @override
  State<MastawekiaApp> createState() => _MastawekiaAppState();
}

class _MastawekiaAppState extends State<MastawekiaApp> {
  late final ApiClient _apiClient;
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _authRemoteDataSource = AuthRemoteDataSourceImpl(client: _apiClient);
    _authCubit = AuthCubit(remoteDataSource: _authRemoteDataSource)..checkAuthStatus();
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRoutes.createRouter(_authCubit);

    return BlocProvider<AuthCubit>.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: 'Mastawekia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}