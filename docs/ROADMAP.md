# Belay Buddy — Product Roadmap

**Last updated:** 2026-03-30
**Owner:** Solo developer, personal project

---

## DONE — Shipped

### v0.1 — Initial scaffold
- [x] Flutter project, Firebase config, go_router, Riverpod, Freezed models
- [x] Login screen (email/password)
- [x] Google Maps with terrain view + crag markers
- [x] Crag detail / bulletin board screen
- [x] Post creation form (NOW / PLANNED, date picker, belay status)
- [x] Mock data layer (entire app runs offline, no Firebase dependency)
- [x] Bottom nav bar (MAP / MSG / ME)

### v0.2 — Neobrutalist UI overhaul
- [x] Full design system: zero border-radius, darkNavy hard shadows, Space Mono + Cabin fonts
- [x] Color tokens: dullOrange, oliveGreen, amber, accentBlue, darkNavy, cream background
- [x] Custom neo-brutalist nav bar with active-tab highlight
- [x] Full-screen map expand + unified CustomScrollView page
- [x] Post card redesign: colored left-border strip, NOW/PLANNED badges
- [x] Profile screen with experience bar (diagonal hatching), styles, favorites

### v0.3 — Social + Venue features
- [x] **Gym support** — `isGym` on Crag model; 4 gym entries in mock data; GYM vs CRAG labels on map list cards
- [x] **Custom map markers** — Programmatic neo-brutalist square pin icons: orange for crags, blue for gyms
- [x] **Crag detail redesign** — Lost & Found Bin panel + Community Board panel replacing flat post list
- [x] **7-day heatmap strip** — Partner demand visualization on Community Board; dot color scales with activity
- [x] **LostFoundItem model** — `status` (found/lost), `category`, `locationNote`, `isResolved`
- [x] **Branching FAB** — Partner Session vs Lost & Found options
- [x] **Post detail bottom sheet** — Full post info with user profile snippet
- [x] **Connections system** — `connectionIds`, `pendingConnectionIds` on AppUser; FindClimbersScreen (CONNECT / PENDING / CONNECTED); NotificationsScreen (catch-needed, connection request/accepted); unread badge on profile tab; CONNECT button on post detail sheet
- [x] **Home Base** — `homeGymId`, `homeCragId`, `isHomeVisible`, `notifyHomeCatch`, `notifyHomeConnections` on AppUser; home member count on crag/gym detail; `_HomeBaseSheet` with all 4 toggles; `HomeSettingsNotifier` for live in-session state
- [x] **Favorites** — `favoriteCragIds`, `favoriteGymIds` on AppUser; `isFavoriteCragProvider`, `isFavoriteGymProvider`

---

## NOW — Current Sprint

> These are the two stub screens that are visible in the UI but show "COMING SOON".

### 1. Lost & Found Screen `[M]`
The `LostFoundScreen` is a live stub reachable from the crag detail panel. Full implementation:
- Filter tabs: ALL / FOUND / LOST
- `LostFoundCard` widget with FOUND/LOST badge, category, item name, location note, time ago
- Item detail bottom sheet with "Mark as Resolved" for the post owner
- Create form (accessible from the FAB → Lost & Found path): Lost/Found toggle, category picker, item name, description, location note

### 2. Community Board / Schedule Screen `[M]`
The `CragScheduleScreen` is a live stub. Full implementation:
- Full session list sorted by date (all upcoming posts at this crag)
- Day filter: tap a day in a week view to filter the list
- Show partner's name, belay status, time, and a message/connect CTA per row

---

## NEXT — Up Next

### 3. Favorites UI `[S]`
Model fields exist (`favoriteCragIds`, `favoriteGymIds`), providers exist (`isFavoriteCragProvider`, `isFavoriteGymProvider`). Wire up the UI:
- Heart/star icon on crag detail screen (tap to toggle)
- Favorited crags/gyms surfaced at the top of the map list
- Favorites section on the profile screen

### 4. Edit Profile `[S]`
Profile screen is read-only. Add edit mode for:
- Display name
- Bio
- Experience level
- Climbing styles

### 5. Crag Search `[S]`
Search icon in map app bar is a stub. Wire to a text input that filters the crag list by name and/or region.

### 6. Wire Messaging to Firestore `[M]`
Chat UI and conversation list are built. When Firebase is active:
- `ChatScreen._sendMessage()` calls `FirestoreService.sendMessage()`
- `MessagesScreen` uses `userConversationsProvider` streaming from Firestore
- Unread badge count on Messages tab

### 7. Firebase Activation `[M]`
- Uncomment `Firebase.initializeApp()` in `main.dart`
- Replace `lib/providers/firestore_providers.dart` re-export with real Firestore providers
- Deploy `firestore.rules` and `storage.rules`
- Run `seedInitialCrags()` once

---

## LATER — Backlog

### Core Experience

| Item | Notes |
|---|---|
| Profile photo upload | Firebase Storage is in the stack; needs upload UI + Storage rules |
| Delete own post | Owner sees delete option on their post in the detail sheet |
| Fix auth bypass | `initialLocation: '/'` skips auth gate for unauthenticated users |
| Profile setup on signup | Collect displayName + experienceLevel after sign-up before landing on map |
| Map center on user location | One `geolocator` call in `initState`; permission already declared |
| Post reactions / "+1 I'll be there" | Lower friction than opening a conversation |
| Experience filter on board | Filter chips: Beginner / Intermediate / Advanced / Expert |

### Notifications (Firebase)

| Item | Notes |
|---|---|
| Push notifications | FCM for: new message, catch needed at home location, post expiry reminder |
| Cloud Function: `onPostCreate` | Set `expiresAt` server-side; prevents client tampering |
| Cloud Function: `expireOldPosts` | Scheduled sweep to set `isExpired: true` on stale posts |

### Venue & Community

| Item | Notes |
|---|---|
| User-submitted crags | `createdBy` field exists on Crag; needs submit form + admin review |
| Climbing coalitions | Access Fund chapters, clubs, stewardship orgs; event model + crag linking |
| Gym claiming flow | Owner submits claim; admin verifies; claimed gyms get "Official" badge |
| Weather widget per crag | Open-Meteo free API; show 1-day forecast on crag detail header |
| Active climber count on map markers | Badge on marker showing posts today |

### Growth

| Item | Notes |
|---|---|
| Social auth (Google / Apple) | Email/password is a conversion killer for a casual app |
| Post expiry re-engagement | "Your post expired — still at the crag?" push prompt |
| Crag coverage expansion | Import a public crag database or build user submission for launch |

---

## FUTURE — Research Needed

- **Route database within crags** — Big scope; possible partnership with Mountain Project or 27crags
- **Group climbing requests** — "Looking for 2-3 people for a multi-pitch day"
- **User ratings / trust signals** — Vouching system between climbers who have climbed together
- **Offline mode** — Cache crag + board data for areas with poor cell service
- **App Store launch** — Trademark check on "Belay Buddy" before investing in store assets

---

## Open Questions

1. **Gym verification** — Who approves gym claims at launch? Manual (Firestore console) is fine for MVP.
2. **Crag coverage** — 9 mock venues won't be enough for launch. Import a public database or build user submission before going public.
3. **Public vs. auth-required boards** — Recommendation: public read (supports shared links), auth required to post.
4. **Notification delivery for home base** — Push vs. in-app badge. In-app is already built; push needs FCM setup.
5. **Home base: one crag + one gym, or multiple?** — Current model supports exactly one each. May want to expand to a ranked list.
