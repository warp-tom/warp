import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/spacing.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRequestOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    // Optional: Add phone formatting/validation here

    await ref.read(authNotifierProvider.notifier).requestOtp(phone);
    
    // If successful, navigate to OTP screen
    if (!ref.read(authNotifierProvider).hasError && mounted) {
      // Pass the phone number to the OTP screen via GoRouter extra
      context.push('/otp', extra: phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth errors to show snackbars
    ref.listen<AsyncValue<void>>(
      authNotifierProvider,
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString(), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
            );
          },
        );
      },
    );

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.gapXl,
              Text(
                'Enter your number',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              AppSpacing.gapSm,
              Text(
                'We\'ll send a code to verify your account.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              AppSpacing.gapXl,
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: Theme.of(context).textTheme.titleLarge,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: '+63 9XX XXX XXXX',
                  prefixIcon: const Icon(Icons.phone_android),
                  // Slight tweak to show progress
                  suffixIcon: isLoading 
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: isLoading ? null : _handleRequestOtp,
                child: Text(isLoading ? 'Sending...' : 'Continue'),
              ),
              AppSpacing.gapMd,
            ],
          ),
        ),
      ),
    );
  }
}
