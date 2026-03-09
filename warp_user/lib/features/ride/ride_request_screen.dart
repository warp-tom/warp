import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final _pickupController = TextEditingController(text: 'Current Location');
  final _destinationController = TextEditingController();
  String _selectedVehicle = 'tricycle'; // Optional feature toggle
  
  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _handleConfirmRide() {
    if (_destinationController.text.isEmpty) return;
    // Scaffold UI logic: navigate to matching screen
    context.push('/ride/matching');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Request Ride'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildLocationInputs(),
            const Expanded(child: _MapPlaceholder()),
            _buildVehicleSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInputs() {
    return Container(
      padding: AppSpacing.screenPadding,
      color: AppColors.surfaceLight,
      child: Column(
        children: [
          _LocationField(
            icon: Icons.my_location_rounded,
            controller: _pickupController,
            hint: 'Pickup location',
            color: AppColors.primary,
          ),
          AppSpacing.gapSm,
          _LocationField(
            icon: Icons.location_on_rounded,
            controller: _destinationController,
            hint: 'Where to?',
            color: AppColors.error,
            autofocus: true,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSelector() {
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _VehicleOption(
                  title: 'Tricycle',
                  price: '₱ 65',
                  eta: '3 min',
                  icon: Icons.electric_rickshaw,
                  isSelected: _selectedVehicle == 'tricycle',
                  onTap: () => setState(() => _selectedVehicle = 'tricycle'),
                ),
              ),
              AppSpacing.gapMd,
              Expanded(
                child: _VehicleOption(
                  title: 'Scooter',
                  price: '₱ 45',
                  eta: '5 min',
                  icon: Icons.two_wheeler,
                  isSelected: _selectedVehicle == 'scooter',
                  onTap: () => setState(() => _selectedVehicle = 'scooter'),
                ),
              ),
            ],
          ),
          AppSpacing.gapLg,
          ElevatedButton(
            onPressed: _handleConfirmRide,
            child: const Text('Confirm Ride'),
          ),
          AppSpacing.gapSm,
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final Color color;
  final bool autofocus;

  const _LocationField({
    required this.icon,
    required this.controller,
    required this.hint,
    required this.color,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: color, size: 20),
        // Overrides for a cleaner minimal look in this specific context
        fillColor: AppColors.backgroundLight,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _VehicleOption extends StatelessWidget {
  final String title;
  final String price;
  final String eta;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleOption({
    required this.title,
    required this.price,
    required this.eta,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: isSelected ? AppColors.primary : AppColors.textSecondaryLight),
            AppSpacing.gapMd,
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimaryLight,
              ),
            ),
            AppSpacing.gapXs,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: Theme.of(context).textTheme.titleMedium),
                Text(eta, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
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
            const Icon(Icons.route_outlined, size: 48, color: AppColors.primary),
            AppSpacing.gapSm,
            Text(
              'Route Map Loading...',
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
