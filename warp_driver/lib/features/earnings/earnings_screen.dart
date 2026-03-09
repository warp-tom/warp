import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    AppSpacing.gapSm,
                    const Text('₱0.00', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                    AppSpacing.gapMd,
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                      child: const Text('Cash Out'),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapXl,
              Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
              AppSpacing.gapMd,
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text('No transactions yet', style: TextStyle(color: AppColors.textSecondaryLight)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
