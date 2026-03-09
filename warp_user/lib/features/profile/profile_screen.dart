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
        title: const Text('Profile'),
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
                child: Icon(Icons.person, size: 48, color: AppColors.textSecondaryLight),
              ),
              AppSpacing.gapMd,
              Text(
                'Juan Dela Cruz',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                authState?.session?.user.phone ?? '+63 900 000 0000',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.gapXl,
              _buildSettingItem(context, Icons.payment, 'Payment Methods'),
              _buildSettingItem(context, Icons.favorite_border, 'Saved Places'),
              _buildSettingItem(context, Icons.notifications_none, 'Notifications'),
              _buildSettingItem(context, Icons.help_outline, 'Help & Support'),
              _buildSettingItem(context, Icons.info_outline, 'About Warp'),
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
