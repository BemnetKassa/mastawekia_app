// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawekia_app/core/network/api_client.dart';
import 'package:mastawekia_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mastawekia_app/features/auth/presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MastawekiaApp());
}

class MastawekiaApp extends StatelessWidget {
  const MastawekiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize client and data source instances
    final apiClient = ApiClient();
    final authRemoteDataSource = AuthRemoteDataSourceImpl(client: apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            remoteDataSource: authRemoteDataSource,
          )..checkAuthStatus(),
        ),
      ],
      child: MaterialApp(
        title: 'Mastawekia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}