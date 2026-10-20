// lib/core/widgets/atmospheric_background.dart
import 'package:flutter/material.dart';
import 'package:mastawekia_app/core/constants/app_colors.dart';

class AtmosphericBackground extends StatelessWidget {
  final Widget child;

  const AtmosphericBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientBase1,
            AppColors.gradientBase2,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Radial glow top-right (Blue)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.gradientBlue, Colors.transparent],
                ),
              ),
            ),
          ),
          // Radial glow left-center (Pink)
          Positioned(
            top: 120,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.gradientPink, Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}