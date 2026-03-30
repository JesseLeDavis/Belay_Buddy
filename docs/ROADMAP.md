# Belay Buddy — Product Roadmap

**Last updated:** 2026-03-29
**Owner:** Solo developer, personal project

---

## NOW — Current Sprint

> Actively in progress or just landed.

- [x] **Neobrutalist UI overhaul** — Bold color system (vivid orange/green/blue/yellow), hard offset shadows, 0 border radius, Space Mono typography throughout
- [x] **Collapsible map widget** — Real Google Maps at top of home screen (220px → 420px expandable), crag markers, crag list below
- [x] **Post screen cleanup** — Removed belay status checkboxes (redundant), removed "LIVE"/"ACTIVE" labels, "● NOW" replaces "● LIVE"

---

## NEXT — Up Next

> Build these in order. Each unblocks the one after it.

### 1. Profile Setup on Signup `[S]`
**The single biggest bug.** Sign-up creates a Firebase Auth account but never collects a display name or creates an `AppUser` Firestore document. Every post card shows "Unknown" and "?" avatar.

- Add a profile setup screen after sign-up: display name (required), experience level, climbing styles
- Create `AppUser` document in Firestore on completion
- Gate the main app on profile completion

### 2. Fix Auth Bypass `[S]`
`initialLocation: '/'` skips the auth gate. Unauthenticated users land on the map. Swap to a proper `redirect` in go_router that checks Firebase auth state.

### 3. Wire Post Creation to the UI `[S]`
`CreatePostScreen` works but is unreachable. Add a FAB on `CragDetailScreen` that navigates to it with the crag object as `extra`. This is the core action of the entire app.

### 4. Wire Messaging `[M]`
The UI, data models, and Firestore service all exist. Connect the dots:
- Tapping a post card → opens/creates a conversation → navigates to `ChatScreen`
- `ChatScreen._sendMessage()` calls `FirestoreService.sendMessage()` instead of showing a snackbar
- `MessagesScreen` pulls real user display names from Firestore instead of `MockData`
- Unread badge count on the Messages tab

### 5. Fix Negative Time Formatting `[S]`
`PostCard._formatDateTime` returns "in -120m" for past posts. Handle past datetimes as "Xh ago" / "Xm ago".

### 6. Center Map on User Location `[S]`
Map defaults to USA center. One `geolocator` call on init to center the camera on the user's position if permission is granted.

---

## LATER — Backlog (Prioritized)

### Venue Expansion

**Gyms** `[L]`
Gyms as a distinct venue type. Different from crags: owner-claimed, curated content, events.
- `Gym` Firestore model
- Gym markers on map (distinct icon from crags)
- Gym detail screen: hours, events, partner board
- Gym claiming flow (owner submits claim → admin verifies)
- Gym owners post events: comps, clinics, intro classes
- *Depends on: admin tooling (can be lightweight at first — manual Firestore edits)*

**Lost & Found per Crag** `[M]`
- "LOST & FOUND" tab alongside "BOARD" on each crag detail screen
- Post types: Lost Item / Found Item
- Categories: shoes, harness, draws, cam, clothing, other
- Persists until poster marks as resolved
- Contact via in-app messaging
- *New model: `LostFoundPost`*

**Climbing Coalitions** `[L]`
Local Access Fund chapters, climbing clubs, and stewardship orgs get a verified presence.
- `Coalition` model: name, region, description, website, adminUserIds
- Coalition events: **climbing clinics, crag care days**, meetings
- Events linked to crags appear on that crag's board + global events feed
- Crag map markers show a badge for upcoming coalition events
- Claiming flow (same pattern as gyms)
- *Depends on: gym claiming infrastructure (reuse the pattern)*

### Core Polish

**User Profile View** `[S]`
Tappable from any post card. Shows: display name, experience level, climbing styles, member since. The trust layer that makes strangers feel real.

**Delete Own Post** `[S]`
Climbers' plans change. Stale "here today" posts erode board quality. Owner sees a delete option on their own cards.

**Crag Search** `[S]`
Name-based filter on the map screen. The search icon is already in the app bar — wire it to a text input that filters the crag list.

**Edit Profile** `[S]`
Bio, experience level, climbing styles. Currently the profile screen is read-only.

**Favorites** `[S]`
Star a crag for quick access. `favoriteCragIds` already exists on `AppUser`. Show favorited crags at the top of the map screen list.

**My Posts Tab** `[S]`
Bottom nav "Posts" tab → show the user's active posts with delete. `userPostsProvider` already exists.

**Profile Photos** `[M]`
Upload a profile photo. Firebase Storage is already in the stack.

**Firestore Indexes + Security Rules** `[S]`
Deploy the composite index for `postsAtCragStream` and the security rules already written in the README. Both are launch blockers that just need deployment.

### Growth

**Push Notifications** `[L]`
New message, coalition event at a favorited crag, post expiry reminder.
*Depends on: FCM setup, notification permission flow*

**User-Submitted Crags** `[M]`
`Crag.createdBy` field exists. Build a submit form. Admin-review before publishing (lightweight: manual approval via Firestore console).

**Experience Filter on Board** `[S]`
Filter chips on the bulletin board: Beginner / Intermediate / Advanced / Expert.

**Weather per Crag** `[M]`
One-day forecast using Open-Meteo (free API, no key required). Show on crag detail header.

**Social Auth (Google / Apple)** `[M]`
Email/password is a conversion killer. Google + Apple sign-in should be primary options.

**Post Reactions** `[S]`
"+1 I'll be there" on a post. Lower friction than opening a conversation with a stranger.

---

## FUTURE — Research Needed

These need more definition before scoping.

- **Route database within crags** — Big scope, possible partnership with Mountain Project or 27crags
- **Group climbing requests** — "Looking for 2-3 people for a multi-pitch day"
- **User ratings / trust signals** — Vouching system between climbers who have climbed together
- **Photo uploads for crags / posts** — Crag hero photos, post attachments
- **Social graph** — Follow users, activity feed. Deliberate choice to avoid this unless there's clear demand.
- **Offline mode** — Cache crag + board data for areas with poor cell service (common at crags)
- **App Store launch** — Trademark check on "Belay Buddy" before investing in store assets

---

## Data Models Needed for Upcoming Features

| Model | Needed For | Status |
|---|---|---|
| `Gym` | Gym venue type | Not started |
| `GymEvent` | Gym events | Not started |
| `LostFoundPost` | Lost & Found per crag | Not started |
| `Coalition` | Climbing coalitions | Not started |
| `CoalitionEvent` | Coalition events (clinics, crag care days) | Not started |
| `ClaimRequest` | Gym + coalition claiming flow (shared) | Not started |

---

## Open Questions

1. **Gym verification** — Who approves gym claims at launch? Manual (you via Firestore console) or an in-app admin panel? Manual is fine for MVP.
2. **Coalition verification** — Same question. Manual is the right call until volume demands automation.
3. **Crag coverage** — 8 seeded crags is not enough for launch. Plan to either import a public database or build user submission flow before going public.
4. **Public vs. auth-required boards** — Should boards be readable without logging in? Recommendation: yes, to support sharing links from Mountain Project / Instagram. Require auth to post.
5. **Post expiry notification** — "Your post expired — still at the crag?" This re-engagement hook could drive stickiness. Plan it alongside push notifications.
