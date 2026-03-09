import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    // Check auth state and route accordingly
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Deep blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo. Using an Icon for now.
            const Icon(
              Icons.bolt_rounded,
              size: 80,
              color: AppColors.backgroundLight,
            ),
            AppSpacing.gapMd,
            Text(
              'WARP',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.backgroundLight,
                letterSpacing: 8.0, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
