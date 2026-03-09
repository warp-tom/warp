import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class ErrandRequestScreen extends StatelessWidget {
  const ErrandRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Pabili / Errand'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLocationInput(context, 'Store Name or Area', Icons.store),
              AppSpacing.gapMd,
              _buildLocationInput(context, 'Delivery Address', Icons.home),
              AppSpacing.gapXl,
              Text('Shopping List', style: Theme.of(context).textTheme.titleMedium),
              AppSpacing.gapMd,
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: const TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'E.g. 1x Jollibee Bucket Meal, 2x Rice, 1x Coke (Max ₱1000)',
                    border: InputBorder.none,
                  ),
                ),
              ),
              AppSpacing.gapXl,
              ElevatedButton(
                onPressed: () {
                  // TODO: Submit Logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Find a Rider'),
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
}
