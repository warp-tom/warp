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
  // Pre-filled test phone number for development
  final _phoneController = TextEditingController(text: '+639200000000');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      await ref.read(authNotifierProvider.notifier).requestOtp(phone);
      if (mounted) {
        context.push('/otp', extra: phone);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.gapXl,
              Text(
                'Driver Portal',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              AppSpacing.gapSm,
              Text(
                'Enter your registered phone number.',
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
                onPressed: isLoading ? null : _handleLogin,
                child: Text(isLoading ? 'Sending OTP...' : 'Continue to Login'),
              ),
              AppSpacing.gapMd,
            ],
          ),
        ),
      ),
    );
  }
}
