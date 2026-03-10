import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/home/home_screen.dart';
import '../features/ride/incoming_job_screen.dart';
import '../features/ride/active_ride_driver_screen.dart';
import '../features/jobs/jobs_screen.dart';
import '../features/earnings/earnings_screen.dart';
import '../features/profile/profile_screen.dart';
import '../ui/shared/main_shell.dart';
import '../core/router/go_router_refresh_stream.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  // Listen to Supabase's auth state stream so GoRouter re-evaluates redirect
  // whenever the user signs in or out.
  final refreshListenable = GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  );

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
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
      // Job Request & Active Ride Execution Flows
      GoRoute(
        path: '/ride/incoming',
        builder: (context, state) => const IncomingJobScreen(),
      ),
      GoRoute(
        path: '/ride/active_driver',
        builder: (context, state) => const ActiveRideDriverScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DriverMainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/jobs',
            builder: (context, state) => const JobsScreen(),
          ),
          GoRoute(
            path: '/earnings',
            builder: (context, state) => const EarningsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // Use Supabase's session directly — always fresh, no provider caching issue.
      final isAuthenticated = Supabase.instance.client.auth.currentSession != null;
      final location = state.matchedLocation;

      final isGoingToAuth = location == '/login' || location == '/otp';
      final isSplash = location == '/splash';

      if (isSplash) return null;

      if (!isAuthenticated && !isGoingToAuth) {
        return '/login';
      }

      if (isAuthenticated && isGoingToAuth) {
        return '/home';
      }

      return null;
    },
  );
});
