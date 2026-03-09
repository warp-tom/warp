# Warp — Admin Dashboard Architecture

> React + Vite admin panel for operations management

---

## 1. Tech Stack

| Technology | Purpose |
|-----------|---------|
| React 18 | UI framework |
| Vite 5 | Build tool + dev server |
| Material UI (MUI) 5 | Component library |
| React Router 6 | Client-side routing |
| Supabase JS v2 | Backend client |
| Recharts | Data visualization |
| TanStack Query | Server state management |
| Day.js | Date formatting |

---

## 2. Project Structure

```
src/
│
├── main.jsx                    # App entry
├── App.jsx                     # Root component + router
│
├── config/
│   └── supabase.js             # Supabase client init
│
├── hooks/
│   ├── useAuth.js              # Auth state hook
│   ├── useDrivers.js           # Driver data queries
│   ├── useTrips.js             # Trip data queries
│   └── useAnalytics.js         # Dashboard metrics
│
├── pages/
│   ├── Login.jsx               # Admin login
│   ├── Dashboard.jsx           # Overview metrics + charts
│   ├── Drivers.jsx             # Driver listing + management
│   ├── DriverDetail.jsx        # Single driver profile
│   ├── Users.jsx               # User listing
│   ├── Trips.jsx               # Trip monitoring
│   ├── TripDetail.jsx          # Single trip details
│   ├── Parcels.jsx             # Parcel orders
│   ├── Errands.jsx             # Errand orders
│   ├── Payments.jsx            # Payment tracking
│   ├── Analytics.jsx           # Advanced analytics
│   └── Settings.jsx            # System configuration
│
├── components/
│   ├── layout/
│   │   ├── Sidebar.jsx         # Navigation sidebar
│   │   ├── TopBar.jsx          # Header with profile
│   │   └── MainLayout.jsx      # Page layout wrapper
│   │
│   ├── dashboard/
│   │   ├── StatsCard.jsx       # Metric card (count + trend)
│   │   ├── TripsChart.jsx      # Trips per hour chart
│   │   ├── RevenueChart.jsx    # Revenue trend chart
│   │   └── LiveMap.jsx         # Real-time driver map
│   │
│   ├── drivers/
│   │   ├── DriverTable.jsx     # Driver data table
│   │   ├── DriverApproval.jsx  # Document review + approve/reject
│   │   └── DriverLocation.jsx  # Single driver map view
│   │
│   ├── trips/
│   │   ├── TripTable.jsx       # Trip listing
│   │   ├── TripMap.jsx         # Trip route visualization
│   │   └── TripTimeline.jsx    # Status timeline
│   │
│   └── shared/
│       ├── DataTable.jsx       # Reusable data table
│       ├── SearchBar.jsx       # Table search
│       ├── StatusBadge.jsx     # Colored status chip
│       └── ConfirmDialog.jsx   # Action confirmation
│
└── utils/
    ├── formatters.js           # Currency, date, distance
    └── constants.js            # Status colors, labels
```

---

## 3. Sidebar Navigation

```
┌──────────────────┐
│  WARP Admin      │
│                  │
│  📊 Dashboard    │
│  ─────────────── │
│  🚗 Drivers      │
│  👤 Users        │
│  🗺  Trips       │
│  📦 Parcels      │
│  🛒 Errands      │
│  💳 Payments     │
│  📈 Analytics    │
│  ─────────────── │
│  ⚙  Settings     │
│                  │
│  [Admin Name]    │
│  [Logout]        │
└──────────────────┘
```

---

## 4. Page Specifications

### 4.1 Dashboard

**Metrics Cards** (top row):
| Card | Value | Trend |
|------|-------|-------|
| Active Drivers | `42` | ↑ 8% |
| Trips Today | `186` | ↑ 12% |
| Deliveries Today | `34` | ↑ 5% |
| Revenue Today | `₱18,420` | ↑ 15% |

**Charts**:
- Trips per hour (bar chart, 24h)
- Revenue trend (line chart, 7 days)
- Driver utilization (area chart)

**Live Map**:
- Shows all online drivers as markers
- Active trips shown as route lines
- Parcel deliveries shown with package icon

---

### 4.2 Driver Management

**Driver Table Columns**:
| Column | Type |
|--------|------|
| Name | text + avatar |
| Phone | text |
| Vehicle | type + plate |
| Status | badge (pending/approved/rejected) |
| Rating | stars + number |
| Trips | integer |
| Online | indicator |
| Actions | approve / suspend / view |

**Driver Detail Page**:
- Profile information
- Vehicle details + photos
- Uploaded documents (license, registration)
- Trip history table
- Earnings summary
- Location history (map)
- Action buttons: Approve / Reject / Suspend

**Document Review Flow**:
```
View Documents → Review Photos → Approve / Reject (with reason)
```

---

### 4.3 Trip Monitoring

**Trip Table Columns**:
| Column | Type |
|--------|------|
| ID | short UUID |
| Passenger | name |
| Driver | name |
| Route | pickup → destination |
| Type | ride / parcel / errand |
| Status | badge |
| Fare | currency |
| Time | timestamp |

**Trip Detail**:
- Map with route polyline
- Status timeline (requested → accepted → ... → completed)
- Passenger & driver info
- Fare breakdown
- Admin actions: Cancel trip / Refund

---

### 4.4 Payment Monitoring

**Filters**: Date range, payment method, status

**Columns**:
| Column | Type |
|--------|------|
| Order ID | link to trip/parcel/errand |
| User | name |
| Method | cash / gcash |
| Amount | currency |
| Status | pending / paid / failed |
| Date | timestamp |

**Summary Cards**:
- Total revenue (period)
- Cash payments count
- GCash payments count
- Driver payouts

---

### 4.5 Analytics

**Reports**:
- Rides per city / barangay
- Peak hours heatmap
- Driver utilization rate
- Average trip duration & distance
- Revenue by service type
- User retention cohort
- Driver churn rate

**Export**: CSV download for all reports

---

## 5. Auth & Access Control

### Admin Login
- Email + password via Supabase Auth
- Only users with `role = 'admin'` can access

### Route Protection
```jsx
function ProtectedRoute({ children }) {
  const { user, loading } = useAuth();

  if (loading) return <LoadingSpinner />;
  if (!user || user.role !== 'admin') return <Navigate to="/login" />;

  return children;
}
```

### RLS Policies for Admin
```sql
-- Admin can read all trips
CREATE POLICY "admin_read_all_trips"
ON trips FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);
```

---

## 6. Real-Time Features

### Live Driver Map
```javascript
supabase
  .channel('all-driver-locations')
  .on('postgres_changes', {
    event: '*',
    schema: 'public',
    table: 'driver_locations',
  }, (payload) => {
    updateDriverMarker(payload.new);
  })
  .subscribe();
```

### Trip Status Updates
```javascript
supabase
  .channel('active-trips')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'trips',
  }, (payload) => {
    updateTripStatus(payload.new);
  })
  .subscribe();
```

---

## 7. Fraud Detection Panel

Admin tools for detecting and handling fraud:

| Tool | Action |
|------|--------|
| Suspicious Activity Feed | Auto-flagged trips/accounts |
| Trip Anomaly Report | Unusual patterns (same route, short trips) |
| Cancel & Refund | Admin can cancel trips + issue refund |
| Driver Suspension | Immediate account deactivation |
| User Ban | Block user from platform |
| Complaint Queue | User/driver complaints for review |
