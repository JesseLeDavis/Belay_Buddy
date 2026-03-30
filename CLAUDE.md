# Belay Buddy - Claude Code Context

## Project Overview
Flutter app for finding belay partners at climbing crags and gyms. Users browse a map, view community bulletin boards per venue, post climbing availability, connect with other climbers, and manage a home crag/gym.

## Tech Stack
- **Flutter** 3.29.0 / Dart 3.7.0 (use `fvm flutter` for all Flutter commands)
- **State management**: Riverpod 2.x with `flutter_riverpod`
- **Models**: Freezed + json_serializable (generated files: `*.freezed.dart`, `*.g.dart`)
- **Navigation**: go_router
- **Backend**: Firebase (Auth, Firestore, Storage) — configured but not active; app runs on mock data
- **Maps**: google_maps_flutter + geolocator

## Common Commands
```bash
fvm flutter pub get                                           # Install dependencies
fvm flutter pub run build_runner build --delete-conflicting-outputs  # Regenerate models
fvm flutter pub run build_runner watch                        # Watch mode
fvm flutter run                                               # Run app
fvm flutter analyze                                           # Lint check
fvm flutter test                                              # Run tests
```

## Project Structure
```
lib/
├── models/           # Freezed data models
│   ├── app_user.dart               # connectionIds, pendingConnectionIds, homeGymId,
│   │                               #   homeCragId, isHomeVisible, notifyHomeCatch,
│   │                               #   notifyHomeConnections, favoriteGymIds, favoriteCragIds
│   ├── crag.dart                   # isGym flag distinguishes gyms from crags
│   ├── climbing_post.dart          # isExpired, PostType (immediate/scheduled)
│   ├── climbing_notification.dart  # catchNeeded, connectionRequest, connectionAccepted
│   └── lost_found_item.dart        # LostFoundStatus, LostFoundCategory
├── mock/
│   ├── mock_data.dart    # 5 users, 9 venues (5 crags + 4 gyms), 13 posts, notifications,
│   │                     #   lost & found items, conversations, messages
│   └── mock_providers.dart  # All Riverpod providers; HomeSettingsNotifier lives here
├── providers/
│   └── firestore_providers.dart  # Re-exports mock_providers — swap here for Firestore
├── screens/
│   ├── auth/        # login_screen.dart
│   ├── home/        # map_screen.dart
│   ├── crag/        # crag_detail_screen.dart, create_post_screen.dart,
│   │                #   crag_schedule_screen.dart (stub), lost_found_screen.dart (stub)
│   ├── messages/    # messages_screen.dart, chat_screen.dart
│   └── profile/     # profile_screen.dart, notifications_screen.dart,
│                    #   find_climbers_screen.dart
├── widgets/
│   ├── heatmap_strip.dart   # 7-day partner demand visualization
│   ├── post_card.dart
│   └── retro_button.dart
├── utils/
│   ├── map_markers.dart     # Custom neo-brutalist map pins drawn via Canvas
│   └── seed_data.dart       # Firestore seed helper (not used while on mock data)
├── theme/
│   └── app_theme.dart       # AppColors, AppSpacing constants
└── main.dart                # Entry point + go_router config
```

## Key Conventions
- Models use Freezed; always run `build_runner build --delete-conflicting-outputs` after changing model files
- All providers live in `mock/mock_providers.dart`, re-exported by `providers/firestore_providers.dart`
- All screens import from `providers/firestore_providers.dart`, never directly from `mock/`
- `HomeSettingsNotifier` (StateNotifier) is the mutable state layer for home base toggles
- Color palette: dullOrange `#FF6B2B`, oliveGreen `#2D9B4E`, amber `#FFD000`, accentBlue `#1D63D4`, darkNavy `#0F0F0F`, background cream `#F7EDD8`
- Design system: zero border radius, 2-3px darkNavy borders, 4-5px hard offset shadows, Space Mono (labels/headers), Cabin (body)

## Firebase Collections (schema — not yet active, app runs on mock data)
```
users/          uid, email, displayName, experienceLevel, climbingStyles[],
                favoriteCragIds[], favoriteGymIds[], connectionIds[],
                pendingConnectionIds[], homeGymId, homeCragId, isHomeVisible,
                notifyHomeCatch, notifyHomeConnections, createdAt, lastActive

crags/          id, name, location{lat,lng}, description, types[], region,
                country, isGym, activeClimbersCount, createdAt, createdBy

posts/          id, userId, cragId, title, description, dateTime, type,
                needsBelay, offeringBelay, expiresAt, createdAt, isExpired

notifications/  id, toUserId, fromUserId, fromUserName, type, postId,
                cragId, cragName, isRead, createdAt

conversations/  id, participantIds[], lastMessage, lastMessageTime,
                isReadByUser{}, createdAt
  messages/     id, conversationId, senderId, text, timestamp, isRead

lost_found/     id, cragId, userId, status, category, itemName,
                description, locationNote, isResolved, createdAt
```

## Known TODOs
- **CragScheduleScreen** — stub "COMING SOON"; needs full calendar heatmap + day-filtered session list
- **LostFoundScreen** — stub "COMING SOON"; needs filter tabs, full LostFoundCard widget, create form, mark-resolved
- **Firebase init** — `Firebase.initializeApp()` not called in main.dart; swap providers when ready to go live
- **Post expiration Cloud Functions** — `onCreate` trigger for `expiresAt`, scheduled sweep to set `isExpired: true`
- **ProfileScreen** — currently read-only; needs edit capability (bio, experience level, styles)
- **Messaging** — chat UI built, send action is mocked (snackbar); needs real Firestore wiring
- **Crag search** — search icon in map app bar is a stub; needs text filter wired to crag list
