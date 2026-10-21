// lib/features/jobs/presentation/screens/seeker_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastawekia_app/core/constants/app_colors.dart';
import 'package:mastawekia_app/core/widgets/atmospheric_background.dart';
import 'package:mastawekia_app/features/auth/presentation/cubit/auth_cubit.dart'; // <-- Package import

class SeekerFeedScreen extends StatelessWidget {
  const SeekerFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Find Opportunities',
          style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: const AtmosphericBackground(
        child: Center(
          child: Text(
            'Job Seeker Feed & Search',
            style: TextStyle(color: AppColors.foreground, fontSize: 18),
          ),
        ),
      ),
    );
  }
}