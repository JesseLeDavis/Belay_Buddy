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
├── main.dart                       # Entry point: ProviderScope + MaterialApp.router
├── admin/                          # Admin dashboard (separate web entry point)
└── src/
    ├── routing/
    │   └── app_router.dart         # GoRouter config + ScaffoldWithNavBar
    ├── common/
    │   ├── data/
    │   │   ├── mock_data.dart      # 5 users, 9 venues, 13 posts, notifications, etc.
    │   │   └── firestore_service.dart  # Firestore CRUD (not yet active)
    │   ├── theme/
    │   │   └── app_theme.dart      # AppColors, AppSpacing constants
    │   ├── utils/                  # climbing_tags, map_markers, seed_data
    │   └── widgets/                # retro_button, heatmap_strip, post_card, collage_header
    └── features/
        ├── auth/
        │   ├── domain/             # app_user.dart (Freezed)
        │   ├── data/               # auth_repository.dart (current user providers)
        │   └── presentation/       # login_screen.dart
        ├── venues/
        │   ├── domain/             # crag.dart, header_config.dart (Freezed)
        │   ├── data/               # venues_repository.dart (crag + header providers)
        │   └── presentation/       # map_screen, crag_detail_screen, crag_schedule_screen
        ├── posts/
        │   ├── domain/             # climbing_post.dart (Freezed)
        │   ├── data/               # posts_repository.dart (post + heatmap providers)
        │   └── presentation/       # create_post_screen.dart
        ├── messages/
        │   ├── domain/             # message.dart (Message + Conversation, Freezed)
        │   ├── data/               # messages_repository.dart
        │   └── presentation/       # messages_screen, chat_screen
        ├── notifications/
        │   ├── domain/             # climbing_notification.dart (Freezed)
        │   ├── data/               # notifications_repository.dart
        │   └── presentation/       # notifications_screen.dart
        ├── connections/
        │   ├── data/               # connections_repository.dart
        │   └── presentation/       # find_climbers_screen.dart
        ├── favorites/
        │   └── data/               # favorites_repository.dart (FavoritesNotifier)
        ├── home_settings/
        │   └── data/               # home_settings_repository.dart (HomeSettingsNotifier)
        ├── lost_found/
        │   ├── domain/             # lost_found_item.dart (Freezed)
        │   ├── data/               # lost_found_repository.dart
        │   └── presentation/       # lost_found_screen.dart (stub)
        └── profile/
            └── presentation/       # profile_screen, user_profile_screen
```

## Key Conventions
- **Feature-first architecture** (Andrea Bizzotto style): each feature has `domain/`, `data/`, `presentation/` sub-folders
- Models use Freezed; always run `build_runner build --delete-conflicting-outputs` after changing model files
- Each feature's providers live in its own `data/*_repository.dart`; screens import directly from feature repos
- `HomeSettingsNotifier` (StateNotifier) lives in `features/home_settings/data/`
- `FavoritesNotifier` (StateNotifier) lives in `features/favorites/data/`
- Cross-feature deps flow: auth ← notifications, messages, connections, posts, favorites, home_settings; venues ← posts, favorites
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
