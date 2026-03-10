class DriverLocation {
  final String driverId;
  final double latitude;
  final double longitude;
  final bool isOnline;

  DriverLocation({
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.isOnline,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      driverId: json['driver_id'] as String? ?? '',
      latitude: json['lat'] != null ? (json['lat'] as num).toDouble() : 0.0,
      longitude: json['lon'] != null ? (json['lon'] as num).toDouble() : 0.0,
      isOnline: json['is_online'] ?? false,
    );
  }

  // Also handling the case where Supabase returns PostGIS WKT instead of custom RPC JSON
  factory DriverLocation.fromTableJson(Map<String, dynamic> json) {
    double lat = 0.0;
    double lon = 0.0;
    final String? locStr = json['location'];
    if (locStr != null && locStr.startsWith('POINT(')) {
      final parts = locStr.replaceAll('POINT(', '').replaceAll(')', '').split(' ');
      if (parts.length == 2) {
        lon = double.tryParse(parts[0]) ?? 0.0;
        lat = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    
    return DriverLocation(
      driverId: json['driver_id'] as String? ?? '',
      latitude: lat,
      longitude: lon,
      isOnline: json['is_online'] ?? false,
    );
  }
}
