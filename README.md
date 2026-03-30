# Belay Buddy - Find Climbing Partners

A Flutter app for finding belay partners at climbing crags. Browse a map of climbing locations, see who's planning to climb, post your own availability on **community bulletin boards**, and connect with other climbers.

## 🎯 Status: Functional MVP with Community Board UI ✅

The app is fully functional with Firebase backend and a unique **bulletin board aesthetic** inspired by physical community boards at climbing crags!

## ✨ Features Implemented

### ✅ Authentication
- Email/password sign up and login
- Firebase Authentication integration
- Auth state management with Riverpod
- Auto-redirect based on auth status

### ✅ Interactive Map
- Google Maps with terrain view showing climbing crags
- Real-time crag loading from Firestore
- Orange markers for crags
- Tap markers to view community board
- My location tracking

### ✅ Community Bulletin Boards 📌
**The signature feature!** Each crag has a digital bulletin board that looks like the physical cork boards at real climbing areas:

- **Post Cards**: Paper note aesthetic with slight rotation
- **Push Pins**: Visual pins holding notes to the board
- **Color-coded**: Yellow for "climbing now", cream for scheduled
- **Belay Status Chips**: "Need Belay" and "Can Belay" badges
- **Cork Board Header**: Tan background mimicking real cork

### ✅ Post Creation
- Choose between "Today/Now" or "Scheduled" climbing
- Date/time picker for planned sessions
- Title and description fields
- Belay status toggles
- Posts auto-expire (12h for immediate, 2h after scheduled time)
- Clean, form-based UI

### ✅ Firebase Integration
- **Firestore Service Layer**: Full CRUD operations
- **Real-time Updates**: Posts stream live to all users
- **Collections**: users, crags, posts, conversations, messages
- **Providers**: Riverpod providers for reactive data

### ✅ Seeded Crag Data
8 popular US climbing areas pre-loaded:
- Red Rock Canyon, NV
- Yosemite Valley, CA
- Joshua Tree, CA
- Smith Rock, OR
- Red River Gorge, KY
- Hueco Tanks, TX
- New River Gorge, WV
- Bishop Buttermilks, CA

### ✅ Color Scheme
**Outdoor-inspired palette:**
- Olive green primary (#6B8E23)
- Orange secondary (#D2691E)
- Tan tertiary (#D2B48C)
- Cork board tan (#D2B48C)
- Warm, earthy tones throughout

## 📁 Project Structure

```
lib/
├── models/                  # Freezed data models
│   ├── app_user.dart        # User profiles
│   ├── crag.dart            # Crag locations + types
│   ├── climbing_post.dart   # Availability posts
│   └── message.dart         # Chat messages
├── services/
│   └── firestore_service.dart   # Firebase CRUD operations
├── providers/
│   └── firestore_providers.dart # Riverpod providers
├── screens/
│   ├── auth/
│   │   └── login_screen.dart        # Sign in/up
│   ├── home/
│   │   └── map_screen.dart          # Map with crags
│   └── crag/
│       ├── crag_detail_screen.dart  # Bulletin board
│       └── create_post_screen.dart  # Post creation
├── widgets/
│   └── post_card.dart       # Paper note cards
├── utils/
│   └── seed_data.dart       # Initial crag seeding
└── main.dart                # App entry + routing
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter 3.29.0+
- Firebase project with Firestore enabled
- Google Maps API key

### Installation

1. **Install dependencies:**
   ```bash
   fvm flutter pub get
   fvm flutter pub run build_runner build
   ```

2. **Configure Firebase:**
   - Already set up via `firebase_options.dart`
   - Ensure Firestore is enabled in Firebase Console

3. **Configure Google Maps:**

   **iOS** (`ios/Runner/AppDelegate.swift`):
   ```swift
   import GoogleMaps

   GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
   ```

   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <manifest>
     <application>
       <meta-data
           android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_ANDROID_API_KEY"/>
     </application>
   </manifest>
   ```

4. **Add location permissions:**

   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>Show nearby climbing crags</string>
   ```

5. **Seed initial crag data:**

   Run the app once, then you can call the seed function from a debug screen or temporarily in main.dart:
   ```dart
   import 'package:belay_buddy/utils/seed_data.dart';

   // In main() after Firebase init:
   await seedInitialCrags(FirestoreService());
   ```

6. **Run the app:**
   ```bash
   fvm flutter run
   ```

## 🎨 UI Showcase

### Community Board Aesthetic
- **Cork board texture**: Tan background (#D2B48C)
- **Paper notes**: Cream/moccasin cards with slight rotation
- **Push pins**: Red pins at top of cards
- **Badge system**: Colored chips for post type and belay status
- **User avatars**: Circular avatars with initials
- **Timestamp formatting**: Relative times ("in 2h", "Sat 3pm")

### Post Types
- **NOW** (orange badge): Climbing today or immediately
- **PLANNED** (green badge): Scheduled for future date/time

### Belay Status

## 🔥 Firebase Backend

### Collections

```
users/
  {userId}/
    uid, email, displayName, experienceLevel, climbingStyles[],
    favoriteCragIds[], createdAt, lastActive

crags/
  {cragId}/
    id, name, location {lat, lng}, description,
    types[], region, country, activeClimbersCount

posts/
  {postId}/
    id, userId, cragId, title, description, dateTime,
    type, needsBelay, offeringBelay, expiresAt, createdAt

conversations/
  {conversationId}/
    id, participantIds[], lastMessage, lastMessageTime,
    isReadByUser{}, createdAt

    messages/ (subcollection)
      {messageId}/
        id, conversationId, senderId, text, timestamp, isRead
```

### Security Rules (TODO)
Add these to Firebase Console:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read all, write own
    match /users/{userId} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }

    // Everyone can read crags, authenticated users can create
    match /crags/{cragId} {
      allow read: if true;
      allow create: if request.auth != null;
    }

    // Everyone can read posts, authenticated users can write own
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }

    // Only conversation participants can read/write
    match /conversations/{convId} {
      allow read, write: if request.auth.uid in resource.data.participantIds;
    }
  }
}
```

## 📋 How to Use

1. **Sign up** with email/password
2. **Browse the map** - see crags with orange markers
3. **Tap a crag** - view the bulletin board
4. **Create a post**:
   - Choose "Today/Now" or "Scheduled"
   - Set date/time (if scheduled)
   - Write title and details
   - Mark belay status
5. **See posts** appear as pinned notes on the board
6. **Tap a post** to connect with the climber (messaging coming soon!)

## 🎯 Next Steps

### Immediate TODOs
- [ ] **User Profile Screen**: Complete profile setup after signup
- [ ] **Messaging System**: Real-time chat between users
- [ ] **FAB on Map**: Quick post creation from map screen
- [ ] **Search**: Find crags by name or location

### Future Enhancements
- [ ] User profile photos and bios
- [ ] Post comments/reactions
- [ ] User ratings/verification
- [ ] Group climbing requests
- [ ] Weather integration per crag
- [ ] Route database within crags
- [ ] Photo uploads for crags
- [ ] Push notifications
- [ ] Social features (friends, followers)
- [ ] User-submitted crag additions

## 🛠 Tech Stack

**Frontend**
- Flutter 3.29.0 / Dart 3.7.0
- Riverpod 2.5.1 (state management)
- Freezed 2.5.7 (immutable models)
- go_router 14.2.3 (navigation)

**Backend**
- Firebase Auth (authentication)
- Cloud Firestore (database)
- Firebase Storage (for future photo uploads)

**Maps & Location**
- google_maps_flutter 2.9.0
- geolocator 13.0.2
- geocoding 3.0.0

**UI Libraries**
- Material Design 3
- cached_network_image 3.4.1
- intl 0.19.0
- uuid 4.5.1

## 💻 Development

```bash
# Install deps
fvm flutter pub get

# Generate Freezed models
fvm flutter pub run build_runner build

# Watch mode (auto-regenerate)
fvm flutter pub run build_runner watch

# Run app
fvm flutter run

# Analyze
fvm flutter analyze

# Test
fvm flutter test
```

## 🤝 Contributing

Personal project, but open to ideas and suggestions!

## 📄 License

Feel free to use and adapt for your own projects.

---

**Built with ❤️ for the climbing community**
