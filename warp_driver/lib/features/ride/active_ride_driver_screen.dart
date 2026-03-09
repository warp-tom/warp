import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class ActiveRideDriverScreen extends StatefulWidget {
  const ActiveRideDriverScreen({super.key});

  @override
  State<ActiveRideDriverScreen> createState() => _ActiveRideDriverScreenState();
}

class _ActiveRideDriverScreenState extends State<ActiveRideDriverScreen> {
  // Simple state machine: picking_up -> in_transit -> completed
  String _rideState = 'picking_up'; 

  void _advanceState() {
    setState(() {
      if (_rideState == 'picking_up') {
        _rideState = 'in_transit';
      } else if (_rideState == 'in_transit') {
        // Complete ride, go back to home
        context.pushReplacement('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPickingUp = _rideState == 'picking_up';
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          const _MapPlaceholder(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderCard(isPickingUp),
                _buildPassengerSheet(isPickingUp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(bool isPickingUp) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPickingUp ? AppColors.surfaceLight : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          children: [
            Icon(
              isPickingUp ? Icons.directions_car : Icons.navigation, 
              color: isPickingUp ? AppColors.primary : Colors.white,
            ),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPickingUp ? 'Pick up passenger' : 'Drop off passenger',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isPickingUp ? AppColors.textPrimaryLight : Colors.white,
                    ),
                  ),
                  Text(
                    isPickingUp ? 'SM City Mall Entrance 1' : '123 Main Street Residence',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isPickingUp ? AppColors.textSecondaryLight : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isPickingUp ? AppColors.backgroundLight : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isPickingUp ? AppColors.borderLight : Colors.transparent),
              ),
              child: Column(
                children: [
                  Text(
                    '3 min',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isPickingUp ? AppColors.textPrimaryLight : Colors.white,
                    ),
                  ),
                  Text(
                    '1.2 km',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isPickingUp ? AppColors.textSecondaryLight : Colors.white70,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerSheet(bool isPickingUp) {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -10))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
            
            Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.borderLight, child: const Icon(Icons.person, color: AppColors.textSecondaryLight)),
                AppSpacing.gapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Juan Dela Cruz', style: Theme.of(context).textTheme.titleLarge),
                      AppSpacing.gapXs,
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.warning),
                          AppSpacing.gapXs,
                          Text('4.8', style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call, color: AppColors.primary),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1)),
                ),
                AppSpacing.gapSm,
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1)),
                ),
              ],
            ),
            
            AppSpacing.gapLg,
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _advanceState,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPickingUp ? AppColors.primary : AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isPickingUp ? 'ARRIVED AT PICKUP' : 'COMPLETE DROP-OFF',
                ),
              ),
            ),
            AppSpacing.gapSm,
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
      color: AppColors.borderLight.withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.navigation, size: 48, color: AppColors.textSecondaryLight),
            AppSpacing.gapSm,
            Text(
              'Turn-by-turn Navigation',
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
