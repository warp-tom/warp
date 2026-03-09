import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Activity'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Trips'),
              Tab(text: 'Parcels'),
              Tab(text: 'Errands'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _EmptyActivityView(message: 'No trips yet'),
            _EmptyActivityView(message: 'No parcels yet'),
            _EmptyActivityView(message: 'No errands yet'),
          ],
        ),
      ),
    );
  }
}

class _EmptyActivityView extends StatelessWidget {
  final String message;

  const _EmptyActivityView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_toggle_off, size: 64, color: AppColors.borderLight),
          AppSpacing.gapMd,
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
