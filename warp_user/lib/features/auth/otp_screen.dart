import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/spacing.dart';
import '../../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() async {
    final token = _otpController.text.trim();
    if (token.length != 6) return;

    await ref.read(authNotifierProvider.notifier).verifyOtp(
      widget.phoneNumber, 
      token,
    );
    
    // On success, redirect logic in AppRouter will catch the AuthState change 
    // and naturally move the user to /home. We don't push manually here 
    // to maintain a clean navigation stack based on reactive state.
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

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()), // Clean minimal app bar
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your code',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              AppSpacing.gapSm,
              Text(
                'We sent a 6-digit code to\n${widget.phoneNumber}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              AppSpacing.gapXl,
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(letterSpacing: 8.0),
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: '000000',
                  counterText: '', // Hide the 0/6 counter
                  suffixIcon: isLoading 
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                onChanged: (val) {
                  if (val.length == 6) {
                    _handleVerifyOtp(); // Auto submit when 6 digits are typed
                  }
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: isLoading ? null : _handleVerifyOtp,
                child: Text(isLoading ? 'Verifying...' : 'Confirm'),
              ),
              AppSpacing.gapMd,
            ],
          ),
        ),
      ),
    );
  }
}
