# Belay Buddy — Product Specification

**Version:** 0.1 (Pre-launch)
**Status:** Functional MVP skeleton — core post creation and bulletin board work; messaging, profile, and search are stubbed out with snackbars
**Last updated:** 2026-03-11

---

## 1. Executive Summary

Belay Buddy is a mobile app (Flutter/iOS/Android) that solves one of outdoor climbing's most persistent logistics problems: showing up to a crag alone and not knowing who else is there or who needs a partner.

The core mechanic mirrors what already happens organically at real climbing areas — a physical bulletin board where climbers pin notes saying "here today, need belay." Belay Buddy digitizes that board, attaches it to a map of real crags, and lets climbers coordinate before they leave the trailhead.

**Who it's for:** Anyone climbing outdoors who wants to find partners at a specific crag on a specific day. This covers gym climbers venturing outside for the first time (who desperately need a belay partner), solo trip planners, and regular crag locals who want to broadcast availability.

**Core value proposition:** Zero-friction partner discovery tied to real location, not generic social media. You open the app, find your crag, see who's going, post your own note, and connect. That's it. No feed, no algorithm, no follower count.

**What makes it distinct:** The bulletin board metaphor is physically familiar to every climber who has used a real crag board. The visual design (cork background, paper cards, push pins, immediate vs. planned badges) earns trust and comprehension instantly because it maps to real-world mental models.

---

## 2. User Personas

### Persona 1: Maya — Gym Rat Going Outside

**Age/background:** 24, climbs 4x/week at her local gym, leads 5.11 indoors. Has done two outdoor trips with friends but has never been to a crag alone.

**Situation:** She wants to visit Red Rock Canyon for a weekend but her usual climbing partner is busy. She's nervous about going solo — she can lead, but she needs someone to belay and doesn't know anyone who climbs there regularly.

**What she needs:**
- A way to post "I'll be at Red Rock Saturday, 9am, can lead 5.10, need belay"
- To see who else will be there and whether they match her level
- Enough info to feel safe meeting a stranger (experience level, climbing style)
- A way to message that person before showing up

**Pain points without the app:** Posts in generic Facebook groups get buried; Mountain Project forums are slow; she has no idea who will actually be there.

**Success:** She connects with someone, they trade messages beforehand, and she has a belay partner waiting at the parking lot.

---

### Persona 2: Dave — Seasoned Trad Climber, Crag Regular

**Age/background:** 38, climbs trad up to 5.12, has been going to New River Gorge for 15 years. Usually climbs with a regular crew but they've scattered across different states.

**Situation:** He shows up at NRG on a Tuesday and wants to find someone to climb with. He's not looking to babysit a beginner — he wants a competent second who can clean gear on moderate routes.

**What he needs:**
- To quickly broadcast "here today, experienced, can lead and belay" to the crag's active community board
- To filter or skim posts for experience level before committing to contact someone
- Minimal friction — he's at the crag, not at his desk. Fast post creation and reading

**Pain points:** He doesn't want a social network. He wants to glance at a board, see if anyone useful is around, and move on. Over-engineered apps lose him immediately.

**Success:** Posts take under 60 seconds. He finds a compatible climber within the day, they link up, no wasted trip.

---

### Persona 3: Keiko — Trip Planner

**Age/background:** 31, climbs 5.10 sport and boulders. She organizes climbing trips for a loose friend group, usually 3-4 people going to a destination area for a week.

**Situation:** Planning a trip to Joshua Tree 3 weeks out. Two spots in the group are open. She wants to find additional partners at the destination who know the area, and she wants to scope out the scene before arriving.

**What she needs:**
- The ability to post a "scheduled" availability notice well in advance ("We'll be at Joshua Tree, March 20-27, looking for locals who know the area")
- To see recent activity on a crag's board to gauge how busy it typically is
- To coordinate across multiple crags she's planning to visit
- Ideally, to add crags to a "favorites" list so she can monitor boards as the trip approaches

**Pain points:** Planning across multiple apps (Facebook, Mountain Project, email) is fragmented. She wants one place to post, monitor, and respond.

**Success:** She connects with 1-2 locals at J-Tree before the trip, her group has better beta and a richer experience.

---

## 3. Core User Journeys

### Journey 1: Post Your Availability at a Crag (Primary)

This is the single most important action. Everything else is secondary.

1. User opens app, sees map centered on their current location (or last location)
2. User locates their target crag on the map (orange marker) or searches by name
3. User taps the crag marker — sees the community bulletin board with active posts
4. User taps the FAB ("Post Availability") — **this currently does nothing; shows a snackbar**
5. User selects "Today/Now" or "Scheduled"
6. If scheduled: picks date/time from a date picker (up to 30 days out)
7. User enters a title (e.g., "Need belay partner, sport climbing") and optional description
8. User checks belay status: "I need a belay" and/or "I can belay"
9. User taps "Post to Board" — post appears immediately on the crag's bulletin board as a pinned card
10. Other users see the post in real time via Firestore streaming

**Current state:** Steps 4-9 work end-to-end when navigated to from `CragDetailScreen`. However, the FAB on `MapScreen` is broken (snackbar-only). The `CragDetailScreen` has no FAB or "Post" button, so users can only create posts if they know to navigate to `CreatePostScreen` directly — there is no in-app way to reach `CreatePostScreen` from the current UI.

**Critical gap:** The create post flow is fully built but unreachable from the UI.

---

### Journey 2: Find and Contact a Climbing Partner

1. User opens app, navigates to their target crag on the map
2. Taps crag marker, arrives at the bulletin board
3. Scans post cards — sees user names, post timing, belay status chips
4. Spots a compatible post — taps the card
5. **Expected:** Open a user profile or start a conversation
6. **Actual:** A debug snackbar appears showing `Contact {userId}` (the raw Firebase UID, not the user's display name) — this is a broken/embarrassing dead end

**Critical gap:** There is no way to actually contact another climber. The conversation data model and Firestore service are fully built, but there is zero UI for messaging.

---

### Journey 3: Sign Up and Set Up Profile

1. User downloads app, opens to login screen
2. Enters email and password, taps "Sign Up"
3. Firebase creates auth account; user is redirected to the map
4. **Expected:** Prompted to complete profile — display name, experience level, climbing styles
5. **Actual:** User lands directly on the map with no profile. Their display name is never collected. The `AppUser` document is never created in Firestore.

**Critical gap:** Sign-up creates a Firebase Auth user but no Firestore `AppUser` document. Every `PostCard` that tries to display the poster's name via `userByIdProvider` will show "Unknown" for every post until a user profile is created — and there is currently no profile creation screen.

---

## 4. Feature Inventory

### What Currently Works (Verified in Code)

| Feature | Status | Notes |
|---|---|---|
| Email/password sign up | Working | No display name collection |
| Email/password sign in | Working | |
| Auth state management (Riverpod) | Working | |
| Auto-redirect based on auth state | Partially broken | `initialLocation` hardcoded to `/map`, bypassing auth |
| Map with crag markers (Google Maps) | Working | Terrain view, orange markers |
| Real-time crag loading from Firestore | Working | Stream-based |
| Tap crag marker → crag detail | Working | |
| Crag detail / bulletin board screen | Working | Good UI with cork board aesthetic |
| Real-time post streaming per crag | Working | Filtered by expiry |
| Post card UI (paper note aesthetic) | Working | Push pins, rotation, color-coded by type |
| Post expiry (12h now / 2h past scheduled) | Working | Server-side filter on `expiresAt` |
| Post creation form | Working | Title, description, date/time, belay status |
| Post submit to Firestore | Working | |
| Belay status display (Need/Can Belay chips) | Working | |
| NOW vs. PLANNED badge | Working | |
| User name on post card | Broken | Shows "Unknown" — Firestore user doc never created on signup |
| Conversations data model | Built, not wired | Full CRUD in FirestoreService |
| Messages data model | Built, not wired | Full CRUD in FirestoreService |
| Bottom nav bar (Map/Posts/Messages) | Stub | Posts and Messages tabs show snackbars |
| FAB on map screen ("Post Availability") | Stub | Shows snackbar only |
| Search button on map screen | Stub | Shows snackbar only |
| Profile menu item | Stub | Shows snackbar only |
| User profile screen | Missing | No screen exists |
| Messaging / chat screen | Missing | No screen exists |
| Tap post card → contact user | Broken | Shows raw userId in snackbar |
| Favorites / saved crags | Data model only | `favoriteCragIds` in AppUser, no UI |
| User-submitted crags | Data model supports it | `createdBy` field in Crag, no UI |
| Post deletion | Service only | No UI for users to delete own posts |
| Push notifications | Not started | |
| Dark mode | Theme defined | Not validated |

### Known Bugs

1. **Auth bypass:** `initialLocation: '/map'` in `_router` hardcodes app startup to the map screen, completely skipping the `AuthGate`. Any unauthenticated user can browse the map and board; tapping "Post" will fail silently with a null `userId` check, but the UX is confusing.

2. **No user profile creation:** `LoginScreen` calls `FirebaseAuth.createUserWithEmailAndPassword` but never calls `FirestoreService.createUser`. Display names are never collected. Every `PostCard` will show "Unknown" as the poster's name for all users.

3. **CreatePostScreen is unreachable from the UI:** The screen exists and works, but there is no navigation path to it from the live app. The map FAB shows a snackbar; `CragDetailScreen` has no FAB or button to navigate to `CreatePostScreen`.

4. **Tap post card = raw UID snackbar:** `onTap` in `CragDetailScreen` reads `Contact ${post.userId}`, which prints the Firebase UID string. This would be embarrassing in front of a real user.

5. **`postsAtCragStream` Firestore query ordering bug:** The query uses `.orderBy('expiresAt').orderBy('dateTime')` after a `where` filter. Firestore requires a composite index for this combination. Without it deployed to Firebase, this query will fail with an index error in production for any crag with more than one post. The README does not mention this index requirement.

6. **`cragProvider` is not a real stream:** It uses `async*` with a single `yield` from a one-shot `getCrag()` call. It will not update if the crag document changes in Firestore. Should use `cragsStream()` scoped to a single document.

7. **DateTime formatting shows negative time for past posts:** `_formatDateTime` in `PostCard` uses `dateTime.difference(now)`, which returns a negative duration for posts where `dateTime` is in the past (e.g., an "immediate" post from 2 hours ago). This would display "in -120m" rather than "2h ago."

8. **No Firestore security rules deployed:** README calls them out as TODO. With no rules, any authenticated user can read/write any document.

---

## 5. MVP Definition

The minimum viable product that could be handed to a real climber at a crag and not embarrass the product:

### MVP Must-Have (Blocking)

1. **User profile creation on signup** — collect display name, experience level, climbing style at minimum. Create the `AppUser` Firestore document. Without this, all post cards show "Unknown."

2. **Reachable post creation flow** — wire the map FAB or crag detail screen to `CreatePostScreen`. The form already works; it just needs a navigation entry point.

3. **Post card tap → messaging** — when a user taps a post card, open a conversation. Even a minimal chat screen (text input + message list) is sufficient. The service layer is already built.

4. **Fix auth flow** — remove the `initialLocation: '/map'` hardcode. Unauthenticated users should land on the login screen.

5. **Fix "Unknown" display name** — dependent on item 1 above.

6. **Fix negative time display** — handle past `dateTime` values gracefully in `_formatDateTime`.

### MVP Nice-to-Have (Not Blocking)

- Basic user profile view (tappable from post card)
- Delete own post
- "My Posts" tab (data is available via `userPostsProvider`)
- Firestore security rules deployed

### Explicitly Out of Scope for MVP

- Push notifications
- Weather integration
- Route database
- Photo uploads
- Social graph (followers/friends)
- User-submitted crags
- Search by location radius
- Group climbing requests
- Ratings/verification

---

## 6. Prioritized Feature Backlog

### P0 — Ship Blockers (must fix before anyone uses this)

| # | Feature | Rationale |
|---|---|---|
| P0-1 | Profile setup screen on signup | Every post shows "Unknown." The app is nonfunctional for its core promise without names. |
| P0-2 | Wire post creation to UI | The most important action in the app is unreachable. Fix the map FAB to navigate to `CreatePostScreen` with crag context, or add a FAB on `CragDetailScreen`. |
| P0-3 | Minimal messaging screen | Tapping a post card currently shows a raw UID. This is the second most important action and it crashes the experience. Build a basic chat view using the existing service layer. |
| P0-4 | Fix auth bypass | Remove `initialLocation: '/map'`. Unauthenticated users should not land on the main screen. |
| P0-5 | Fix negative time formatting | "in -120m" is confusing and erodes trust. |
| P0-6 | Deploy Firestore security rules | The README already has the rules written. They just need to be deployed. Without this, any user can delete any other user's posts. |

### P1 — Core Experience (first 30 days after fixing P0)

| # | Feature | Rationale |
|---|---|---|
| P1-1 | User profile view | When you tap a poster's name/avatar on a post card, show their profile: experience level, climbing styles, member since. This is the trust-building layer that converts a board browse into a real connection. |
| P1-2 | Delete own post | Climbers plans change constantly. A climber who can't remove their "here today" post after they leave creates stale data and erodes board trustworthiness. |
| P1-3 | Crag search / name filter | The map starts at Red Rock Canyon. A user in Kentucky looking for New River Gorge has to pan manually. A simple name-based search input resolves this. This is currently a stub button in the app bar. |
| P1-4 | "My Posts" tab | The bottom nav "Posts" tab is already present and `userPostsProvider` is already wired. Show the user their active posts with an option to delete. One screen, already has data. |
| P1-5 | Messages tab | The bottom nav "Messages" tab is present but dead. Connect it to `userConversationsStream`. Show conversation list → tap to open chat. Service layer exists. |
| P1-6 | Unread message badge | Once messaging exists, users need to know when they have a new message without polling the app. A badge count on the Messages tab is the minimum. |
| P1-7 | Composite Firestore index | Fix the compound query bug in `postsAtCragStream`. Deploy the required index or simplify the query to avoid the requirement. |
| P1-8 | "Map to me" — user location on load | The map defaults to Red Rock Canyon. It should center on the user's current location if permission is granted, falling back to a broad US view. `myLocationEnabled: true` is already set on the map widget; this is a one-line `geolocator` call to center the camera. |

### P1.5 — New Venue & Community Features

These were scoped in alongside the core experience and should be planned in parallel once P0/P1 are stable.

#### Gyms

Gyms are a distinct venue type from crags with a different ownership and content model.

| # | Feature | Notes |
|---|---|---|
| G-1 | Gym data model + map markers | `Gym` model: name, address, coordinates, ownerUserId (nullable), claimedAt, verified. Different map marker color/icon from crags. |
| G-2 | Gym detail screen | Similar to crag detail but with gym-specific sections: hours, events, bulletin board for partner posts. Less anonymous than crag boards. |
| G-3 | Gym claiming flow | Any user can suggest a gym. Gym owners can submit a claim request (name, email, role). Admin verifies and assigns `ownerUserId`. Claimed gyms get an "Official" badge. |
| G-4 | Gym events | Claimed gyms can post events: comps, clinics, crag days, intro classes. Event model: title, description, date/time, capacity (optional), RSVP link (optional). |
| G-5 | Gym partner posts | Same `ClimbingPost` model reused, linked to a `gymId` instead of `cragId`. |

#### Lost & Found (per Crag)

Each crag gets a Lost & Found section alongside its community board.

| # | Feature | Notes |
|---|---|---|
| L-1 | `LostFoundPost` model | Fields: `id`, `cragId`, `userId`, `type` (lost/found), `itemCategory` (shoes/harness/draws/cam/clothing/other), `title`, `description`, `contactInfo`, `resolvedAt` (nullable), `createdAt`. |
| L-2 | Lost & Found tab on crag detail | Tab bar on `CragDetailScreen`: "BOARD" (existing) and "LOST & FOUND". Tab UI uses the same Neobrutalist card aesthetic. |
| L-3 | Post lost/found item | Simple form: Lost or Found toggle, item category, description, how to contact. No expiry — persists until user marks as resolved. |
| L-4 | Mark as resolved | Post owner can mark their item as found/returned. Resolved posts collapse or move to a "Resolved" archive section. |

#### Climbing Coalitions

Local coalitions (Access Fund chapters, climbing clubs, stewardship orgs) get a verified presence in the app to post community events.

| # | Feature | Notes |
|---|---|---|
| C-1 | `Coalition` model | Fields: `id`, `name`, `region`, `description`, `website`, `contactEmail`, `adminUserIds[]`, `verifiedAt`. |
| C-2 | Coalition profile screen | Name, description, region, link to website, list of upcoming events. |
| C-3 | Coalition event model | `CoalitionEvent`: title, description, type (`clinic` / `cragCareDay` / `meeting` / `other`), date/time, location (crag link or address), coalitionId, rsvpUrl (optional). |
| C-4 | Post coalition events | Coalition admins can create events. Events appear on the relevant crag's board (if linked to a crag) AND on a global coalition events feed. |
| C-5 | Coalition events on map | Crags with upcoming coalition events get a visual indicator on their map marker (small calendar badge). |
| C-6 | Coalition claiming/admin | Coalition admins request verification with org name + contact. Admin approves and grants `adminUserIds`. Same flow as gym claiming. |

### P2 — Growth & Depth (post-launch, first 90 days)

| # | Feature | Rationale |
|---|---|---|
| P2-1 | Push notifications | Without notifications, users have no reason to re-open the app after posting. A message notification is a direct re-engagement trigger. |
| P2-2 | Favorite crags | `favoriteCragIds` is in the AppUser model. Let users star crags for quick access. Supports the trip planner persona heavily. |
| P2-3 | Active climber count on map markers | Show the post count as a badge on the map marker (e.g., "3 climbers today") so users know which crags are active before tapping. The Crag model has `activeClimbersCount` — just wire it. |
| P2-4 | User-submitted crag additions | The Crag model has a `createdBy` field. Power users in less-covered areas will churn without their local crags. Build a lightweight submit form; admin-review before publishing. |
| P2-5 | Experience level filter on posts | Dave (persona 2) doesn't want to read 10 posts before finding someone at his level. A simple filter chip on the board view (Beginner / Intermediate / Advanced / Expert) makes the board useful at scale. |
| P2-6 | Post reactions / "+1 I'll be there" | A lightweight way to indicate interest in a post without opening a full conversation. Reduces the social friction of initiating direct message with a stranger. |
| P2-7 | Weather widget per crag | Outdoor climbing is weather-dependent. A one-day forecast at crag elevation (Open-Meteo has a free API) would be a unique differentiator and drive daily app opens. |
| P2-8 | Photo uploads for crags | Crags with just a gradient background look generic. Let users contribute a hero photo. Firebase Storage is already in the stack. |
| P2-9 | Social auth (Google/Apple) | Email/password is a signup conversion killer for a casual app. Google and Apple sign-in should be the primary options with email/password as fallback. |

---

## 7. UX Gaps

### Gap 1: The App Is a Dead End After Sign-Up

A new user signs up, lands on the map, and has no guidance on what to do. There is no onboarding flow, no empty state prompt, no tooltip. The FAB says "Post Availability" but tapping it does nothing. The search icon does nothing. The profile menu item does nothing. A first-time user who isn't already familiar with the concept will close the app within 30 seconds.

**Fix:** Add a one-time onboarding overlay (3 screens max: "Find a crag, see who's climbing, post your availability"). Or at minimum, fix the FAB so it actually works.

### Gap 2: Post Cards Show "Unknown" For Every User

Because profile creation is skipped at signup, the user lookup in `PostCard` (`userByIdProvider`) always returns null for the poster's name and falls back to "Unknown." The first-letter avatar shows "?" This makes the bulletin board look broken rather than empty.

**Fix:** Gate on P0-1 (profile creation). Until fixed, every post card on the board is anonymized and the app looks like it has a bug.

### Gap 3: No Way to Close / Return from Crag Detail

`CragDetailScreen` uses a `SliverAppBar` that shows the back button (via Navigator's default back arrow) on iOS. On Android, back is handled by the system button. However, there is no explicit back action or close affordance visible in the collapsed app bar state (when the header is scrolled away and only the crag name remains). On Android devices without gesture navigation, a user who scrolls to the bottom of a long board has no visible way back.

**Fix:** Ensure the app bar always renders a back button in pinned state, or add a visible "Back to Map" action.

### Gap 4: Tapping a Post Card Is a Dead End

Tapping any post card shows a SnackBar with the poster's raw Firebase UID. This is a developer artifact left in production code. A user who taps a card to contact someone sees `Contact abc123xyz456` — no name, no action. It looks like a crash.

**Fix:** P0-3 (messaging screen). Until then, remove the SnackBar or replace it with a disabled state and placeholder text ("Messaging coming soon").

### Gap 5: Map Starts at Red Rock Canyon, Not the User's Location

Every user who opens the app sees a map centered on Las Vegas, NV. A climber in North Carolina looking for New River Gorge has to pan the entire country. With only 8 seeded crags and no search, this is acceptable now but will be an immediate point of friction at scale.

**Fix:** Center the map on the user's location on first load if permission is granted (P1-8). Add crag search (P1-3).

### Gap 6: No Feedback After Creating a Post

After a user successfully creates a post and taps "Post to Board," the app pops back to the previous screen and shows a green SnackBar. But if the user tapped "Post Availability" from the map (which they can't currently do), they'd land back on the map with no indication that their post is live. There is no confirmation state or "view my post" action.

**Fix:** After successful post, navigate to the relevant `CragDetailScreen` and scroll to the user's new post, or show a more persistent confirmation with a "View Board" button.

### Gap 7: Both "Need Belay" and "Can Belay" Can Be Checked Simultaneously

The `CreatePostScreen` has two independent checkboxes: "I need a belay partner" and "I can belay someone." A user can (and likely will by accident) check both. A post that reads both "Need Belay" and "Can Belay" is contradictory and confusing. On the data model side, `needsBelay: true, offeringBelay: true` is a valid state.

**Fix:** Make belay status a radio group or segmented button: "Need Belay" / "Can Belay" / "Either / Just climbing." This also reduces form cognitive load.

### Gap 8: Post Title Field Has No Guidance

The title hint text is `"e.g., 'Looking for partner'"`. This is too generic. Climbers will leave titles like "Hey" or "climbing today." The title is the primary thing other users scan on the board. Better hint text should encode the most useful info: experience level, style, and time. Example: `"e.g., '5.10 sport, need belay, 9am Saturday'"`.

### Gap 9: No Empty State on the Map

If Firestore returns zero crags (network issue, seeding not done), the map renders as a blank terrain view with no explanation. The error state covers a full Firestore error, but a successful empty list yields no markers and no prompt. A new developer setting up the app would see a blank map and not know why.

**Fix:** Show an overlay on the map if `crags.isEmpty`: "No crags loaded yet. Have you seeded the database?" (debug build only) or a user-facing "Exploring a new area? Add a crag" CTA.

---

## 8. Success Metrics

### North Star
**Weekly Active Pairs:** The number of unique user pairs who exchange at least one message per week. This is the only metric that proves the app is actually connecting people, not just generating posts that go unanswered.

### Acquisition
- App store installs per week
- Signup conversion rate (installs → created account)
- Profile completion rate (accounts → completed AppUser with displayName + experienceLevel)

### Engagement
- Posts created per week per active crag
- Boards viewed per session (map tap-throughs to CragDetailScreen)
- DAU/WAU ratio (stickiness — target >30% for a utility app)

### Core Loop Completion
- **Post-to-contact rate:** % of posts that receive at least one message tap. Target >20% initially.
- **Post-to-reply rate:** % of initiated conversations that receive a reply within 24 hours. This is the real trust signal.
- **Session-to-post rate:** % of sessions where a user creates a post. This measures whether the core action is discoverable.

### Retention
- D1, D7, D30 retention (target D7 >25% for a social-utility hybrid)
- Return visit rate on trip days (users who post a "Today/Now" and return to the app within 12 hours)

### Quality
- Expired post rate (posts that expire without any contact) — a high rate means the board is one-directional and not generating connections
- Crag coverage (% of the top 100 US crags by traffic that have had at least one post in the past 30 days)

---

## 9. Open Questions

### Product Decisions

1. **Is authentication required to browse boards?** Currently the auth bypass means unauthenticated users can read the map. Should boards be public-read? Making boards readable without an account improves discoverability (links shared on Mountain Project, Instagram) but may reduce signup conversion. Recommend: public read, auth required to post.

2. **How should belay matching work?** The current model flags individual need/offer status, but there's no matching logic. Should the app surface "compatible" posts (someone who needs belay + someone offering belay at the same crag and time)? Or is the raw board browse sufficient for MVP?

3. **Should crags be community-editable or admin-curated?** 8 seeded US crags does not cover the actual climbing population. Who controls crag data? User-submitted with moderation? Imported from Mountain Project's API? This is a content strategy decision that needs resolution before launch. Mountain Project's API is rate-limited and may have licensing considerations.

4. **What is the target geography at launch?** A US-only launch with the 8 seeded crags is too thin. The app needs either (a) a robust user-submission flow for crags, (b) an import of a public crag database, or (c) a hyper-focused launch at 2-3 crags with a known climbing community to drive initial density.

5. **What happens when a post expires?** Currently, expired posts are just filtered out of queries. Should users receive a notification "Your post expired — still at the crag?" to prompt re-engagement? Automatic expiry is a core feature but the current implementation is silent.

6. **How should the app handle climbing style mismatch?** A 5.14 trad climber and a gym beginner both show up on the same board. The current design surfaces no compatibility signals beyond experience level and climbing style tags. Should the app warn or sort by compatibility?

### Technical Decisions

7. **Composite Firestore index:** The `postsAtCragStream` query on `(cragId, expiresAt, dateTime)` requires a composite index. This must be created in the Firebase console (or via `firestore.indexes.json`) before the query works with more than one result. This is a launch blocker that is not documented.

8. **`cragProvider` is not reactive:** It uses a one-shot future wrapped in `async*`. If crag data changes (e.g., `activeClimbersCount` updates), the provider will not re-emit. Should be refactored to use `_firestore.collection('crags').doc(cragId).snapshots()`.

9. **No error reporting / analytics:** There is no Crashlytics or analytics integration. Crashes in production will be invisible. This should be added before any real users are onboarded.

10. **App name / App Store presence:** "Belay Buddy" is a common phrase in climbing circles. There may be trademark considerations before a public launch. Worth a quick search before investing in App Store assets.

11. **Post volume and cost:** With real-time Firestore streams on every crag board view, each active board viewer is holding an open listener. At scale (e.g., 500 users all viewing the Red Rock Canyon board on a Saturday), this generates significant Firestore read volume. Consider pagination or a pull-to-refresh model for boards with high post volume.

---

*This document reflects the state of the codebase as of March 2026. It is intended to guide development toward a functional prototype suitable for real-world testing at a climbing area.*
