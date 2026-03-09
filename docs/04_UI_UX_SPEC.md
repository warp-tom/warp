# Warp — UI/UX Specification

> Screen-by-screen layout guide for User App and Driver App

---

## 1. Navigation Model

### User App — Bottom Navigation (4 tabs)
| Tab | Icon | Screen |
|-----|------|--------|
| Home | `home` | Home Screen |
| Parcel | `package` | Parcel Request |
| Activity | `history` | Activity History |
| Profile | `person` | Profile Settings |

### Driver App — Bottom Navigation (4 tabs)
| Tab | Icon | Screen |
|-----|------|--------|
| Home | `home` | Driver Home |
| Jobs | `work` | Job Queue |
| Earnings | `wallet` | Earnings Dashboard |
| Profile | `person` | Driver Profile |

---

## 2. User App Screens

### 2.1 Splash Screen
- **Purpose**: Brand identity + session initialization
- **Layout**:
  - Center: Warp logo (animated)
  - Below: Subtle motion lines / map animation (Lottie)
  - Duration: 2 seconds
- **Logic**: Check Supabase session → route to Home or Onboarding

---

### 2.2 Onboarding (3 Screens)
Each screen follows the same layout:

```
┌─────────────────────────┐
│                         │
│     [Illustration]      │
│                         │
│    Title (headline)     │
│    Description (body)   │
│                         │
│        ● ○ ○            │
│    [Next / Get Started] │
└─────────────────────────┘
```

| Screen | Title | Description |
|--------|-------|-------------|
| 1 | Ride Anywhere | Tricycle & scooter rides in seconds |
| 2 | Send Parcels | Deliver items across town effortlessly |
| 3 | Buy From Stores | Drivers shop and deliver for you |

- Final screen CTA: **Get Started** (filled button)

---

### 2.3 Authentication
**Phone Login Screen**:
```
┌─────────────────────────┐
│                         │
│    Welcome to Warp      │
│                         │
│    +63 [___________]    │
│                         │
│    [Continue]           │
│                         │
└─────────────────────────┘
```

**OTP Verification Screen**:
```
┌─────────────────────────┐
│                         │
│    Enter Code           │
│    Sent to +63 9XX      │
│                         │
│    [ _ ] [ _ ] [ _ ]    │
│    [ _ ] [ _ ] [ _ ]    │
│                         │
│    Resend Code (30s)    │
└─────────────────────────┘
```

---

### 2.4 Home Screen ⭐ (Most Important)
```
┌─────────────────────────────┐
│  Good afternoon, Tom     ⚙  │
│                              │
│  ┌──────────────────────┐   │
│  │ 🔍 Where do you      │   │
│  │    want to go?        │   │
│  └──────────────────────┘   │
│                              │
│  ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ 🚗  │ │  📦 │ │  🛒 │   │
│  │Ride │ │Parcel│ │Buy  │   │
│  │     │ │     │ │For Me│   │
│  └─────┘ └─────┘ └─────┘   │
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │    [Map Preview]     │   │
│  │   · nearby drivers   │   │
│  │                      │   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

**Elements**:
- Greeting: Dynamic time-based ("Good morning/afternoon/evening, {name}")
- Search bar: Tappable, opens destination search
- Service cards: Large rounded cards with icons
- Map preview: Shows nearby online drivers with markers

---

### 2.5 Ride Request Screen
```
┌─────────────────────────────┐
│  ← Ride                     │
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │      [MAP VIEW]      │   │
│  │   route preview      │   │
│  │                      │   │
│  └──────────────────────┘   │
│                              │
│  📍 Pickup: [Current loc]   │
│  📍 Destination: [Search]   │
│                              │
│  ── Vehicle ──               │
│  ┌──────────┐ ┌──────────┐  │
│  │ Tricycle  │ │ Scooter  │  │
│  │ ₱85 · 8m │ │ ₱65 · 6m │  │
│  └──────────┘ └──────────┘  │
│                              │
│  [  Request Ride  ]         │
└─────────────────────────────┘
```

---

### 2.6 Driver Matching Screen
```
┌─────────────────────────────┐
│                              │
│                              │
│    [Circular animation]     │
│                              │
│    Searching for your       │
│    driver...                │
│                              │
│                              │
│    [Cancel]                 │
└─────────────────────────────┘
```
- Lottie animation: pulsing circles radiating outward
- Auto-transitions when driver accepts

---

### 2.7 Active Ride Screen
```
┌─────────────────────────────┐
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │   [LIVE MAP]         │   │
│  │   driver marker      │   │
│  │   route polyline     │   │
│  │                      │   │
│  └──────────────────────┘   │
│                              │
│  ┌──────────────────────┐   │
│  │  [Photo]  Juan Cruz  │   │
│  │  ★ 4.8   Honda · ABC │   │
│  │  ETA: 3 min          │   │
│  │                      │   │
│  │  [📞 Call] [✉ Chat]  │   │
│  │                      │   │
│  │  [🚨 Emergency]      │   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

---

### 2.8 Trip Complete Screen
```
┌─────────────────────────────┐
│                              │
│    ✅ Trip Complete          │
│                              │
│    Market → Home             │
│    3.4 km · 12 min           │
│                              │
│    ─────────────────         │
│    Fare         ₱95          │
│    Payment      Cash         │
│    ─────────────────         │
│                              │
│    Rate your driver          │
│    ★ ★ ★ ★ ★                │
│                              │
│    [Leave Review]            │
│                              │
│    [Done]                    │
└─────────────────────────────┘
```

---

### 2.9 Parcel Request Screen
```
┌─────────────────────────────┐
│  ← Send Parcel              │
│                              │
│  Pickup Location             │
│  [__________________________]│
│                              │
│  Delivery Location           │
│  [__________________________]│
│                              │
│  Receiver Name               │
│  [__________________________]│
│                              │
│  Receiver Phone              │
│  [__________________________]│
│                              │
│  Parcel Type                 │
│  [Documents ▾]               │
│                              │
│  Notes (optional)            │
│  [__________________________]│
│                              │
│  Estimated Fee: ₱80          │
│                              │
│  [  Request Delivery  ]     │
└─────────────────────────────┘
```

---

### 2.10 Errand Request Screen
```
┌─────────────────────────────┐
│  ← Buy For Me               │
│                              │
│  Store Name                  │
│  [__________________________]│
│                              │
│  Shopping List               │
│  ┌────────────────────────┐ │
│  │ 🗑 Rice × 1            │ │
│  │ 🗑 Eggs × 12           │ │
│  │ 🗑 Cooking Oil × 1     │ │
│  └────────────────────────┘ │
│  [+ Add Item]                │
│                              │
│  Delivery Address            │
│  [__________________________]│
│                              │
│  Delivery Fee: ₱60           │
│  (Item costs added after     │
│   driver purchases)          │
│                              │
│  [  Request Driver  ]       │
└─────────────────────────────┘
```

---

### 2.11 Activity Screen
```
┌─────────────────────────────┐
│  Activity                    │
│                              │
│  [Trips] [Parcels] [Errands] │
│  ───────────────────────     │
│                              │
│  ┌──────────────────────┐   │
│  │ Trip to Market        │   │
│  │ ₱120 · Completed      │   │
│  │ Mar 6, 2:30 PM        │   │
│  └──────────────────────┘   │
│                              │
│  ┌──────────────────────┐   │
│  │ Parcel Delivery       │   │
│  │ ₱80 · Delivered       │   │
│  │ Mar 5, 10:15 AM       │   │
│  └──────────────────────┘   │
│                              │
└─────────────────────────────┘
```

---

### 2.12 Profile Screen
```
┌─────────────────────────────┐
│  My Profile                  │
│                              │
│       [Avatar]               │
│     Tom Santos               │
│  +63 912 345 6789            │
│                              │
│  ─────────────────           │
│  💳 Payment Methods      →   │
│  📍 Saved Places         →   │
│  🔔 Notifications        →   │
│  ❓ Help & Support       →   │
│  ⚙  Settings             →   │
│  ─────────────────           │
│                              │
│  [Logout]                    │
└─────────────────────────────┘
```

---

## 3. Driver App Screens

### 3.1 Driver Home Screen
```
┌─────────────────────────────┐
│  Hi, Juan                    │
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │  [  GO ONLINE  ]     │   │
│  │                      │   │
│  └──────────────────────┘   │
│                              │
│  Today's Earnings   ₱820     │
│  Trips Completed       8     │
│                              │
│  ┌──────────────────────┐   │
│  │                      │   │
│  │    [Map View]        │   │
│  │  demand heatmap      │   │
│  │                      │   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

---

### 3.2 Incoming Job Notification
```
┌─────────────────────────────┐
│                              │
│  🔔 New Ride Request         │
│                              │
│  📍 Pickup: Town Market      │
│  📏 Distance: 1.2 km         │
│  💰 Est. Fare: ₱90           │
│                              │
│  ┌──────────┐ ┌──────────┐  │
│  │  Accept  │ │ Decline  │  │
│  └──────────┘ └──────────┘  │
│                              │
│  ⏱ 10 seconds                │
│  [████████░░]                │
└─────────────────────────────┘
```

---

### 3.3 Active Job Flow
```
Step 1: Navigate to Pickup
  [Navigate]  →  opens Google Maps / Waze

Step 2: Arrived at Pickup
  [Confirm Arrival]

Step 3: Start Trip
  [Start Trip]

Step 4: Complete Trip
  [Complete Trip]
```

Each step is a single large button — optimized for use while driving.

---

### 3.4 Driver Earnings Screen
```
┌─────────────────────────────┐
│  Earnings                    │
│                              │
│  ┌──────────────────────┐   │
│  │  Today      ₱820     │   │
│  │  This Week  ₱4,250   │   │
│  │  This Month ₱18,400  │   │
│  └──────────────────────┘   │
│                              │
│  Recent Trips                │
│  ┌──────────────────────┐   │
│  │ Ride · ₱95 · 3.4km   │   │
│  │ 2:30 PM               │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ Parcel · ₱80 · 2.1km │   │
│  │ 1:15 PM               │   │
│  └──────────────────────┘   │
└─────────────────────────────┘
```

---

### 3.5 Driver Profile Screen
```
┌─────────────────────────────┐
│  My Profile                  │
│                              │
│       [Avatar]               │
│  ★ 4.8  ·  Juan Cruz        │
│                              │
│  ─────────────────           │
│  🚗 Vehicle Info         →   │
│  📄 Documents            →   │
│  ⚙  Settings             →   │
│  ❓ Support               →   │
│  ─────────────────           │
│                              │
│  [Go Offline & Logout]       │
└─────────────────────────────┘
```

---

## 4. Shared UI Patterns

### 4.1 Loading States
- Skeleton shimmer for lists
- Lottie animations for driver search
- Subtle progress indicators

### 4.2 Empty States
- Illustrated empty state for Activity (no trips yet)
- Clear CTA: "Book your first ride"

### 4.3 Error States
- Inline error messages for form validation
- Full-screen error with retry for network failures
- Snackbar for non-critical errors

### 4.4 Bottom Sheets
- Vehicle selection bottom sheet
- Driver info bottom sheet
- Payment method selection

### 4.5 Micro-Animations
- Button press: scale down 0.95 → release
- Card entrance: fade + slide up
- Tab switch: crossfade
- Map markers: subtle bounce on appear
