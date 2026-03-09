import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:warp_core/warp_core.dart';
import '../repositories/trip_repository.dart';
import '../repositories/driver_repository.dart';
import 'auth_provider.dart';

final tripRepositoryProvider = Provider((ref) => TripRepository());
final driverRepositoryProvider = Provider((ref) => DriverRepository());

// Stream for user's trips
final userTripsProvider = StreamProvider<List<Trip>>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState?.session?.user == null) {
    return Stream.value([]);
  }
  return ref.watch(tripRepositoryProvider).watchUserTrips(authState!.session!.user.id);
});

// Stream for active online drivers globally
final activeDriversProvider = StreamProvider<List<DriverLocation>>((ref) {
  return ref.watch(driverRepositoryProvider).watchOnlineDrivers();
});
