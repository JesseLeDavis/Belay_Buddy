# Belay Buddy - Claude Code Context

## Project Overview
Flutter app for finding belay partners at climbing crags. Users browse a map, view community bulletin boards per crag, and post climbing availability.

## Tech Stack
- **Flutter** 3.29.0 / Dart 3.7.0 (use `fvm flutter` for all Flutter commands)
- **State management**: Riverpod 2.x with `flutter_riverpod`
- **Models**: Freezed + json_serializable (generated files: `*.freezed.dart`, `*.g.dart`)
- **Navigation**: go_router
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Maps**: google_maps_flutter + geolocator

## Common Commands
```bash
fvm flutter pub get             # Install dependencies
fvm flutter pub run build_runner build   # Regenerate Freezed/JSON models
fvm flutter pub run build_runner watch   # Watch mode
fvm flutter run                  # Run app
fvm flutter analyze              # Lint check
fvm flutter test                 # Run tests
```

## Project Structure
```
lib/
├── models/          # Freezed data models (app_user, crag, climbing_post, message)
├── services/        # firestore_service.dart — Firebase CRUD
├── providers/       # firestore_providers.dart — Riverpod providers
├── screens/
│   ├── auth/        # login_screen.dart
│   ├── home/        # map_screen.dart
│   └── crag/        # crag_detail_screen.dart, create_post_screen.dart
├── widgets/         # post_card.dart
├── utils/           # seed_data.dart
└── main.dart        # Entry point + routing
```

## Key Conventions
- Models use Freezed; always run `build_runner build` after changing model files
- Riverpod providers live in `providers/firestore_providers.dart`
- Color palette: olive green primary `#6B8E23`, orange secondary `#D2691E`, tan `#D2B48C`
- Posts auto-expire: 12h for "now" posts, 2h after scheduled time

## Firebase Collections
- `users`, `crags`, `posts`, `conversations`, `messages` (subcollection of conversations)

## Known TODOs (from README)
- User Profile Screen
- Messaging System (real-time chat)
- FAB on Map for quick post creation
- Search crags by name/location
