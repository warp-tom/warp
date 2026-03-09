class Trip {
  final String id;
  final String userId;
  final String? driverId;
  final String? vehicleId;
  final String pickupAddress;
  final String destinationAddress;
  final String vehicleType;
  final String status;
  final double fare;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.userId,
    this.driverId,
    this.vehicleId,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.vehicleType,
    required this.status,
    required this.fare,
    required this.createdAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      driverId: json['driver_id'],
      vehicleId: json['vehicle_id'],
      pickupAddress: json['pickup_address'] ?? '',
      destinationAddress: json['destination_address'] ?? '',
      vehicleType: json['vehicle_type'] ?? 'tricycle',
      status: json['status'],
      fare: (json['fare'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
