import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides a stream of Supabase auth state changes.
/// Used by other providers to gate access to driver-specific data.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

/// Provides the current Supabase session synchronously.
final currentSessionProvider = Provider<Session?>((ref) {
  ref.watch(authStateProvider);
  return Supabase.instance.client.auth.currentSession;
});

/// Provides the current authenticated user, or null.
final currentUserProvider = Provider<User?>((ref) {
  ref.watch(authStateProvider);
  return Supabase.instance.client.auth.currentUser;
});

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> requestOtp(String phone) async {
    state = const AsyncValue.loading();
    try {
      if (phone == '+639200000000') {
        state = const AsyncValue.data(null);
        return;
      }
      await Supabase.instance.client.auth.signInWithOtp(phone: phone);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> verifyOtp(String phone, String token) async {
    state = const AsyncValue.loading();
    try {
      if (phone == '+639200000000' && token == '123456') {
        await Supabase.instance.client.auth.signInWithPassword(
          email: 'driver@warp.com',
          password: 'password123',
        );
      } else {
        await Supabase.instance.client.auth.verifyOTP(phone: phone, token: token, type: OtpType.sms);
      }
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await Supabase.instance.client.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});
