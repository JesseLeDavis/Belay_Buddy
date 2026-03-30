# Belay Buddy

A Flutter app for finding belay partners at climbing crags and gyms. Browse a map of climbing locations, view community bulletin boards per venue, post your availability, and connect with other climbers.

**Status: v0.3 — Full UI prototype running on mock data. All screens navigable, connections + home base system implemented.**

---

## Features

### Map
- Google Maps terrain view with custom neo-brutalist square pin markers
- Orange markers for outdoor crags, blue markers for gyms
- Expandable map panel (collapses to 220px; tap to full-screen)
- Crag list with GYM / CRAG type badges and region

### Crag & Gym Detail
- Collapsible SliverAppBar (green for crags, blue for gyms)
- **Home Base row** — member count badge, set/unset home location
- **Lost & Found Bin** — amber panel with FOUND/LOST counts, 2-item preview
- **Community Board** — 7-day heatmap strip showing partner demand by day, 2-post preview
- Branching FAB: Partner Session or Lost & Found

### Community Board
- Posts sorted by date with NOW (orange) and SCHEDULED (green) type indicators
- NEED BELAY / CAN BELAY tags
- Post detail bottom sheet with full info, MESSAGE and CONNECT actions

### Partner Posts
- NOW (immediate) and PLANNED (scheduled) post types
- Date/time picker for planned sessions
- Posts auto-expire: 12h for immediate, 2h after scheduled time

### Connections
- Browse climbers, send connection requests (CONNECT / PENDING / CONNECTED states)
- Connections card on profile with pending request review flow
- Notifications screen: catch-needed alerts from connections, connection requests (ACCEPT), accepted confirmations
- Unread notification badge on profile tab

### Home Base
- Set a home crag and home gym per user
- Member count on crag/gym detail (counts everyone, including private members)
- Visibility toggle — show/hide your name in the member list while still counting toward total
- Per-location notification preferences:
  - Notify when a connection at this location needs a catch
  - Notify when someone new sets this location as their home

### Favorites
- Favorite crags and gyms tracked per user (`favoriteCragIds`, `favoriteGymIds`)

### Profile
- Experience level with hatched progress bar
- Climbing styles
- Connections list with pending requests
- Find Climbers screen with connect/connected/pending state
- Notifications with unread badge

### Messaging
- Conversations list screen
- Chat screen (UI built; send action is mocked)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.29.0 / Dart 3.7.0 |
| State management | Riverpod 2.x (`flutter_riverpod`) |
| Models | Freezed + json_serializable |
| Navigation | go_router |
| Backend (planned) | Firebase Auth, Firestore, Storage |
| Maps | google_maps_flutter + geolocator |
| Fonts | Space Mono (headers), Cabin (body) |

**Current data layer:** All screens run on `lib/mock/` mock data. No Firebase dependency required to run the app.

---

## Project Structure

```
lib/
├── models/
│   ├── app_user.dart             # User profiles, connections, home base, favorites
│   ├── crag.dart                 # Crag/gym locations + types
│   ├── climbing_post.dart        # Partner availability posts
│   ├── climbing_notification.dart # Catch needed, connection request, accepted
│   ├── lost_found_item.dart      # Lost & found items per crag
│   └── message.dart              # Chat messages + conversations
├── mock/
│   ├── mock_data.dart            # Static mock data (5 users, 9 venues, 13 posts, ...)
│   └── mock_providers.dart       # Riverpod providers wrapping mock data
├── providers/
│   └── firestore_providers.dart  # Re-exports mock_providers (swap for Firestore later)
├── screens/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── home/
│   │   └── map_screen.dart
│   ├── crag/
│   │   ├── crag_detail_screen.dart   # Main crag/gym screen
│   │   ├── create_post_screen.dart   # Partner session form
│   │   ├── crag_schedule_screen.dart # Full schedule (stub)
│   │   └── lost_found_screen.dart    # Lost & found list (stub)
│   ├── messages/
│   │   ├── messages_screen.dart
│   │   └── chat_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       ├── notifications_screen.dart
│       └── find_climbers_screen.dart
├── widgets/
│   ├── heatmap_strip.dart        # 7-day partner demand strip
│   ├── post_card.dart
│   └── retro_button.dart
├── utils/
│   ├── map_markers.dart          # Custom programmatic map pin drawing
│   └── seed_data.dart            # Firestore seed (used when Firebase is active)
├── theme/
│   └── app_theme.dart            # Color palette + spacing constants
└── main.dart                     # Entry point + go_router config
```

---

## Setup

### Prerequisites
- Flutter 3.29.0+ (use `fvm flutter` if you have FVM installed)
- Google Maps API key

### Run

```bash
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter run
```

### After changing any model file

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Switching from mock data to Firebase

1. Uncomment `Firebase.initializeApp()` in `main.dart`
2. Replace the re-export in `lib/providers/firestore_providers.dart` with real Firestore providers
3. Deploy `firestore.rules` and `storage.rules`
4. Run `seedInitialCrags()` once from `lib/utils/seed_data.dart`

---

## Design System

**Neo-brutalist:** Zero border radius, thick dark navy borders (`#0F0F0F`), 5px hard offset box shadows, uppercase Space Mono labels.

| Token | Value | Use |
|---|---|---|
| `background` | `#F7EDD8` | Page background (cream) |
| `surface` | `#FFFDF5` | Cards and panels |
| `darkNavy` | `#0F0F0F` | Borders and shadows |
| `dullOrange` | `#FF6B2B` | Primary action, NOW posts |
| `oliveGreen` | `#2D9B4E` | Scheduled posts, crags |
| `amber` | `#FFD000` | Lost & Found, warnings |
| `accentBlue` | `#1D63D4` | Gyms, connections |
| `error` | `#E53935` | Destructive actions |

---

## Commands

```bash
fvm flutter pub get                                       # Install deps
fvm flutter pub run build_runner build --delete-conflicting-outputs  # Regen models
fvm flutter pub run build_runner watch                    # Watch mode
fvm flutter run                                           # Run app
fvm flutter analyze                                       # Lint check
fvm flutter test                                          # Run tests
```

---

## Firebase (configured, not yet active)

Rules are written and ready to deploy:
- `firestore.rules` — per-collection security rules
- `storage.rules` — authenticated read/write

Cloud Functions planned:
- `onPostCreate` — set `expiresAt` server-side
- `expireOldPosts` (scheduled) — mark expired posts with `isExpired: true`

Deploy when ready to switch off mock data:
```bash
firebase deploy --only firestore:rules,storage
firebase deploy --only functions
```
