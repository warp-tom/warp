import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class IncomingJobScreen extends StatefulWidget {
  const IncomingJobScreen({super.key});

  @override
  State<IncomingJobScreen> createState() => _IncomingJobScreenState();
}

class _IncomingJobScreenState extends State<IncomingJobScreen> {
  // Simulate the 15-second acceptance window
  double _progress = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const duration = Duration(milliseconds: 100);
    const totalTime = 15000; // 15 seconds
    int elapsed = 0;

    _timer = Timer.periodic(duration, (timer) {
      if (mounted) {
        setState(() {
          elapsed += 100;
          _progress = 1.0 - (elapsed / totalTime);
        });

        if (elapsed >= totalTime) {
          timer.cancel();
          context.pop(); // Auto-reject/missed job
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleAccept() {
    _timer?.cancel();
    context.pushReplacement('/ride/active_driver');
  }

  void _handleReject() {
    _timer?.cancel();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Map Preview
            const Expanded(
               flex: 3,
               child: _MapPlaceholder()
            ),
            
            // Job Details Card
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: AppSpacing.screenPadding,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -10))
                  ],
                ),
                child: Column(
                  children: [
                    // Timer bar
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.borderLight,
                      color: _progress > 0.3 ? AppColors.primary : AppColors.error,
                      minHeight: 4,
                    ),
                    AppSpacing.gapXl,
                    
                    Text(
                      'New Ride Request',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.gapLg,
                    
                    // Route Info
                    _buildRouteTimeline(context),
                    
                    const Spacer(),
                    
                    // Earnings Preview
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(label: 'Est. Earnings', value: '₱ 65', context: context),
                          Container(width: 1, height: 40, color: AppColors.borderLight),
                          _StatItem(label: 'Distance', value: '2.4 km', context: context),
                        ],
                      ),
                    ),
                    
                    AppSpacing.gapLg,
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _handleReject,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              foregroundColor: AppColors.textSecondaryLight,
                              side: const BorderSide(color: AppColors.borderLight),
                            ),
                            child: const Text('Decline'),
                          ),
                        ),
                        AppSpacing.gapMd,
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _handleAccept,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('ACCEPT JOB'),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapSm,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteTimeline(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Icon(Icons.my_location, size: 20, color: AppColors.primary),
                const SizedBox(height: 4),
                Container(width: 2, height: 24, color: AppColors.borderLight),
                const SizedBox(height: 4),
                const Icon(Icons.location_on, size: 20, color: AppColors.error),
              ],
            ),
            AppSpacing.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup', style: Theme.of(context).textTheme.labelSmall),
                  Text('SM City Mall Entrance 1', style: Theme.of(context).textTheme.titleMedium),
                  AppSpacing.gapLg,
                  Text('Dropoff', style: Theme.of(context).textTheme.labelSmall),
                  Text('123 Main Street Residence', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _StatItem({required this.label, required this.value, required this.context});

  @override
  Widget build(BuildContext _) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        AppSpacing.gapXs,
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimaryLight,
        )),
      ],
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
            const Icon(Icons.route, size: 48, color: AppColors.primary),
            AppSpacing.gapSm,
            Text(
              'Route Preview Loading...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
