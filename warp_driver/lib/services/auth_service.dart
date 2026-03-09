import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream of auth state changes (logged in, logged out, tokens refreshed)
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // 1. Send OTP to phone number
  Future<void> signInWithOtp(String phoneNumber) async {
    try {
      await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );
    } on AuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error sending OTP.');
    }
  }

  // 2. Verify OTP
  Future<AuthResponse> verifyOtp(String phoneNumber, String token) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.sms,
        token: token,
        phone: phoneNumber,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception('Verification failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error verifying OTP.');
    }
  }

  // 3. Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
