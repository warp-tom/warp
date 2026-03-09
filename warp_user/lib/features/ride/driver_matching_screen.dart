import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class DriverMatchingScreen extends StatefulWidget {
  const DriverMatchingScreen({super.key});

  @override
  State<DriverMatchingScreen> createState() => _DriverMatchingScreenState();
}

// Scaffold logic mimicking the dispatch timeline (Score -> Send -> Wait -> Accept)
class _DriverMatchingScreenState extends State<DriverMatchingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate matching success after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.pushReplacement('/ride/active');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Simulated Map Background
          Container(color: AppColors.borderLight.withValues(alpha: 0.3)),
          
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: AppSpacing.screenPadding,
                    child: CircleAvatar(
                      backgroundColor: AppColors.surfaceLight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textPrimaryLight),
                        onPressed: () => context.pop(), // Cancel search
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                
                // Pulsing Search Animation
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                ),
                
                AppSpacing.gapXl,
                Text(
                  'Finding your driver...',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                AppSpacing.gapSm,
                Text(
                  'Contacting nearest vehicles',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const Spacer(),
                
                // Bottom Cancel Bar
                Container(
                  padding: AppSpacing.screenPadding,
                  width: double.infinity,
                  color: AppColors.surfaceLight,
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                    ),
                    child: const Text('Cancel Request'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
