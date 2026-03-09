# Warp — Technical Architecture

> System architecture, infrastructure, and integration design

---

## 1. System Overview

```
┌─────────────────┐    ┌─────────────────┐
│  Warp User App   │    │ Warp Driver App  │
│  (Flutter)       │    │ (Flutter)        │
└────────┬────────┘    └────────┬─────────┘
         │                      │
         ▼                      ▼
┌──────────────────────────────────────────┐
│            Supabase Backend              │
│  ┌────────┐ ┌────────┐ ┌─────────────┐  │
│  │  Auth   │ │Realtime│ │   Storage   │  │
│  └────────┘ └────────┘ └─────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │     PostgreSQL + PostGIS           │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │       Edge Functions               │  │
│  │  (Dispatch · Fare · Notifications) │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
         │           │            │
         ▼           ▼            ▼
┌──────────┐ ┌────────────┐ ┌──────────┐
│Google Maps│ │    FCM     │ │ PayMongo │
│ Platform  │ │(Push Notif)│ │  / GCash │
└──────────┘ └────────────┘ └──────────┘

┌─────────────────────────────────┐
│     Admin Dashboard             │
│     React + Vite + MUI         │
│     (connects to same Supabase)│
└─────────────────────────────────┘
```

---

## 2. Backend — Supabase

### 2.1 Core Services Used

| Service | Purpose |
|---------|---------|
| **Auth** | Phone/email OTP, session management, JWT tokens |
| **Database** | PostgreSQL with PostGIS for location queries |
| **Realtime** | WebSocket subscriptions for driver locations, trip status |
| **Storage** | Driver documents, receipt photos, avatars |
| **Edge Functions** | Server-side dispatch logic, fare calculations, push notifications |
| **Row Level Security** | Data isolation per user role |

### 2.2 Realtime Channels

| Channel | Data | Subscribers |
|---------|------|------------|
| `driver-locations` | GPS coordinates, heading, speed | User app (ride tracking) |
| `trip-status` | Trip state changes | Both user and driver apps |
| `chat-messages` | In-trip messaging | Trip participants |

### 2.3 Edge Functions

| Function | Trigger | Purpose |
|----------|---------|---------|
| `dispatch-ride` | HTTP POST | Find nearest drivers, send push notifications |
| `calculate-fare` | HTTP POST | Compute fare based on distance, time, surge |
| `send-notification` | HTTP POST | Proxy to FCM for push notifications |
| `verify-payment` | HTTP POST | Validate GCash/PayMongo webhook |

---

## 3. Mobile Architecture — Flutter

### 3.1 Architecture Pattern
- **Clean Architecture** with feature-first folder structure
- Clear separation: `features/` → `repositories/` → `services/`

### 3.2 State Management
- **Riverpod** — reactive, testable, scalable
- Providers for: auth state, current trip, driver location, user profile

### 3.3 Navigation
- **GoRouter** — declarative routing with deep link support
- Auth-guarded routes, redirect on session state

### 3.4 Key Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.5 | State management |
| `go_router` | ^14.0 | Navigation |
| `supabase_flutter` | ^2.5 | Backend |
| `google_maps_flutter` | ^2.6 | Map display |
| `geolocator` | ^11.0 | GPS positioning |
| `firebase_messaging` | ^14.9 | Push notifications |
| `flutter_animate` | ^4.5 | Micro-animations |
| `lottie` | ^3.1 | Animated illustrations |
| `cached_network_image` | ^3.3 | Image caching |
| `intl` | ^0.19 | Date/number formatting |
| `uuid` | ^4.4 | ID generation |

---

## 4. Admin Dashboard — React + Vite

### 4.1 Stack

| Technology | Purpose |
|-----------|---------|
| React 18 | UI framework |
| Vite | Build tool |
| Material UI (MUI) | Component library |
| Supabase JS | Backend client |
| Recharts | Data visualization |
| React Router | Navigation |

### 4.2 Auth
- Admin users have `role = 'admin'` in the `profiles` table
- RLS policies restrict admin-only operations
- JWT token validated on every request

---

## 5. External Services

### 5.1 Google Maps Platform
- **Maps SDK**: Map rendering in Flutter
- **Geocoding API**: Address ↔ coordinates
- **Directions API**: Route polylines, ETA, distance
- **Places API**: Location search autocomplete

### 5.2 Firebase Cloud Messaging
- Push notifications to both user and driver apps
- Triggered by Supabase edge functions
- Topics: `ride-requests`, `trip-updates`, `promotions`

### 5.3 Payment Gateway
- **MVP**: Cash + manual GCash transfer (recorded in-app)
- **Post-MVP**: PayMongo integration for automated payments

---

## 6. Security Architecture

### 6.1 Authentication
- Supabase Auth with phone OTP
- JWT tokens with role claims
- Session refresh via `supabase_flutter`

### 6.2 Row Level Security (RLS)
- Every table has RLS enabled
- Users access only their own data
- Drivers access their own data + assigned trips
- Admin role bypasses via service_role key (server-side only)

### 6.3 API Security
- `anon` key used in mobile apps (public, rate-limited)
- `service_role` key used only in edge functions (never in client code)
- Edge functions validate JWT before processing

### 6.4 Data Protection
- HTTPS everywhere (Supabase default)
- Sensitive fields (phone, email) protected by RLS
- Driver documents stored in private storage bucket

---

## 7. Scaling Strategy

| Phase | Users | Drivers | Infrastructure |
|-------|-------|---------|---------------|
| MVP | 500 | 50 | Supabase Pro plan |
| Growth | 5,000 | 500 | Read replicas, CDN |
| Scale | 50,000+ | 5,000+ | Connection pooling, edge caching |

### 7.1 Database Optimization
- PostGIS spatial indexes on `driver_locations`, `trips`
- Composite indexes on frequently queried columns
- Connection pooling via Supabase PgBouncer

### 7.2 Realtime Optimization
- Channel-per-trip for isolated updates
- Driver location updates throttled to 10-second intervals
- Distance filter: only update if moved > 15 meters

---

## 8. Monitoring & DevOps

### 8.1 Error Tracking
- **Sentry** for crash reporting (Flutter + Admin)
- Error boundaries in React admin

### 8.2 CI/CD
- **GitHub Actions** pipeline:
  ```
  Push → Lint → Test → Build → Deploy
  ```
- Separate workflows for: Flutter apps, Admin dashboard, Edge functions

### 8.3 Environment Management
- `development` branch on Supabase for testing
- `production` branch for live deployment
- Environment variables managed via `.env` files (gitignored)
