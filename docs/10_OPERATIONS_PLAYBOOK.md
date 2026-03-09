# Warp — Operations Playbook

> Launch strategy, driver recruitment, growth loops, and city expansion

---

## 1. Pre-Launch Checklist (Week −4 to Week 0)

### Infrastructure
- [ ] Supabase project configured with production tables, RLS, and edge functions
- [ ] Flutter user app compiled and tested on Android/iOS
- [ ] Flutter driver app compiled and tested on Android/iOS
- [ ] Admin dashboard deployed (React + Vite)
- [ ] Firebase Cloud Messaging configured
- [ ] Google Maps API keys provisioned
- [ ] Sentry error tracking enabled
- [ ] App Store / Play Store listings prepared

### Operations
- [ ] First-city selected (criteria below)
- [ ] Driver recruitment campaign started
- [ ] 30–50 drivers onboarded and verified
- [ ] Pricing tested with real routes
- [ ] Support phone number / chat configured
- [ ] Local marketing materials prepared

---

## 2. City Selection Criteria

Score potential cities on these factors:

| Factor | Weight | Ideal |
|--------|--------|-------|
| Population | 25% | 150k–500k |
| Mobile internet quality | 20% | 4G coverage |
| Active tricycle/motorcycle transport | 20% | Established TODA |
| Distance from Manila | 15% | 1–3 hours (operational support) |
| Existing digital transport | 10% | None or minimal |
| University / hospital / market presence | 10% | Multiple demand generators |

### Recommended First Cities (Philippines)
- Lipa, Batangas
- San Pablo, Laguna
- Tarlac City
- Cabanatuan, Nueva Ecija
- Dagupan, Pangasinan

---

## 3. Driver Recruitment Strategy

### Target: 30–50 drivers at launch

### Channels

| Channel | Approach | Expected Yield |
|---------|----------|---------------|
| **TODA Associations** | Direct visit, pitch to leadership | 15–20 drivers |
| **Facebook Groups** | City buy/sell, riders groups, community pages | 10–15 drivers |
| **Referral Program** | Existing drivers invite peers (₱300 bonus) | 5–10 drivers |
| **Physical Flyers** | Transport terminals, markets, barangay halls | 5–10 drivers |

### Pitch to Drivers
> "More ride requests. Extra delivery income. Flexible hours. No franchise fee."

### Driver Signup Incentive
- ₱500 signup bonus (paid after 5 completed trips)
- Zero commission for first 2 weeks

---

## 4. Driver Onboarding Process

```
1. Install Driver App
2. Register with phone number
3. Upload documents:
   - Driver's license
   - Vehicle registration (OR/CR)
   - Selfie verification
   - MTOP permit (tricycle)
4. Admin reviews & approves (within 24 hours)
5. Driver goes online
```

### Required Documents

| Document | Purpose |
|----------|---------|
| Driver's license | Legal driving authorization |
| OR/CR | Vehicle ownership/registration |
| MTOP | Municipal tricycle operating permit |
| Selfie | Identity verification |

---

## 5. Pricing Strategy

### Launch Pricing (Below Market)

| Service | Pricing |
|---------|---------|
| Tricycle ride | ₱40 base + ₱10/km + ₱1/min |
| Scooter ride | ₱35 base + ₱8/km + ₱0.80/min |
| Parcel delivery | ₱50 base + ₱12/km |
| Errand / Buy-for-me | ₱60 delivery + ₱5/min wait |

### Platform Commission
- **Launch**: 10% (attract drivers)
- **Growth**: 12–15%
- **Scale**: 15–20%

### Price Comparison
Must be cheaper or comparable to informal tricycle fares to drive adoption.

---

## 6. Launch Day Plan

### Day 1 Preparation
- 20–30 drivers online from 6 AM
- Admin team monitoring dashboard
- Support team on standby

### Launch Promotions
| Promo | Details |
|-------|---------|
| First ride free (up to ₱50) | New users |
| First parcel delivery free | New users |
| Driver ₱100 bonus | Complete 5 rides on launch day |

### Marketing Blitz
- Facebook ads targeting city (₱300–500 budget)
- Shares in local Facebook groups
- Flyers at markets, malls, terminals
- Word-of-mouth via Barangay partnerships

---

## 7. First 60 Days Playbook

### Week 1–2: Launch & Learn
- Monitor all trips from admin dashboard
- Collect driver feedback daily
- Fix critical bugs immediately
- Track: rides/day, wait times, driver earnings

### Week 3–4: Optimize
- Adjust pricing if needed
- Increase driver count if wait times > 5 min
- Reduce promotions gradually
- Start parcel marketing

### Week 5–6: Grow
- Launch Buy-for-me service
- Expand marketing to nearby barangays
- Introduce weekly driver bonuses
- Track user retention

### Week 7–8: Sustain
- Analyze unit economics (revenue per trip vs. cost)
- Plan second city expansion
- Build community (driver groups, user feedback)
- Evaluate add-on services

---

## 8. Supply vs. Demand Balance

### The Core Challenge
```
Too many drivers → drivers earn too little → drivers leave
Too few drivers  → users wait too long   → users leave
```

### Target Ratio
```
1 driver : 3–5 active users at peak hours
```

### Balancing Tools
| Situation | Action |
|-----------|--------|
| Too few drivers | Push notification: "High demand near Market — go online to earn more" |
| Too many drivers | Reduce promotions, pause recruitment |
| Peak demand | Enable surge pricing (post-MVP) |
| Low demand periods | Offer ride discounts to boost usage |

---

## 9. Customer Support

### MVP Support Channels
| Channel | Response Time |
|---------|--------------|
| In-app support chat | < 15 min |
| Support phone number | < 5 min (during peak hours) |
| Facebook page messages | < 1 hour |

### Common Issues & Resolution

| Issue | Resolution |
|-------|-----------|
| Driver didn't arrive | Refund + apology credit |
| Wrong pickup location | Guide user to adjust pin |
| Payment dispute | Review trip details, issue credit |
| Driver complaint | Review, warn, or suspend driver |
| App crash | Collect Sentry report, deploy fix |

---

## 10. Driver Retention

### Key Retention Factors

| Factor | Strategy |
|--------|----------|
| Consistent income | Ensure regular ride flow |
| Fair commission | Start low (10%), increase gradually |
| Bonus programs | Weekly trip milestones (see below) |
| Fast support | Dedicated driver support line |
| Community | Driver WhatsApp/Viber groups |

### Weekly Bonus Structure

| Milestone | Bonus |
|-----------|-------|
| 20 trips/week | ₱200 |
| 50 trips/week | ₱500 |
| 100 trips/week | ₱1,200 |

### Driver Leaderboard
- Top 10 drivers displayed in driver app
- Weekly reset
- Top 3 get additional bonuses

---

## 11. Success Metrics (KPIs)

### Weekly Tracking

| Metric | Target (Month 1) | Target (Month 3) |
|--------|-------------------|-------------------|
| Daily rides | 50–100 | 200–400 |
| Daily deliveries | 10–30 | 50–100 |
| Active drivers | 30–50 | 80–150 |
| Avg. wait time | < 5 min | < 3 min |
| Driver earnings/hour | ₱120–180 | ₱150–200 |
| User 7-day retention | 30% | 45% |
| Driver 30-day retention | 70% | 80% |
| Daily revenue | ₱3k–5k | ₱15k–25k |

---

## 12. Expansion Strategy

### When to Expand
Expand to next city when:
- 200+ daily rides in current city
- 80%+ driver retention
- Positive unit economics (revenue > acquisition costs)

### Expansion Playbook
```
City A (current)
→ City B (neighboring, 30 km away)
→ City C (same province)
→ Province-wide coverage
→ Next province
```

### Expansion Checklist
- [ ] Identify city using selection criteria
- [ ] Recruit 20–30 drivers
- [ ] Set up local pricing
- [ ] Run Facebook ad campaign
- [ ] Provide local support
- [ ] Monitor for 4 weeks before next expansion

---

## 13. Post-MVP Service Additions

| Service | Timeline | Complexity |
|---------|----------|-----------|
| Scheduled rides | Month 3 | Low |
| Food delivery | Month 4 | Medium |
| Trusted driver (favorites) | Month 3 | Low |
| Community pickup points | Month 2 | Low |
| Store marketplace | Month 6 | High |
| In-app GCash payment | Month 4 | Medium |
| Driver wallet/cashout | Month 5 | Medium |

---

## 14. Competitive Moat

### How Warp Wins in Provinces

| Factor | Warp | Grab |
|--------|------|------|
| Vehicle types | Tricycles + scooters | Cars + motorcycles |
| Pricing | Provincial rates | Metro pricing |
| Address handling | Community pickup points | Exact addresses |
| Driver relationship | Personal, community | Anonymous |
| Commission | 10–15% | 20–25% |
| Service scope | Ride + Parcel + Errand | Ride + Food |
| Branding | "Built for [City]" | Global brand |
