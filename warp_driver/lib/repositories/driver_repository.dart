import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/driver_location.dart';

class DriverRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<DriverLocation>> watchOnlineDrivers() {
    return _supabase
        .from('driver_locations')
        .stream(primaryKey: ['driver_id'])
        .eq('is_online', true)
        .map((data) => data.map((json) => DriverLocation.fromTableJson(json)).toList());
  }

  Future<void> updateLocation(String driverId, double lat, double lng, double heading, double speed) async {
    await _supabase.from('driver_locations').upsert({
      'driver_id': driverId,
      'location': 'POINT($lng $lat)',
      'heading': heading,
      'speed_kmh': speed,
      'is_online': true,
      'last_updated': DateTime.now().toIso8601String(),
    });
  }
}
