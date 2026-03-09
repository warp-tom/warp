# Warp — Driver Dispatch & Pricing

> Driver matching algorithm, fare calculation, and dispatch flow

---

## 1. Dispatch Overview

The dispatch system is the core engine of Warp. It matches users with the best available driver using a weighted scoring algorithm, handles timeouts and radius expansion, and ensures job integrity through atomic locking.

```
User Requests Ride
        ↓
Query Drivers (3km radius)
        ↓
Score & Rank Drivers
        ↓
Send Push to Top 5
        ↓
First Accept → Lock Trip
        ↓
No Accept? → Expand Radius
```

---

## 2. Driver Scoring Algorithm

Simple nearest-driver dispatch is unreliable. Warp uses a weighted score combining three factors.

### Score Formula

```
score = (distance_weight × 0.60)
      + (rating_weight   × 0.20)
      + (idle_weight      × 0.20)
```

| Factor | Weight | Reasoning |
|--------|--------|-----------|
| **Distance** | 60% | Closest driver = fastest pickup |
| **Rating** | 20% | Higher-rated drivers = better experience |
| **Idle Time** | 20% | Drivers waiting longer get priority (fairness) |

### Normalization

Each factor is normalized to 0–1 range:

```
distance_normalized = 1 - (distance_km / max_radius_km)
rating_normalized   = (driver_rating - 1) / 4
idle_normalized     = min(idle_minutes / 30, 1.0)
```

**Lowest composite score → best driver** (distance normalized inverts so closer = higher).

Actually, to rank by best:
```
final_score = (distance_normalized × 0.60)
            + (rating_normalized   × 0.20)
            + (idle_normalized     × 0.20)
```
**Highest `final_score` = best driver.**

---

## 3. Dispatch Flow (Detailed)

### Step 1: User Requests Ride
User app sends:
- `pickup_lat`, `pickup_lng`
- `destination_lat`, `destination_lng`
- `vehicle_type` (tricycle / scooter)

Creates trip record with `status = 'requested'`.

### Step 2: Query Nearby Drivers
```sql
SELECT drivers within 3 km
WHERE is_online = true
  AND verification_status = 'approved'
  AND vehicle_type matches
ORDER BY score DESC
LIMIT 5
```

### Step 3: Send Push Notifications
Send FCM push to top 5 drivers simultaneously:
```json
{
  "title": "New Ride Request",
  "body": "Pickup: Town Market · 1.2 km · ₱90",
  "data": { "trip_id": "uuid", "type": "ride_request" }
}
```

### Step 4: Wait for Acceptance
- Each driver has **10 seconds** to accept
- First driver to accept → trip is locked
- Other drivers receive cancellation notification

### Step 5: Radius Expansion
If no driver accepts within the timeout:

| Attempt | Radius | Timeout |
|---------|--------|---------|
| 1 | 3 km | 10 sec |
| 2 | 6 km | 15 sec |
| 3 | 10 km | 20 sec |
| 4 | — | Trip cancelled, user notified |

### Step 6: Lock Trip
```sql
UPDATE trips SET
  driver_id = :driver_id,
  vehicle_id = :vehicle_id,
  status = 'accepted'
WHERE id = :trip_id
  AND status = 'requested';
```

Only one driver can lock. The `WHERE status = 'requested'` prevents race conditions.

---

## 4. Dispatch for Parcel & Errand

Same system with modifications:

| Service | Difference |
|---------|-----------|
| **Parcel** | Same flow, but prioritize drivers with cargo capacity |
| **Errand** | Same flow, but filter drivers willing to accept errand jobs |

---

## 5. Pricing Algorithm

### Ride Pricing

```
fare = base_fare + (distance_km × per_km_rate) + (duration_min × per_minute_rate)
fare = MAX(fare, minimum_fare)
fare = fare × surge_multiplier
fare = ROUND(fare, 0)
```

### Default Fare Config

| Vehicle | Base Fare | Per KM | Per Min | Minimum | Platform Fee |
|---------|-----------|--------|---------|---------|-------------|
| Tricycle | ₱40 | ₱10 | ₱1.00 | ₱40 | 12% |
| Scooter | ₱35 | ₱8 | ₱0.80 | ₱35 | 12% |

### Example Calculation
```
Tricycle ride: 4 km, 12 min

base_fare     = ₱40
distance_fare = 4 × ₱10 = ₱40
time_fare     = 12 × ₱1 = ₱12
subtotal      = ₱92
platform_fee  = ₱92 × 0.12 = ₱11.04
total_fare    = ₱92 (user pays)
driver_earns  = ₱92 - ₱11.04 = ₱80.96
```

### Parcel Pricing
```
parcel_fee = ₱50 base + (distance_km × ₱12)
```

### Errand Pricing
```
errand_fee = ₱60 delivery_fee + (wait_minutes × ₱5)
total_cost = errand_fee + actual_item_cost (set by driver)
```

---

## 6. Surge Pricing (Post-MVP)

### Trigger
When demand-to-supply ratio exceeds threshold:

| Ratio (requests : online drivers) | Multiplier |
|-----------------------------------|-----------|
| < 2:1 | 1.0× |
| 2:1 – 3:1 | 1.3× |
| 3:1 – 5:1 | 1.5× |
| > 5:1 | 2.0× |

### Implementation
- Calculated per zone (barangay/area)
- Updated every 5 minutes
- Stored in `fare_config.surge_multiplier`
- User sees surge warning before confirming ride

---

## 7. Cancellation Rules

### User Cancellation
| Timing | Penalty |
|--------|---------|
| Before driver accepts | Free |
| After driver accepts, before arrival | Free (first 2/day) |
| After driver arrives | ₱30 cancellation fee |
| Excessive cancellations (>5/week) | Temporary ban |

### Driver Cancellation
| Timing | Penalty |
|--------|---------|
| Before accepting | No penalty |
| After accepting | Warning logged |
| Excessive cancellations (>3/day) | Temporary deactivation |

---

## 8. Anti-Fraud Rules

| Rule | Detection |
|------|----------|
| Fake trips | Same user + driver repeatedly |
| GPS spoofing | Speed/distance anomaly detection |
| Excessive short trips | Pattern analysis on trip history |
| Driver collusion | Flagged when pickup == destination |

---

## 9. Driver Incentive System

### Weekly Bonuses

| Milestone | Bonus |
|-----------|-------|
| 20 trips/week | ₱200 |
| 50 trips/week | ₱500 |
| 100 trips/week | ₱1,200 |

### Referral Program
- Driver refers new driver → ₱300 bonus after 10 trips
- Driver refers new user → ₱100 bonus after 3 trips

### Leaderboard
- Top 10 drivers per city, refreshed weekly
- Displayed in driver app
- Top 3 get additional bonuses
