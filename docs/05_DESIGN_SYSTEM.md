# Warp — Material 3 Design System

> Design tokens, typography, color, spacing, and component library

---

## 1. Design Philosophy

| Principle | Execution |
|-----------|-----------|
| **Clean** | Stark white backgrounds, no surface tints |
| **Minimal** | Only essential elements visible |
| **Crisp** | Sharp typography hierarchy, high contrast |
| **Modern** | Material 3 components, smooth animations |
| **Polished** | Micro-interactions, thoughtful spacing |

---

## 2. Color System

### Seed Color
```
Deep Blue — #2563EB
```

### Core Palette

| Role | Light | Dark | Usage |
|------|-------|------|-------|
| Primary | `#2563EB` | `#93B4FF` | CTAs, active states |
| On Primary | `#FFFFFF` | `#002B75` | Text on primary |
| Primary Container | `#DBE4FF` | `#00419E` | Subtle highlights |
| Secondary | `#14B8A6` | `#5EEAD4` | Success, delivery |
| Error | `#EF4444` | `#FCA5A5` | Errors, cancel |
| Surface | `#FFFFFF` | `#1A1A2E` | Cards, sheets |
| Background | `#F8FAFC` | `#0F0F1A` | Page background |
| On Surface | `#1E293B` | `#E2E8F0` | Primary text |
| On Surface Variant | `#64748B` | `#94A3B8` | Secondary text |
| Outline | `#E2E8F0` | `#334155` | Borders, dividers |

### Status Colors

| Status | Color | Usage |
|--------|-------|-------|
| Available | `#22C55E` | Driver online, completed |
| In Progress | `#F59E0B` | Ongoing trips |
| Pending | `#64748B` | Waiting states |
| Error | `#EF4444` | Cancelled, failed |

### Flutter Implementation
```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
)
```

---

## 3. Typography

### Font Family
**Inter** — clean, highly readable, optimized for mobile.

```yaml
# pubspec.yaml
google_fonts: ^6.1.0
```

### Type Scale

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|------------|-------|
| Display Large | 36 | Bold (700) | 1.2 | Splash title |
| Headline Medium | 28 | Semi-Bold (600) | 1.3 | Page titles |
| Title Large | 22 | Semi-Bold (600) | 1.3 | Section headers |
| Title Medium | 18 | Medium (500) | 1.4 | Card titles |
| Body Large | 16 | Regular (400) | 1.5 | Primary text |
| Body Medium | 14 | Regular (400) | 1.5 | Default body |
| Body Small | 12 | Regular (400) | 1.4 | Captions |
| Label Large | 14 | Semi-Bold (600) | 1.3 | Buttons |
| Label Small | 11 | Medium (500) | 1.3 | Tags, badges |

### Text Colors

| Priority | Color | Usage |
|----------|-------|-------|
| Primary | `#1E293B` | Headings, important data |
| Secondary | `#475569` | Body text |
| Tertiary | `#94A3B8` | Hints, timestamps |

---

## 4. Spacing System

### Base Unit: 4px

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Inline spacing |
| `sm` | 8px | Tight padding |
| `md` | 12px | Between related items |
| `lg` | 16px | Card padding, section gaps |
| `xl` | 24px | Between sections |
| `2xl` | 32px | Major section breaks |
| `3xl` | 48px | Page-level spacing |

### Corner Radius

| Token | Value | Usage |
|-------|-------|-------|
| `sm` | 8px | Buttons, chips |
| `md` | 12px | Cards, inputs |
| `lg` | 16px | Bottom sheets |
| `xl` | 24px | Modals |
| `full` | 999px | Circular avatars, pills |

---

## 5. Elevation & Shadows

| Level | Shadow | Usage |
|-------|--------|-------|
| 0 | None | Flat surfaces |
| 1 | `0 1px 3px rgba(0,0,0,0.08)` | Cards at rest |
| 2 | `0 4px 12px rgba(0,0,0,0.10)` | Floating cards |
| 3 | `0 8px 24px rgba(0,0,0,0.12)` | Bottom sheets |
| 4 | `0 16px 48px rgba(0,0,0,0.16)` | Modals |

---

## 6. Component Library

### 6.1 Primary Button
- Height: 52px
- Width: Full width
- Radius: 12px
- Color: Primary
- Text: Label Large, white
- States: default → pressed (scale 0.97) → disabled (40% opacity)

### 6.2 Secondary Button
- Height: 48px
- Border: 1.5px solid Primary
- Background: transparent
- Text: Label Large, Primary color

### 6.3 Service Card
- Dimensions: ~100px × 100px
- Radius: 16px
- Background: White
- Shadow: Level 1
- Content: Icon (32px) + Title (Label Large)
- States: default → hover/press (shadow level 2)

### 6.4 Driver Card
- Radius: 16px
- Content: Avatar (48px) + Name + Vehicle + Rating
- Actions: Call, Message buttons
- Background: White, shadow level 2

### 6.5 Activity Card
- Radius: 12px
- Content: Service icon + Destination + Price + Status + Date
- Background: White, shadow level 1

### 6.6 Search Bar
- Height: 52px
- Radius: 12px
- Background: `#F1F5F9`
- Icon: Search (left)
- Placeholder: Body Medium, tertiary color

### 6.7 Vehicle Selector
- Horizontal scroll cards
- Selected: Primary border, light primary background
- Content: Vehicle icon + Type name + Price + ETA

### 6.8 Bottom Sheet
- Radius: 24px (top)
- Handle: 40px × 4px, centered, `#CBD5E1`
- Background: White
- Shadow: Level 3

### 6.9 Navigation Bar
- Height: 64px
- Background: White
- Indicator: Primary, pill shape
- Icons: 24px, outlined (rest) / filled (active)

---

## 7. Iconography

### Style
- Material Symbols Rounded
- Weight: 400 (regular), 600 (active)
- Size: 24px (navigation), 20px (inline), 32px (feature)
- Optical size: true

### Key Icons
| Feature | Icon |
|---------|------|
| Ride | `directions_car` |
| Parcel | `package_2` |
| Errand | `shopping_bag` |
| Home | `home` |
| Activity | `receipt_long` |
| Profile | `person` |
| Search | `search` |
| Location | `my_location` |
| Call | `phone` |
| Chat | `chat` |
| Emergency | `emergency` |
| Star | `star` |
| Settings | `settings` |

---

## 8. Motion Design

### Principles
| Principle | Implementation |
|-----------|---------------|
| Natural | Ease-in-out curves |
| Quick | 200–300ms for micro-interactions |
| Purposeful | Animations guide attention |

### Durations

| Type | Duration |
|------|----------|
| Micro (button press) | 100ms |
| Standard (card enter) | 200ms |
| Emphasis (page transition) | 300ms |
| Complex (bottom sheet) | 350ms |

### Transitions
- Page: shared axis (horizontal)
- Bottom sheet: slide up with fade
- Cards: fade + translate Y (16px)
- Markers: scale + bounce

### Packages
```yaml
flutter_animate: ^4.5.0    # Declarative animations
lottie: ^3.1.0              # Complex illustrations
```

---

## 9. File Structure

```
lib/core/theme/
  ├── app_theme.dart        # ThemeData configuration
  ├── colors.dart           # Color constants
  ├── typography.dart       # TextTheme setup
  └── spacing.dart          # Spacing constants
```
