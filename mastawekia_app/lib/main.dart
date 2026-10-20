// lib/main.dart
import 'package:flutter/material.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const MastawekiaApp());
}

class MastawekiaApp extends StatelessWidget {
  const MastawekiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mastawekia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}