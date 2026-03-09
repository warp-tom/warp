# Warp — Flutter Architecture

> Project structure, state management, routing, models, and development patterns

---

## 1. Project Structure

```
lib/
│
├── main.dart                     # App entry point
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart        # ThemeData (M3)
│   │   ├── colors.dart           # Color constants
│   │   ├── typography.dart       # TextTheme + Inter font
│   │   └── spacing.dart          # Spacing constants (4px grid)
│   │
│   ├── constants/
│   │   ├── app_constants.dart    # API keys, URLs, config
│   │   └── enums.dart            # TripStatus, VehicleType, etc.
│   │
│   └── utils/
│       ├── helpers.dart          # Formatting, validation
│       ├── extensions.dart       # Dart extension methods
│       └── logger.dart           # Debug logging
│
├── services/
│   ├── supabase_service.dart     # Supabase client singleton
│   ├── auth_service.dart         # Auth methods
│   ├── location_service.dart     # GPS + permissions
│   ├── notification_service.dart # FCM setup + handling
│   └── storage_service.dart      # File upload/download
│
├── models/
│   ├── user_model.dart           # Profile data
│   ├── driver_model.dart         # Driver profile
│   ├── vehicle_model.dart        # Vehicle data
│   ├── trip_model.dart           # Trip data
│   ├── parcel_model.dart         # Parcel order
│   ├── errand_model.dart         # Errand order
│   ├── rating_model.dart         # Rating data
│   ├── notification_model.dart   # Notification data
│   ├── saved_place_model.dart    # Saved locations
│   └── fare_estimate_model.dart  # Fare calculation result
│
├── repositories/
│   ├── user_repository.dart      # Profile CRUD
│   ├── trip_repository.dart      # Trip operations
│   ├── parcel_repository.dart    # Parcel operations
│   ├── errand_repository.dart    # Errand operations
│   ├── driver_repository.dart    # Driver operations
│   └── payment_repository.dart   # Payment recording
│
├── providers/
│   ├── auth_provider.dart        # Auth state
│   ├── user_provider.dart        # Current user profile
│   ├── trip_provider.dart        # Active trip state
│   ├── location_provider.dart    # Current GPS position
│   ├── driver_provider.dart      # Nearby drivers
│   └── notification_provider.dart# Notifications count
│
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   │
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   │
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── otp_screen.dart
│   │
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── greeting_header.dart
│   │       ├── search_bar.dart
│   │       ├── service_cards.dart
│   │       └── map_preview.dart
│   │
│   ├── ride/
│   │   ├── ride_request_screen.dart
│   │   ├── driver_matching_screen.dart
│   │   ├── active_ride_screen.dart
│   │   ├── trip_complete_screen.dart
│   │   └── widgets/
│   │       ├── vehicle_selector.dart
│   │       ├── fare_estimate_card.dart
│   │       └── driver_info_card.dart
│   │
│   ├── parcel/
│   │   ├── parcel_request_screen.dart
│   │   ├── parcel_tracking_screen.dart
│   │   └── widgets/
│   │       └── parcel_form.dart
│   │
│   ├── errand/
│   │   ├── errand_request_screen.dart
│   │   ├── errand_tracking_screen.dart
│   │   └── widgets/
│   │       ├── shopping_list_editor.dart
│   │       └── receipt_viewer.dart
│   │
│   ├── activity/
│   │   ├── activity_screen.dart
│   │   └── widgets/
│   │       └── activity_card.dart
│   │
│   └── profile/
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       ├── saved_places_screen.dart
│       └── payment_methods_screen.dart
│
├── ui/
│   ├── components/
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   └── secondary_button.dart
│   │   │
│   │   ├── cards/
│   │   │   ├── service_card.dart
│   │   │   ├── driver_card.dart
│   │   │   └── activity_card.dart
│   │   │
│   │   ├── inputs/
│   │   │   ├── search_field.dart
│   │   │   └── text_input.dart
│   │   │
│   │   ├── map/
│   │   │   ├── map_view.dart
│   │   │   └── driver_marker.dart
│   │   │
│   │   └── bottom_sheets/
│   │       ├── vehicle_selector_sheet.dart
│   │       └── ride_confirm_sheet.dart
│   │
│   └── shared/
│       ├── loading_overlay.dart
│       ├── empty_state.dart
│       └── error_view.dart
│
└── routes/
    └── app_router.dart
```

---

## 2. App Entry Point

### `main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const ProviderScope(child: WarpApp()));
}

class WarpApp extends ConsumerWidget {
  const WarpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Warp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
```

---

## 3. State Management — Riverpod

### Provider Types Used

| Type | Usage |
|------|-------|
| `StateProvider` | Simple mutable state (selected vehicle) |
| `FutureProvider` | Async data fetching (user profile) |
| `StreamProvider` | Realtime data (trip status, driver location) |
| `StateNotifierProvider` | Complex state logic (trip flow) |

### Key Providers

```dart
// Auth state
final authProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

// Current user profile
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;
  return ref.read(userRepositoryProvider).getProfile(userId);
});

// Active trip
final activeTripProvider = StreamProvider<Trip?>((ref) {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return const Stream.empty();
  return ref.read(tripRepositoryProvider).watchActiveTrip(userId);
});

// Nearby drivers
final nearbyDriversProvider = FutureProvider.family<List<Driver>, LatLng>(
  (ref, location) async {
    return ref.read(driverRepositoryProvider).findNearby(
      lat: location.latitude,
      lng: location.longitude,
    );
  },
);

// Selected vehicle type
final selectedVehicleProvider = StateProvider<String>((ref) => 'tricycle');
```

---

## 4. Navigation — GoRouter

### `app_router.dart`
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash',      builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding',   builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login',        builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/otp',          builder: (_, __) => const OtpScreen()),

      // Main app with bottom navigation
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home',     builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/parcel',   builder: (_, __) => const ParcelRequestScreen()),
          GoRoute(path: '/activity', builder: (_, __) => const ActivityScreen()),
          GoRoute(path: '/profile',  builder: (_, __) => const ProfileScreen()),
        ],
      ),

      // Ride flow
      GoRoute(path: '/ride',         builder: (_, __) => const RideRequestScreen()),
      GoRoute(path: '/ride/matching', builder: (_, __) => const DriverMatchingScreen()),
      GoRoute(path: '/ride/active',  builder: (_, __) => const ActiveRideScreen()),
      GoRoute(path: '/ride/complete', builder: (_, __) => const TripCompleteScreen()),

      // Errand flow
      GoRoute(path: '/errand',       builder: (_, __) => const ErrandRequestScreen()),

      // Profile sub-routes
      GoRoute(path: '/profile/edit', builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: '/profile/places', builder: (_, __) => const SavedPlacesScreen()),
    ],

    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuth = session != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
                          state.matchedLocation == '/otp';

      if (!isAuth && !isAuthRoute && state.matchedLocation != '/splash'
          && state.matchedLocation != '/onboarding') {
        return '/login';
      }
      return null;
    },
  );
});
```

---

## 5. Model Pattern

### Example: `trip_model.dart`
```dart
class Trip {
  final String id;
  final String userId;
  final String? driverId;
  final double pickupLat;
  final double pickupLng;
  final double destLat;
  final double destLng;
  final String pickupAddress;
  final String destAddress;
  final String vehicleType;
  final String status;
  final double? fare;
  final String? paymentMethod;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.userId,
    this.driverId,
    required this.pickupLat,
    required this.pickupLng,
    required this.destLat,
    required this.destLng,
    required this.pickupAddress,
    required this.destAddress,
    required this.vehicleType,
    required this.status,
    this.fare,
    this.paymentMethod,
    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      driverId: json['driver_id'],
      pickupLat: json['pickup_lat'],
      pickupLng: json['pickup_lng'],
      destLat: json['dest_lat'],
      destLng: json['dest_lng'],
      pickupAddress: json['pickup_address'] ?? '',
      destAddress: json['destination_address'] ?? '',
      vehicleType: json['vehicle_type'],
      status: json['status'],
      fare: json['fare']?.toDouble(),
      paymentMethod: json['payment_method'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'driver_id': driverId,
    'pickup_lat': pickupLat,
    'pickup_lng': pickupLng,
    'dest_lat': destLat,
    'dest_lng': destLng,
    'pickup_address': pickupAddress,
    'destination_address': destAddress,
    'vehicle_type': vehicleType,
    'status': status,
    'fare': fare,
    'payment_method': paymentMethod,
  };
}
```

---

## 6. Development Patterns

### Repository Pattern
- All Supabase calls go through repository classes
- Repositories are accessed via Riverpod providers
- Screens never import `supabase_flutter` directly

### Error Handling
```dart
// All repository methods wrap errors:
try {
  final data = await supabase.from('trips').select().single();
  return Trip.fromJson(data);
} on PostgrestException catch (e) {
  throw AppException('Failed to load trip: ${e.message}');
}
```

### Code Organization Rules
1. **One widget per file** for screen-level widgets
2. **Feature-first** folder structure
3. **Shared components** in `ui/components/`
4. **No business logic in widgets** — use providers
5. **Constants over magic numbers** — use `spacing.dart`, `colors.dart`

---

## 7. pubspec.yaml (Core Dependencies)

```yaml
name: warp
description: Provincial Mobility & Delivery Platform
publish_to: none
version: 1.0.0+1

environment:
  sdk: ^3.4.0

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6

  # State Management
  flutter_riverpod: ^2.5.1

  # Navigation
  go_router: ^14.0.0

  # Backend
  supabase_flutter: ^2.5.0

  # Maps
  google_maps_flutter: ^2.6.0
  geolocator: ^11.0.0
  geocoding: ^3.0.0

  # Notifications
  firebase_messaging: ^14.9.0
  firebase_core: ^2.27.0

  # Animations
  flutter_animate: ^4.5.0
  lottie: ^3.1.0

  # UI
  cached_network_image: ^3.3.1
  google_fonts: ^6.1.0
  shimmer: ^3.0.0

  # Utilities
  intl: ^0.19.0
  uuid: ^4.4.0
  image_picker: ^1.0.7
  url_launcher: ^6.2.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```
