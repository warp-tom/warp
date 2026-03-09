import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class ParcelRequestScreen extends StatelessWidget {
  const ParcelRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Send a Parcel'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLocationInput(context, 'Pickup Address', Icons.my_location),
              AppSpacing.gapMd,
              _buildLocationInput(context, 'Delivery Address', Icons.location_on),
              AppSpacing.gapXl,
              Text('Package Details', style: Theme.of(context).textTheme.titleMedium),
              AppSpacing.gapMd,
              _buildPackageSizeSelector(context),
              AppSpacing.gapXl,
              ElevatedButton(
                onPressed: () {
                  // TODO: Submit logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Find a Courier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput(BuildContext context, String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.primary),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPackageSizeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSizeOption('Small', 'Max 5kg', true)),
        AppSpacing.gapMd,
        Expanded(child: _buildSizeOption('Medium', 'Max 10kg', false)),
        AppSpacing.gapMd,
        Expanded(child: _buildSizeOption('Large', 'Max 20kg', false)),
      ],
    );
  }

  Widget _buildSizeOption(String title, String subtitle, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }
}
