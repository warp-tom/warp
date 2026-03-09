import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Driver Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.local_taxi, size: 48, color: AppColors.textSecondaryLight),
              ),
              AppSpacing.gapMd,
              Text(
                'Driver Mario',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                authState?.session?.user.phone ?? '+63 900 000 0000',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.gapXl,
              _buildSettingItem(context, Icons.directions_car, 'Vehicle Information'),
              _buildSettingItem(context, Icons.description, 'Documents & Licenses'),
              _buildSettingItem(context, Icons.account_balance, 'Bank Details'),
              _buildSettingItem(context, Icons.headset_mic, 'Contact Operator'),
              _buildSettingItem(context, Icons.settings, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }
}
