import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class ActiveRideScreen extends StatelessWidget {
  const ActiveRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // 1. Full Screen Map
          const _MapPlaceholder(),

          // 2. Overlay UI
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Status Card
                _buildTopStatusCard(context),
                
                // Bottom Driver Info Sheet
                _buildDriverBottomSheet(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatusCard(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arriving in',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1),
                ),
                Row(
                  children: [
                    Text(
                      '3 min',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Text(
                      '(1.2 km)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Text('ARRIVING'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverBottomSheet(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -10),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag Handle Indicator
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Driver Row
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.borderLight,
                  child: const Icon(Icons.person, color: AppColors.textSecondaryLight),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mark Santos', style: Theme.of(context).textTheme.titleLarge),
                      AppSpacing.gapXs,
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                          AppSpacing.gapXs,
                          Text('4.9', style: Theme.of(context).textTheme.labelMedium),
                          AppSpacing.gapSm,
                          Text('•', style: Theme.of(context).textTheme.labelMedium),
                          AppSpacing.gapSm,
                          Text('Red Honda Click', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                // Plate Number Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '123 ABC',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 2),
                  ),
                )
              ],
            ),
            
            AppSpacing.gapLg,
            const Divider(height: 1, color: AppColors.borderLight),
            AppSpacing.gapLg,
            
            // Actions Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundLight,
                      foregroundColor: AppColors.textPrimaryLight,
                      side: const BorderSide(color: AppColors.borderLight),
                    ),
                    onPressed: () {}, 
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Call'),
                  ),
                ),
                AppSpacing.gapMd,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {}, 
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: const Text('Message'),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            
            // Debug jump to completion
            TextButton(
              onPressed: () => context.pushReplacement('/home'),
              child: const Text('End Trip (Dev Hook)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.borderLight.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 48, color: AppColors.textSecondaryLight),
            AppSpacing.gapSm,
            Text(
              'Live Map Feed',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
