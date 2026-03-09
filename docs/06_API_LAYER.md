# Warp — API Layer Design

> Supabase API services, RPC functions, edge functions, and realtime subscriptions

---

## 1. API Architecture

```
Flutter App
     │
     ▼
┌──────────────────────────┐
│  Service Layer           │
│  (lib/services/)         │
│  auth_service.dart       │
│  ride_service.dart       │
│  parcel_service.dart     │
│  errand_service.dart     │
│  driver_service.dart     │
│  location_service.dart   │
│  notification_service.dart│
│  payment_service.dart    │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│  Repository Layer        │
│  (lib/repositories/)     │
│  trip_repository.dart    │
│  parcel_repository.dart  │
│  errand_repository.dart  │
│  driver_repository.dart  │
│  user_repository.dart    │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│  Supabase Client         │
│  (lib/services/          │
│   supabase_service.dart) │
└──────────────────────────┘
```

**Rule**: Flutter screens never call Supabase directly. All database operations go through repositories.

---

## 2. Auth API

### `auth_service.dart`

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `signInWithPhone(phone)` | `String` | `void` | Sends OTP via Supabase Auth |
| `verifyOtp(phone, token)` | `String, String` | `AuthResponse` | Verifies OTP, returns session |
| `signOut()` | — | `void` | Clears session |
| `getCurrentUser()` | — | `User?` | Returns current auth user |
| `onAuthStateChange()` | — | `Stream<AuthState>` | Auth state listener |

### Profile creation trigger
After successful OTP verification, upsert into `profiles` table:
```dart
await supabase.from('profiles').upsert({
  'id': user.id,
  'phone': phone,
  'role': 'passenger',
});
```

---

## 3. Ride API

### `trip_repository.dart`

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `createTrip(data)` | `TripRequest` | `Trip` | Inserts into `trips`, status = `requested` |
| `getTrip(tripId)` | `String` | `Trip` | Fetches single trip |
| `getUserTrips(userId)` | `String` | `List<Trip>` | Fetches trip history |
| `updateTripStatus(tripId, status)` | `String, String` | `void` | Updates trip status |
| `cancelTrip(tripId, reason)` | `String, String` | `void` | Sets status to `cancelled` |
| `rateTrip(tripId, rating, review)` | `String, int, String?` | `void` | Inserts into `ratings` |

### Create Trip
```dart
Future<Trip> createTrip(TripRequest request) async {
  final response = await supabase.from('trips').insert({
    'user_id': request.userId,
    'pickup_location': 'POINT(${request.pickupLng} ${request.pickupLat})',
    'destination_location': 'POINT(${request.destLng} ${request.destLat})',
    'pickup_address': request.pickupAddress,
    'destination_address': request.destAddress,
    'vehicle_type': request.vehicleType,
    'status': 'requested',
  }).select().single();
  return Trip.fromJson(response);
}
```

### Trip Realtime Subscription
```dart
supabase
  .channel('trip-${tripId}')
  .onPostgresChanges(
    event: PostgresChangeEvent.update,
    schema: 'public',
    table: 'trips',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'id',
      value: tripId,
    ),
    callback: (payload) {
      final trip = Trip.fromJson(payload.newRecord);
      onTripUpdate(trip);
    },
  )
  .subscribe();
```

---

## 4. Parcel API

### `parcel_repository.dart`

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `createParcelOrder(data)` | `ParcelRequest` | `ParcelOrder` | Inserts into `parcel_orders` |
| `getParcelOrder(orderId)` | `String` | `ParcelOrder` | Fetches single order |
| `getUserParcels(userId)` | `String` | `List<ParcelOrder>` | Order history |
| `updateParcelStatus(orderId, status)` | `String, String` | `void` | Updates status |

---

## 5. Errand API

### `errand_repository.dart`

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `createErrandOrder(data)` | `ErrandRequest` | `ErrandOrder` | Inserts into `errand_orders` |
| `getErrandOrder(orderId)` | `String` | `ErrandOrder` | Fetches single order |
| `getUserErrands(userId)` | `String` | `List<ErrandOrder>` | Order history |
| `updateErrandStatus(orderId, status)` | `String, String` | `void` | Updates status |
| `uploadReceipt(orderId, file)` | `String, File` | `String` | Uploads to storage, returns URL |
| `setItemCost(orderId, cost)` | `String, double` | `void` | Driver sets actual item cost |

---

## 6. Driver API

### `driver_repository.dart`

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
| `getDriverProfile(driverId)` | `String` | `Driver` | Fetches driver details |
| `updateOnlineStatus(driverId, isOnline)` | `String, bool` | `void` | Toggle online/offline |
| `updateLocation(driverId, lat, lng, heading, speed)` | mixed | `void` | Upserts `driver_locations` |
| `acceptTrip(tripId, driverId)` | `String, String` | `void` | Sets driver_id, status = `accepted` |
| `getDriverTrips(driverId)` | `String` | `List<Trip>` | Trip history |
| `getDriverEarnings(driverId, period)` | `String, String` | `EarningsSummary` | Aggregated earnings |

### Location Updates
```dart
Geolocator.getPositionStream(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 15, // meters
  ),
).listen((position) async {
  await supabase.from('driver_locations').upsert({
    'driver_id': driverId,
    'location': 'POINT(${position.longitude} ${position.latitude})',
    'heading': position.heading,
    'speed_kmh': position.speed * 3.6,
    'is_online': true,
    'last_updated': DateTime.now().toIso8601String(),
  });
});
```

### Driver Location Subscription (User App)
```dart
supabase
  .channel('driver-location-${driverId}')
  .onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'driver_locations',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'driver_id',
      value: driverId,
    ),
    callback: (payload) {
      updateDriverMarker(payload.newRecord);
    },
  )
  .subscribe();
```

---

## 7. RPC Functions (Server-Side)

### `find_nearby_drivers`
```sql
CREATE OR REPLACE FUNCTION find_nearby_drivers(
  p_lat double precision,
  p_lon double precision,
  p_radius_km double precision DEFAULT 3.0,
  p_vehicle_type text DEFAULT NULL
)
RETURNS TABLE (
  driver_id uuid,
  full_name text,
  avatar_url text,
  rating numeric,
  vehicle_type text,
  plate_number text,
  distance_km double precision,
  lat double precision,
  lon double precision
)
LANGUAGE sql STABLE
AS $$
  SELECT
    dl.driver_id,
    d.full_name,
    d.avatar_url,
    d.rating,
    v.vehicle_type,
    v.plate_number,
    ST_Distance(dl.location, ST_MakePoint(p_lon, p_lat)::geography) / 1000 AS distance_km,
    ST_Y(dl.location::geometry) AS lat,
    ST_X(dl.location::geometry) AS lon
  FROM driver_locations dl
  JOIN drivers d ON d.id = dl.driver_id
  JOIN vehicles v ON v.driver_id = d.id
  WHERE dl.is_online = true
    AND d.verification_status = 'approved'
    AND d.is_active = true
    AND ST_DWithin(dl.location, ST_MakePoint(p_lon, p_lat)::geography, p_radius_km * 1000)
    AND (p_vehicle_type IS NULL OR v.vehicle_type = p_vehicle_type)
  ORDER BY distance_km ASC
  LIMIT 10;
$$;
```

### `get_fare_estimate`
```sql
CREATE OR REPLACE FUNCTION get_fare_estimate(
  p_distance_km numeric,
  p_duration_min numeric,
  p_vehicle_type text
)
RETURNS TABLE (
  base_fare numeric,
  distance_fare numeric,
  time_fare numeric,
  platform_fee numeric,
  total_fare numeric,
  surge_multiplier numeric
)
LANGUAGE sql STABLE
AS $$
  SELECT
    fc.base_fare,
    ROUND(p_distance_km * fc.per_km_rate, 2) AS distance_fare,
    ROUND(p_duration_min * fc.per_minute_rate, 2) AS time_fare,
    ROUND(
      (fc.base_fare + p_distance_km * fc.per_km_rate + p_duration_min * fc.per_minute_rate)
      * fc.platform_fee_pct / 100, 2
    ) AS platform_fee,
    GREATEST(
      ROUND(
        (fc.base_fare + p_distance_km * fc.per_km_rate + p_duration_min * fc.per_minute_rate)
        * fc.surge_multiplier, 0
      ),
      fc.minimum_fare
    ) AS total_fare,
    fc.surge_multiplier
  FROM fare_config fc
  WHERE fc.vehicle_type = p_vehicle_type
    AND fc.is_active = true
  LIMIT 1;
$$;
```

### Calling RPCs from Flutter
```dart
final drivers = await supabase.rpc('find_nearby_drivers', params: {
  'p_lat': currentLat,
  'p_lon': currentLng,
  'p_radius_km': 3.0,
  'p_vehicle_type': 'tricycle',
});

final fare = await supabase.rpc('get_fare_estimate', params: {
  'p_distance_km': 4.2,
  'p_duration_min': 12,
  'p_vehicle_type': 'tricycle',
});
```

---

## 8. Edge Functions

### `dispatch-ride`
**Trigger**: HTTP POST from Flutter app after trip creation.

**Logic**:
1. Query `find_nearby_drivers` for the trip's pickup location
2. Send FCM push notification to top 5 drivers
3. Set 10-second timeout per driver
4. If no driver accepts, expand radius (3km → 6km → 10km)
5. When driver accepts: update `trips.driver_id` and `trips.status = 'accepted'`

### `send-notification`
**Trigger**: HTTP POST from other edge functions or admin.

**Payload**:
```json
{
  "user_id": "uuid",
  "title": "Driver is arriving",
  "body": "Your driver will arrive in 3 minutes",
  "data": { "trip_id": "uuid", "type": "trip_update" }
}
```

**Logic**:
1. Fetch FCM token from `profiles` table
2. Send to Firebase Cloud Messaging API
3. Insert into `notifications` table

---

## 9. Storage API

### Upload Avatar
```dart
final path = 'avatars/${userId}.jpg';
await supabase.storage.from('avatars').upload(path, file);
final url = supabase.storage.from('avatars').getPublicUrl(path);
```

### Upload Receipt (Driver)
```dart
final path = 'receipts/${orderId}/${DateTime.now().toIso8601String()}.jpg';
await supabase.storage.from('receipts').upload(path, file);
```

---

## 10. Error Handling

### Standard Error Response
```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
}
```

### Repository Pattern
```dart
Future<Trip> getTrip(String tripId) async {
  try {
    final response = await supabase
      .from('trips')
      .select()
      .eq('id', tripId)
      .single();
    return Trip.fromJson(response);
  } on PostgrestException catch (e) {
    throw ApiException(e.message, statusCode: e.code);
  }
}
```
