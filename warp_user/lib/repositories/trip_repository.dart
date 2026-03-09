import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warp_core/warp_core.dart';

class TripRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream active trip for passenger
  Stream<List<Trip>> watchUserTrips(String userId) {
    return _supabase
        .from('trips')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Trip.fromJson(json)).toList());
  }

  // Stream active trip for driver
  Stream<List<Trip>> watchDriverTrips(String driverId) {
    return _supabase
        .from('trips')
        .stream(primaryKey: ['id'])
        .eq('driver_id', driverId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Trip.fromJson(json)).toList());
  }

  // Create a trip
  Future<Trip> createTrip({
    required String userId,
    required double pickupLng,
    required double pickupLat,
    required double destLng,
    required double destLat,
    required String pickupAddress,
    required String destAddress,
    required String vehicleType,
  }) async {
    final response = await _supabase.from('trips').insert({
      'user_id': userId,
      'pickup_location': 'POINT($pickupLng $pickupLat)',
      'destination_location': 'POINT($destLng $destLat)',
      'pickup_address': pickupAddress,
      'destination_address': destAddress,
      'vehicle_type': vehicleType,
      'status': 'requested',
    }).select().single();
    
    return Trip.fromJson(response);
  }
}
