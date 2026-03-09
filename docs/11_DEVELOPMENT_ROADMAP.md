# Warp — 12-Week Development Roadmap

> Sprint plan, MVP scope, and launch checklist

---

## 1. MVP Scope Definition

### ✅ In Scope (MVP)

| Feature | User App | Driver App | Admin |
|---------|----------|-----------|-------|
| Phone OTP auth | ✅ | ✅ | ✅ (email) |
| Ride booking | ✅ | ✅ | ✅ (monitor) |
| Parcel delivery | ✅ | ✅ | ✅ (monitor) |
| Errand / Buy-for-me | ✅ | ✅ | ✅ (monitor) |
| Real-time tracking | ✅ | ✅ | ✅ (live map) |
| Fare estimation | ✅ | — | — |
| Cash payment | ✅ | ✅ | ✅ |
| GCash (manual) | ✅ | ✅ | ✅ |
| Trip history | ✅ | ✅ | ✅ |
| Driver ratings | ✅ | — | ✅ |
| Push notifications | ✅ | ✅ | — |
| Driver approval | — | — | ✅ |
| Basic analytics | — | — | ✅ |

### ❌ Out of Scope (Post-MVP)

- Voice input
- Surge pricing
- In-app payment processing
- Scheduled rides
- Food delivery
- Driver wallet / cashout
- Store marketplace
- Advanced analytics / ML

---

## 2. Sprint Plan

### Phase 1 — Foundation (Week 1–2)

**Sprint 1: Project Setup**
- [ ] Create Flutter project (user app)
- [ ] Create Flutter project (driver app)
- [ ] Create React + Vite admin project
- [ ] Configure Supabase project (tables, RLS, extensions)
- [ ] Set up GitHub repos with CI/CD

**Sprint 2: Auth & Core Services**
- [ ] Implement Supabase phone OTP auth (user app)
- [ ] Implement Supabase phone OTP auth (driver app)
- [ ] Implement admin email auth
- [ ] Set up Google Maps integration
- [ ] Set up Firebase Cloud Messaging
- [ ] Create design system (theme, colors, typography, spacing)
- [ ] Build reusable UI components (buttons, cards, inputs)

**Deliverables**: ✅ Users and drivers can log in. Maps load. Location detected.

---

### Phase 2 — Ride System (Week 3–5)

**Sprint 3: User Ride Flow**
- [ ] Home screen with search bar + service cards + map preview
- [ ] Destination search (Google Places API)
- [ ] Vehicle selection bottom sheet
- [ ] Fare estimation (RPC call)
- [ ] Ride request creation
- [ ] Driver matching screen (loading animation)

**Sprint 4: Driver Ride Flow**
- [ ] Driver home screen (online/offline toggle)
- [ ] Incoming job notification (FCM)
- [ ] Accept/decline job UI
- [ ] Navigate to pickup
- [ ] Confirm arrival → Start trip → Complete trip

**Sprint 5: Ride Tracking & Completion**
- [ ] Real-time driver location updates (geolocator → Supabase)
- [ ] Live map tracking in user app (realtime subscription)
- [ ] Trip status updates (realtime)
- [ ] Trip completion screen
- [ ] Driver rating system
- [ ] dispatch-ride edge function

**Deliverables**: ✅ User can book a ride. Driver can accept and complete it.

---

### Phase 3 — Parcel Delivery (Week 6–7)

**Sprint 6: Parcel Flow**
- [ ] Parcel request screen (pickup, delivery, receiver details)
- [ ] Parcel order creation
- [ ] Driver receives parcel job
- [ ] Pickup confirmation → delivery confirmation
- [ ] Live tracking for parcels
- [ ] Parcel history in activity tab

**Sprint 7: Errand / Buy-for-Me Flow**
- [ ] Errand request screen (store name, shopping list, delivery address)
- [ ] Shopping list editor (add/remove items)
- [ ] Driver errand job flow
- [ ] Receipt photo upload (camera → Supabase storage)
- [ ] Item cost confirmation
- [ ] Errand history in activity tab

**Deliverables**: ✅ Parcel delivery and errands work end-to-end.

---

### Phase 4 — Payments & Ratings (Week 8–9)

**Sprint 8: Payment System**
- [ ] Payment method selection (Cash / GCash)
- [ ] Payment recording in database
- [ ] Trip summary with fare breakdown
- [ ] Driver earnings screen (daily, weekly, monthly)
- [ ] Driver trip history with earnings

**Sprint 9: Profile & Polish**
- [ ] User profile screen (edit info, avatar upload)
- [ ] Saved places (home, work, favorites)
- [ ] Notification list screen
- [ ] Activity screen with tabs (trips, parcels, errands)
- [ ] Onboarding screens (3 pages)
- [ ] Splash screen with Lottie animation

**Deliverables**: ✅ Payments recorded. Profiles complete. App polished.

---

### Phase 5 — Admin Dashboard (Week 10)

**Sprint 10: Admin Panel**
- [ ] Dashboard overview (metrics cards + charts)
- [ ] Driver management (table, approval, suspension)
- [ ] Driver document review
- [ ] Trip monitoring (table + map)
- [ ] Parcel / errand order monitoring
- [ ] Payment overview
- [ ] Basic analytics (rides per day, revenue trend)

**Deliverables**: ✅ Admin can manage drivers, monitor trips, view revenue.

---

### Phase 6 — Testing & Launch (Week 11–12)

**Sprint 11: Testing**
- [ ] End-to-end testing: ride booking flow
- [ ] End-to-end testing: parcel delivery flow
- [ ] End-to-end testing: errand flow
- [ ] Edge case testing: no driver available, cancellation, network failures
- [ ] Performance testing: location updates, realtime subscriptions
- [ ] Security audit: RLS policies, API access
- [ ] Bug fixes

**Sprint 12: Launch Preparation**
- [ ] Driver onboarding (recruit 30–50 drivers)
- [ ] App Store / Play Store submission
- [ ] Configure production Supabase environment
- [ ] Set up Sentry error tracking
- [ ] Prepare marketing materials
- [ ] Set up support channels
- [ ] Soft launch in first city

**Deliverables**: ✅ App live in production. Drivers onboarded. Service operational.

---

## 3. Team Requirements

| Role | Count | Responsibility |
|------|-------|---------------|
| Flutter Developer | 1–2 | User app + driver app |
| Backend Engineer | 1 | Supabase, edge functions, dispatch |
| UI/UX Designer | 1 | Figma designs, M3 system |
| Product / Operations | 1 | Strategy, drivers, marketing |

Total team: **4–5 people**

---

## 4. Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Not enough drivers at launch | Start recruitment 4 weeks early, offer incentives |
| Google Maps API costs | Use free tier, cache route calculations |
| Supabase rate limits | Throttle location updates (10s interval) |
| App store rejection | Follow guidelines, test on real devices early |
| User adoption | Launch promotions, local marketing |
| Driver app complexity | Keep UI minimal — one big button per step |

---

## 5. MVP Launch Checklist

### Technical
- [ ] All database tables created with RLS
- [ ] Edge functions deployed (dispatch, notifications)
- [ ] User app builds successfully on Android & iOS
- [ ] Driver app builds successfully on Android & iOS
- [ ] Admin dashboard deployed
- [ ] Push notifications working
- [ ] Location tracking working
- [ ] Error tracking (Sentry) configured

### Operational
- [ ] 30–50 drivers recruited and verified
- [ ] Pricing configured in fare_config table
- [ ] Support channel ready (phone + in-app chat)
- [ ] Marketing materials distributed
- [ ] Launch promotions configured (promo codes)

### Business
- [ ] Terms of service published
- [ ] Privacy policy published
- [ ] Driver agreement signed
- [ ] Business registration (if applicable)
- [ ] Payment handling documented

---

## 6. Post-MVP Roadmap (Month 4–12)

| Month | Feature | Priority |
|-------|---------|----------|
| 4 | Scheduled rides | Medium |
| 4 | Community pickup points | Medium |
| 5 | In-app GCash / PayMongo | High |
| 5 | Trusted driver (favorites) | Low |
| 6 | Second city expansion | High |
| 6 | Driver wallet / cashout | High |
| 7 | Food delivery | Medium |
| 8 | Advanced analytics | Medium |
| 9 | Store partnerships | Low |
| 10 | Driver leaderboard + gamification | Medium |
| 11 | Multi-city management | High |
| 12 | Investor pitch + Series A prep | High |
