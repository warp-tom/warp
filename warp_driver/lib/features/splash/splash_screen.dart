import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.speed_rounded, // Distinct icon for driver
              size: 80,
              color: AppColors.backgroundLight,
            ),
            AppSpacing.gapMd,
            Text(
              'WARP DRIVER',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.backgroundLight,
                letterSpacing: 4.0, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
