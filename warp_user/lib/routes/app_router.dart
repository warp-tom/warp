import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/home/home_screen.dart';
import '../features/ride/ride_request_screen.dart';
import '../features/ride/driver_matching_screen.dart';
import '../features/ride/active_ride_screen.dart';
import '../features/parcel/parcel_request_screen.dart';
import '../features/errand/errand_request_screen.dart';
import '../features/activity/activity_screen.dart';
import '../features/profile/profile_screen.dart';
import '../ui/shared/main_shell.dart';

// Placeholder Screens for Navigation
class ParcelScreen extends StatelessWidget {
  const ParcelScreen({super.key});
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Parcel Content')));
}

/// Converts a Stream into a Listenable for GoRouter's refreshListenable.
/// This makes GoRouter re-evaluate its redirect whenever auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final supabase = Supabase.instance.client;

  return GoRouter(
    initialLocation: '/splash',
    // This is the key fix: GoRouter will re-run redirect whenever auth state changes
    refreshListenable: GoRouterRefreshStream(supabase.auth.onAuthStateChange),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      // Ride Flow (Outside Main Shell so it takes full screen)
      GoRoute(
        path: '/ride/request',
        builder: (context, state) => const RideRequestScreen(),
      ),
      GoRoute(
        path: '/ride/matching',
        builder: (context, state) => const DriverMatchingScreen(),
      ),
      GoRoute(
        path: '/ride/active',
        builder: (context, state) => const ActiveRideScreen(),
      ),
      // Parcel Flow
      GoRoute(
        path: '/parcel/request',
        builder: (context, state) => const ParcelRequestScreen(),
      ),
      // Errand Flow
      GoRoute(
        path: '/errand/request',
        builder: (context, state) => const ErrandRequestScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/parcel',
            builder: (context, state) => const ParcelScreen(),
          ),
          GoRoute(
            path: '/activity',
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    // Reactive Auth Redirect Logic
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isAuthenticated = session != null;
      final isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/otp';
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null; // Let splash handle its own delay and logic

      if (!isAuthenticated && !isGoingToAuth) {
        return '/login';
      }

      if (isAuthenticated && isGoingToAuth) {
        return '/home'; // If logged in and trying to go to login/otp, send home
      }

      return null;
    },
  );
});
