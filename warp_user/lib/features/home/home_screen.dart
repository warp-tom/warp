import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import 'widgets/map_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.gapMd,
              _buildGreeting(context),
              AppSpacing.gapXl,
              _buildSearchBar(context),
              AppSpacing.gapXl,
              _buildServiceGrid(context),
              AppSpacing.gapXl,
              _buildRecentMapPreview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        Text(
          'Juan Dela Cruz',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.primary),
          AppSpacing.gapMd,
          Text(
            'Where to?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ServiceCard(
            title: 'Ride',
            icon: Icons.bolt_rounded,
            onTap: () => context.push('/ride/request'),
          ),
        ),
        AppSpacing.gapMd,
        Expanded(
          child: _ServiceCard(
            title: 'Parcel',
            icon: Icons.local_shipping_rounded,
            onTap: () => context.push('/parcel/request'),
          ),
        ),
        AppSpacing.gapMd,
        Expanded(
          child: _ServiceCard(
            title: 'Errand',
            icon: Icons.shopping_bag_rounded,
            onTap: () => context.push('/errand/request'),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentMapPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Around You',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        AppSpacing.gapMd,
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: const LiveMapView(),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            AppSpacing.gapSm,
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
