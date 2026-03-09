import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warp_core/warp_core.dart';

enum TripStatus { requested, accepted, inProgress, completed, cancelled }

class TripRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream active trip for driver
  Stream<List<Trip>> watchDriverTrips(String driverId) {
    return _supabase
        .from('trips')
        .stream(primaryKey: ['id'])
        .eq('driver_id', driverId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Trip.fromJson(json)).toList());
  }

  // Stream incoming requested trips locally (simplified for MVP before RPC matching full sync)
  Stream<List<Trip>> watchAvailableTrips() {
     return _supabase
        .from('trips')
        .stream(primaryKey: ['id'])
        .eq('status', 'requested')
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Trip.fromJson(json)).toList());
  }

  // Update trip status
  Future<bool> updateTripStatus(String tripId, TripStatus status) async {
    final response = await _supabase
        .from('trips')
        .update({'status': status.name})
        .eq('id', tripId)
        .select();
    return response.isNotEmpty;
  }
  
  // Accept trip
  Future<bool> acceptTrip(String tripId, String driverId, String vehicleId) async {
     final response = await _supabase.from('trips').update({
       'status': 'accepted', 
       'driver_id': driverId, 
       'vehicle_id': vehicleId
     }).eq('id', tripId).eq('status', 'requested').select();
     return response.isNotEmpty;
  }
}
