import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warp_core/warp_core.dart';
import '../repositories/trip_repository.dart';
import 'auth_provider.dart';

final tripRepositoryProvider = Provider((ref) => TripRepository());

// Stream for driver's accepted/active trips
final driverTripsProvider = StreamProvider<List<Trip>>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState?.session?.user == null) {
    return Stream.value([]);
  }
  return ref.watch(tripRepositoryProvider).watchDriverTrips(authState!.session!.user.id);
});

// Stream for available requested trips looking for drivers
final availableTripsProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(tripRepositoryProvider).watchAvailableTrips();
});
