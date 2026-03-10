import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildOnlineToggle(),
          if (_isOnline) ...[
             const Expanded(child: _MapPlaceholder()),
             _buildBottomCard(),
          ] else ...[
             const Expanded(child: _OfflineState()),
          ]
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'WARP DRIVER',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(letterSpacing: 2),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildOnlineToggle() {
    return Container(
      color: AppColors.surfaceLight,
      padding: AppSpacing.screenPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              AppSpacing.gapXs,
              Text(
                _isOnline ? 'Online' : 'Offline',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _isOnline ? AppColors.success : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          Switch(
            value: _isOnline,
            activeThumbColor: AppColors.success,
            onChanged: (val) {
              setState(() {
                _isOnline = val;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildBottomCard() {
    return Container(
      padding: AppSpacing.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatColumn(label: 'TODAY', value: '₱ 450'),
                Container(height: 40, width: 1, color: AppColors.borderLight),
                _StatColumn(label: 'TRIPS', value: '4'),
                Container(height: 40, width: 1, color: AppColors.borderLight),
                _StatColumn(label: 'RATING', value: '4.9'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1),
        ),
        AppSpacing.gapXs,
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
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
            const Icon(Icons.location_on, size: 48, color: AppColors.primary),
            AppSpacing.gapSm,
            Text(
              'Finding jobs near you...',
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

class _OfflineState extends StatelessWidget {
  const _OfflineState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bedtime_outlined,
            size: 64,
            color: AppColors.textSecondaryLight,
          ),
          AppSpacing.gapMd,
          GestureDetector(
            onDoubleTap: () => context.push('/ride/incoming'), // Dev hook
            child: Text(
              'You are offline',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            'Go online to start receiving job requests.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
