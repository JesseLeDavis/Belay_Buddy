# Belay Buddy - Claude Code Context

> **Design north star:** [`docs/design-north-star.md`](docs/design-north-star.md) is the source of truth for the redesign. If a PR doesn't move us toward what's written there, it doesn't ship. Change that doc first, then change code.

## Project Overview
Flutter app for finding a belay partner tonight at the gym or crag you already climb at. Currently mid-redesign on `redesign/chalk-and-static` — the old "community bulletin board" model has been removed in favor of a presence-and-scheduling product focused on a single verb: *I'm climbing [when] at [where].*

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
    │   │   ├── mock_data.dart      # 5 users, 9 venues, 14 partner-request posts
    │   │   └── firestore_service.dart  # Firestore CRUD (not yet active)
    │   ├── theme/
    │   │   └── app_theme.dart      # Chalk & Static tokens (AppColors, AppSpacing, AppRadius)
    │   ├── utils/                  # climbing_tags, map_markers, seed_data
    │   └── widgets/                # retro_button, heatmap_strip, collage_header
    └── features/
        ├── auth/
        │   ├── domain/             # app_user.dart (Freezed)
        │   ├── data/               # auth_repository.dart (current user providers)
        │   └── presentation/       # login_screen.dart
        ├── venues/
        │   ├── domain/             # crag.dart, header_config.dart (Freezed)
        │   ├── data/               # venues_repository.dart (crag + header providers)
        │   └── presentation/       # map_screen, crag_detail_screen
        ├── posts/
        │   ├── domain/             # climbing_post.dart (Freezed)
        │   ├── data/               # posts_repository.dart
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
        └── profile/
            └── presentation/       # profile_screen, user_profile_screen
```

## Key Conventions
- **Feature-first architecture** (Andrea Bizzotto style): each feature has `domain/`, `data/`, `presentation/` sub-folders
- Models use Freezed; always run `build_runner build --delete-conflicting-outputs` after changing model files
- Each feature's providers live in its own `data/*_repository.dart`; screens import directly from feature repos
- Cross-feature deps flow: auth ← notifications, messages, connections, posts, favorites, home_settings; venues ← posts, favorites
- **Design system — "Chalk & Static"** (see `docs/design-north-star.md`):
  - Canvas `#EDE6D3` (warm manila), ink near-black, chalk-blue `#C8D4DE` (ambient), **lime `#D8FF3C` reserved exclusively for "a human is reachable"** — never decoration
  - Inter (UI) + JetBrains Mono (timestamps, venue codes) — free stand-ins for GT America + Diatype Mono
  - 1.5px hairlines, no shadows, zero border radius (except `AppRadius.full` for circular avatars)
  - Sentence case throughout. **No exclamation marks. Ever.**
- Legacy color names on `context.appColors` (dullOrange, oliveGreen, amber, etc.) are kept temporarily but remapped to ink/chalk-blue. Prefer `c.ink`, `c.chalkBlue`, `c.lime` in new code. Migration to semantic names is a follow-up PR.

## Hard rules (PR-blocking)
1. No ambient presence telemetry (no green dots, online indicators, read receipts, typing indicators, "last seen").
2. No friend graph until earned — connections form only after a confirmed climb via an `again?` tap.
3. No exclamation marks anywhere in product copy.
4. Lime is rationed. Buttons that post or wave use ink, not lime.
5. No map tab, header, or pill on the NOW screen. Map lives behind `ME → Change home gym`.
6. PostType is a single verb: partner request. Intros and lost & found are not coming back.
7. No empty states — forward-load to recurring intent windows instead.

## Firebase Collections (schema — not yet active, app runs on mock data)
```
users/          uid, email, displayName, experienceLevel, climbingStyles[],
                favoriteCragIds[], favoriteGymIds[], connectionIds[],
                pendingConnectionIds[], homeGymId, homeCragId, isHomeVisible,
                notifyHomeCatch, notifyHomeConnections, createdAt, lastActive

crags/          id, name, location{lat,lng}, description, types[], region,
                country, isGym, activeClimbersCount, createdAt, createdBy

posts/          id, userId, cragId, title, description, dateTime,
                partnerNeedType, needsBelay, offeringBelay, gradeRange,
                expiresAt, respondentIds, createdAt, isExpired

notifications/  id, toUserId, fromUserId, fromUserName, type, postId,
                cragId, cragName, isRead, createdAt

conversations/  id, participantIds[], lastMessage, lastMessageTime,
                isReadByUser{}, createdAt
  messages/     id, conversationId, senderId, text, timestamp, isRead
```

## Known TODOs
- **NOW screen** — not yet built. Hero artifact of the redesign. See wireframe in `docs/design-north-star.md`.
- **IA flip** — current nav is still MAP / MSG / ME. Target is NOW / CHATS / +POST FAB / ME-avatar. Map demotes to behind "Change home gym."
- **Migrate call sites off legacy color names** — `dullOrange`, `oliveGreen`, `amber`, etc. should become `ink`, `chalkBlue`, `lime` per semantic intent.
- **Drop neobrutalist chrome** — `CollageHeader`, `HeatmapStrip`, hard-offset shadows in remaining widgets. Will look broken until rebuilt.
- **Recurring intent windows** — data model + UI for "I'm usually here Tues/Thurs evenings."
- **Firebase init** — `Firebase.initializeApp()` not called in main.dart; swap providers when ready to go live.
- **Messaging send** — chat UI built, send action is mocked (snackbar); needs real Firestore wiring.
- **Create post submit** — `_submitPost` shows snackbar but does not persist; needs Firestore write.
