# Warp — Database Schema

> Production-ready Supabase (PostgreSQL + PostGIS) schema

---

## 1. Extensions

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

---

## 2. Tables

### 2.1 `profiles`
User profiles linked to Supabase Auth.

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, references `auth.users(id)` on delete cascade |
| `phone` | `text` | unique, not null |
| `role` | `text` | `'passenger'` / `'driver'` / `'admin'`, default `'passenger'` |
| `full_name` | `text` | |
| `email` | `text` | |
| `address` | `text` | |
| `avatar_url` | `text` | |
| `is_verified` | `boolean` | default `false` |
| `default_payment` | `text` | default `'cash'` |
| `fcm_token` | `text` | Firebase Cloud Messaging token |
| `created_at` | `timestamptz` | default `now()` |
| `updated_at` | `timestamptz` | default `now()` |

---

### 2.2 `drivers`
Extended driver profile.

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, references `auth.users(id)` |
| `phone` | `text` | |
| `full_name` | `text` | |
| `avatar_url` | `text` | |
| `license_number` | `text` | |
| `license_expiry` | `date` | |
| `verification_status` | `text` | `'pending'`/`'approved'`/`'rejected'`, default `'pending'` |
| `is_active` | `boolean` | default `false` |
| `rating` | `numeric(3,2)` | default `5.00` |
| `total_trips` | `integer` | default `0` |
| `total_earnings` | `numeric(12,2)` | default `0` |
| `balance` | `numeric(12,2)` | default `0` |
| `last_online_at` | `timestamptz` | |
| `created_at` | `timestamptz` | default `now()` |
| `updated_at` | `timestamptz` | default `now()` |

---

### 2.3 `vehicles`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `driver_id` | `uuid` | FK → `drivers(id)` on delete cascade |
| `vehicle_type` | `text` | `'tricycle'`/`'scooter'`/`'motorcycle'` |
| `plate_number` | `text` | |
| `body_number` | `text` | |
| `model` | `text` | |
| `color` | `text` | |
| `is_verified` | `boolean` | default `false` |

---

### 2.4 `driver_locations`
Real-time GPS positions — one row per driver, upserted frequently.

| Column | Type | Constraints |
|--------|------|------------|
| `driver_id` | `uuid` | PK, FK → `drivers(id)` on delete cascade |
| `location` | `geography(Point, 4326)` | PostGIS point |
| `heading` | `double precision` | Compass bearing |
| `speed_kmh` | `double precision` | |
| `is_online` | `boolean` | default `false` |
| `last_updated` | `timestamptz` | default `now()` |

**Index**: `GIST(location)` for spatial queries.

---

### 2.5 `trips`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `user_id` | `uuid` | FK → `profiles(id)` |
| `driver_id` | `uuid` | FK → `drivers(id)`, nullable |
| `vehicle_id` | `uuid` | FK → `vehicles(id)`, nullable |
| `pickup_location` | `geography(Point, 4326)` | |
| `destination_location` | `geography(Point, 4326)` | |
| `pickup_address` | `text` | |
| `destination_address` | `text` | |
| `vehicle_type` | `text` | |
| `status` | `text` | see status enum below |
| `fare` | `numeric(10,2)` | |
| `distance_km` | `numeric(8,2)` | |
| `duration_min` | `numeric(8,2)` | |
| `payment_method` | `text` | `'cash'`/`'gcash'` |
| `payment_status` | `text` | `'pending'`/`'paid'` |
| `cancelled_by` | `text` | `'user'`/`'driver'`/`'system'`, nullable |
| `cancellation_reason` | `text` | nullable |
| `started_at` | `timestamptz` | |
| `completed_at` | `timestamptz` | |
| `created_at` | `timestamptz` | default `now()` |

**Trip Status Values**: `requested` → `accepted` → `arriving` → `arrived` → `ongoing` → `completed` | `cancelled`

---

### 2.6 `parcel_orders`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `sender_id` | `uuid` | FK → `profiles(id)` |
| `driver_id` | `uuid` | FK → `drivers(id)`, nullable |
| `receiver_name` | `text` | |
| `receiver_phone` | `text` | |
| `pickup_location` | `geography(Point, 4326)` | |
| `delivery_location` | `geography(Point, 4326)` | |
| `pickup_address` | `text` | |
| `delivery_address` | `text` | |
| `parcel_type` | `text` | `'documents'`/`'box'`/`'food'`/`'other'` |
| `description` | `text` | |
| `status` | `text` | `'pending'`/`'accepted'`/`'picked_up'`/`'in_transit'`/`'delivered'`/`'cancelled'` |
| `price` | `numeric(10,2)` | |
| `payment_method` | `text` | |
| `payment_status` | `text` | default `'pending'` |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.7 `errand_orders`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `user_id` | `uuid` | FK → `profiles(id)` |
| `driver_id` | `uuid` | FK → `drivers(id)`, nullable |
| `store_name` | `text` | |
| `item_list` | `jsonb` | `[{"name":"rice","qty":1,"notes":""}]` |
| `delivery_address` | `text` | |
| `delivery_location` | `geography(Point, 4326)` | |
| `receipt_url` | `text` | Storage URL, nullable |
| `item_cost` | `numeric(10,2)` | nullable (filled by driver) |
| `delivery_fee` | `numeric(10,2)` | |
| `status` | `text` | `'pending'`/`'accepted'`/`'shopping'`/`'purchased'`/`'delivering'`/`'delivered'`/`'cancelled'` |
| `payment_method` | `text` | |
| `payment_status` | `text` | default `'pending'` |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.8 `payments`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `user_id` | `uuid` | FK → `profiles(id)` |
| `order_type` | `text` | `'trip'`/`'parcel'`/`'errand'` |
| `order_id` | `uuid` | References respective order table |
| `method` | `text` | `'cash'`/`'gcash'` |
| `amount` | `numeric(10,2)` | |
| `status` | `text` | `'pending'`/`'paid'`/`'failed'` |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.9 `ratings`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `user_id` | `uuid` | FK → `profiles(id)` |
| `driver_id` | `uuid` | FK → `drivers(id)` |
| `trip_id` | `uuid` | |
| `order_type` | `text` | `'trip'`/`'parcel'`/`'errand'` |
| `rating` | `integer` | CHECK (1–5) |
| `review` | `text` | nullable |
| `tags` | `text[]` | e.g. `{'friendly','clean_vehicle'}` |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.10 `notifications`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `user_id` | `uuid` | FK → `profiles(id)` |
| `title` | `text` | |
| `message` | `text` | |
| `type` | `text` | `'ride'`/`'parcel'`/`'errand'`/`'promo'`/`'system'` |
| `read` | `boolean` | default `false` |
| `data` | `jsonb` | Optional payload (order ID, deep link, etc.) |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.11 `chat_messages`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `trip_id` | `uuid` | FK → `trips(id)` |
| `sender_id` | `uuid` | FK → `profiles(id)` |
| `message` | `text` | |
| `is_read` | `boolean` | default `false` |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.12 `saved_places`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `user_id` | `uuid` | FK → `profiles(id)` |
| `label` | `text` | e.g. "Home", "Work", "Market" |
| `address` | `text` | |
| `latitude` | `double precision` | |
| `longitude` | `double precision` | |
| `icon` | `text` | default `'location'` |
| `is_favorite` | `boolean` | default `false` |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.13 `driver_documents`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `driver_id` | `uuid` | FK → `drivers(id)` |
| `document_type` | `text` | `'license'`/`'registration'`/`'permit'`/`'selfie'` |
| `document_url` | `text` | Storage URL |
| `verification_status` | `text` | `'pending'`/`'approved'`/`'rejected'` |
| `rejection_reason` | `text` | nullable |
| `expiry_date` | `date` | nullable |
| `created_at` | `timestamptz` | default `now()` |

---

### 2.14 `fare_config`

| Column | Type | Constraints |
|--------|------|------------|
| `id` | `uuid` | PK, default `gen_random_uuid()` |
| `vehicle_type` | `text` | unique |
| `base_fare` | `numeric(8,2)` | |
| `per_km_rate` | `numeric(8,2)` | |
| `per_minute_rate` | `numeric(8,2)` | |
| `minimum_fare` | `numeric(8,2)` | |
| `platform_fee_pct` | `numeric(5,2)` | Percentage |
| `surge_multiplier` | `numeric(4,2)` | default `1.00` |
| `is_active` | `boolean` | default `true` |

---

## 3. RPC Functions

### `get_fare_estimate(pickup_lat, pickup_lon, dropoff_lat, dropoff_lon, distance_km, duration_min, vehicle_type)`
Returns: `{ base_fare, distance_fare, time_fare, platform_fee, total_fare, surge_multiplier }`

### `find_nearby_drivers(lat, lon, radius_km, vehicle_type)`
Returns: Array of `{ driver_id, full_name, avatar_url, rating, vehicle_type, plate_number, distance_km, lat, lon }`

### `create_trip_request(passenger_id, pickup_lon, pickup_lat, dropoff_lon, dropoff_lat, pickup_address, dropoff_address, vehicle_type)`
Creates trip with status `requested`, returns `trip_id`.

### `validate_promo_code(code, user_id, trip_amount)`
Returns: `{ valid, discount_amount, error_message }`

---

## 4. Row Level Security

| Table | Policy |
|-------|--------|
| `profiles` | Users read/update own row |
| `drivers` | Drivers read/update own row; passengers can read any |
| `trips` | Passenger/driver of trip can read/update; passengers can insert |
| `parcel_orders` | Sender/driver can read/update; senders can insert |
| `errand_orders` | User/driver can read/update; users can insert |
| `payments` | Users read own payments |
| `ratings` | Anyone can read; authenticated users insert for own trips |
| `chat_messages` | Trip participants can read/insert |
| `saved_places` | Owner-only CRUD |
| `notifications` | Owner can read/update (mark read) |
| `driver_locations` | Drivers upsert own; authenticated users can read |
| `vehicles` | Driver manages own; anyone can read |
| `driver_documents` | Driver manages own; admin can read all |
| `fare_config` | Anyone can read; admin-only write |

---

## 5. Realtime Subscriptions

Enable realtime for:
- `trips` — status changes
- `driver_locations` — GPS updates
- `chat_messages` — in-trip messaging
- `notifications` — new notifications

---

## 6. Storage Buckets

| Bucket | Access | Purpose |
|--------|--------|---------|
| `avatars` | Public read, owner write | Profile photos |
| `driver-documents` | Private, driver write, admin read | License, registration |
| `receipts` | Private, driver write, user read | Errand receipt photos |
