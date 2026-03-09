# Warp — Business Requirements Document

> Provincial Mobility & Delivery Platform

---

## 1. Executive Summary

**Warp** is a regional mobility super-app providing reliable transportation, parcel delivery, and errand services in underserved provincial cities in the Philippines. It combines ride-hailing, last-mile delivery, and personal shopping into a single, clean, minimal platform — purpose-built for communities beyond Metro Manila.

---

## 2. Problem Statement

Provincial residents lack access to reliable, app-based transportation and delivery services. Existing platforms (Grab, Lalamove) focus on metro areas, leaving millions without:

- On-demand ride booking
- Same-day parcel delivery
- Errand/purchasing services

Local tricycle and motorcycle transport is unorganized, unpredictable, and non-digital.

---

## 3. Target Users

| Segment | Description |
|---------|-------------|
| **Passengers** | Residents without private vehicles needing affordable, reliable rides |
| **Senders** | Individuals/businesses needing same-day parcel delivery |
| **Shoppers** | Users who need items purchased and delivered from local stores |
| **Drivers** | Tricycle/motorcycle operators seeking additional, consistent income |

---

## 4. Core Services

### 4.1 Ride Booking
- On-demand tricycle and scooter rides
- Real-time driver tracking
- Fare estimation before booking
- Vehicle type selection

### 4.2 Parcel Delivery
- Point-to-point parcel pickup and delivery
- Receiver details and tracking
- Parcel type categorization (documents, box, food)

### 4.3 Errand / Buy-For-Me
- User submits shopping list and store name
- Driver purchases items at store
- Driver uploads receipt photo
- Items delivered to user

---

## 5. User Flows

### 5.1 App Launch
```
Splash Screen → Onboarding (3 screens) → Phone Login → OTP → Home Screen
```

### 5.2 Ride Flow
```
Select Destination → Select Vehicle → View Fare Estimate → Request Ride →
Driver Matching → Driver Assigned → Track Driver → Trip In Progress →
Trip Complete → Rate Driver
```

### 5.3 Parcel Flow
```
Enter Pickup Location → Enter Delivery Location → Receiver Details →
Parcel Description → Request Delivery → Driver Assigned → Track Delivery →
Parcel Delivered
```

### 5.4 Errand Flow
```
Enter Store Name → Add Shopping List → Enter Delivery Address →
Request Driver → Driver Accepts → Driver Buys Items →
Driver Uploads Receipt → Items Delivered → Confirm & Pay
```

---

## 6. User App Screens

| Screen | Purpose |
|--------|---------|
| Splash | Brand animation, session check |
| Onboarding (×3) | Service introduction |
| Login | Phone + OTP authentication |
| Home | Search bar, service cards, nearby drivers map |
| Ride Request | Map, destination, vehicle selector, fare estimate |
| Driver Matching | Loading animation while searching |
| Active Ride | Live map, driver info, ETA, emergency button |
| Trip Complete | Summary, fare, rating |
| Parcel Request | Pickup/delivery form, receiver details |
| Errand Request | Store name, shopping list, delivery address |
| Activity | History tabs: Trips / Parcels / Errands |
| Profile | User info, payment methods, saved addresses, settings |

---

## 7. Driver App Screens

| Screen | Purpose |
|--------|---------|
| Home | Online/offline toggle, today's earnings |
| Incoming Job | Request card with distance, fare, accept/decline |
| Active Job | Navigation, pickup confirmation, trip execution |
| Earnings | Daily/weekly earnings, trip history |
| Profile | Rating, vehicle info, documents, settings |

---

## 8. Admin Dashboard

| Module | Capabilities |
|--------|-------------|
| Dashboard | Active drivers, trips today, deliveries, revenue (charts) |
| Drivers | Approve/suspend, view documents, track location |
| Users | View/manage user accounts |
| Trips | Live map, trip monitoring, intervention tools |
| Parcels | Delivery tracking and status |
| Payments | GCash/cash tracking, driver payouts |
| Analytics | Rides per city, driver utilization, revenue growth |

---

## 9. Payment Methods

| Method | Phase |
|--------|-------|
| Cash | MVP |
| GCash (manual transfer) | MVP |
| In-app GCash / PayMongo | Post-MVP |

---

## 10. Success Metrics (KPIs)

| Metric | Target (Month 1) |
|--------|-------------------|
| Daily rides | 100+ |
| Daily deliveries | 30+ |
| Active drivers | 30–50 |
| User retention (7-day) | 40%+ |
| Average ride wait time | < 5 min |
| Driver earnings/hour | ₱120–180 |

---

## 11. Technology Stack

| Layer | Technology |
|-------|-----------|
| Mobile Apps | Flutter 3.22+ |
| State Management | Riverpod |
| Navigation | GoRouter |
| Backend | Supabase (PostgreSQL + Realtime + Auth + Storage) |
| Maps | Google Maps Flutter + Geolocator |
| Notifications | Firebase Cloud Messaging |
| Admin Panel | React + Vite + Material UI |
| Payments | GCash + Cash (PayMongo post-MVP) |
| Monitoring | Sentry |

---

## 12. Launch Strategy

1. **City Selection**: Population 150k–500k, good mobile internet, active tricycle transport
2. **Driver Recruitment**: 30–50 drivers via TODA associations, Facebook groups, incentives
3. **Soft Launch**: Controlled rollout with promotions (₱20 off first ride)
4. **Expansion**: Neighboring cities after validating demand

---

## 13. Competitive Advantage

- **Province-first**: optimized for tricycles, local addresses, community pickup points
- **Multi-service**: ride + parcel + errand in one app
- **Local identity**: branded for the community, not a generic global app
- **Driver-friendly**: low commission (10–15%), bonus programs, simple UX
