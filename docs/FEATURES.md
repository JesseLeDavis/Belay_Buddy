# Belay Buddy — Feature Documentation

This document describes each implemented feature: what it does, what files own it, the data model, and what's still pending. Update this as features graduate from stub to full implementation.

---

## Map Screen

**File:** `lib/screens/home/map_screen.dart`

**What it does:**
- Google Maps terrain view showing all crags and gyms as custom markers
- Orange square pin markers for outdoor crags; blue square pin markers for gyms
- Marker icons are drawn programmatically via `Canvas` / `ui.PictureRecorder` (no image assets)
- Map panel collapses to 220px at the top; tap the expand strip to go full-screen
- Below the map: a scrollable list of all venues with GYM / CRAG header strip, name, region, and type chips
- List header shows "X CRAGS · Y GYMS" count

**Key providers:** `allCragsProvider`

**Marker drawing:** `lib/utils/map_markers.dart` — `buildCragMarker()`, `buildGymMarker()`

**Pending:**
- Search / name filter (search icon in app bar is a stub snackbar)
- Map centering on user's current location
- Active climber count badge on markers

---

## Crag / Gym Detail Screen

**File:** `lib/screens/crag/crag_detail_screen.dart`

**What it does:**
- `SliverAppBar` with crag name; green background for crags, blue for gyms
- **Crag info section:** region, type chips, description, home base row (see Home Base below)
- **Lost & Found Bin panel:** amber header, FOUND/LOST count badges, 2-item preview, footer tap → LostFoundScreen
- **Community Board panel:** orange header with "X THIS WEEK" badge, 7-day heatmap strip, 2-post preview, footer tap → CragScheduleScreen
- **FAB** opens `_PostTypeSheet` with two options: Partner Session or Lost & Found
- Tapping a post preview opens `PostDetailSheet` — full post info, user snippet, MESSAGE + CONNECT buttons

**Key providers:** `cragProvider`, `postsAtCragProvider`, `lostFoundAtCragProvider`, `postCountsByDateProvider`, `homeMemberCountProvider`, `homeSettingsProvider`, `isConnectedProvider`, `currentUserIdSyncProvider`

**Sub-widgets (file-private):**
- `_CountBadge` — small colored label chip
- `_PanelFooter` — tappable footer row with label
- `_LostFoundPreviewRow` — single lost/found item row
- `_PostPreviewRow` — single post row (ConsumerWidget, watches `userByIdProvider`)
- `_PostTypeSheet` — branching sheet for post type selection
- `PostDetailSheet` — full post detail (exported, used elsewhere)
- `_PostActionButtons` — MESSAGE + CONNECT button pair
- `_HomeBaseSheet` — home base settings sheet (see Home Base section)
- `_SheetTile` — labeled toggle row used inside `_HomeBaseSheet`

---

## 7-Day Heatmap Strip

**File:** `lib/widgets/heatmap_strip.dart`

**What it does:**
- Horizontal 7-day strip: today's date through 6 days prior
- Each day shows: day letter (M/T/W etc.), day number, colored dot
- Dot colors scale with post count:
  - 0 posts → grey (`textDisabled`)
  - 1 post → `sageLight`
  - 2 posts → `oliveGreen`
  - 3+ posts → `dullOrange`
- Today gets a darkNavy border
- Full strip is one tap target (navigates to CragScheduleScreen)

**Data:** `postCountsByDateProvider(cragId)` — `Provider.family<Map<DateTime, int>, String>`

---

## Partner Posts

**Files:** `lib/models/climbing_post.dart`, `lib/screens/crag/create_post_screen.dart`

**Model fields:**
| Field | Type | Notes |
|---|---|---|
| `id` | String | |
| `userId` | String | |
| `cragId` | String | |
| `title` | String | |
| `description` | String? | |
| `dateTime` | DateTime | |
| `type` | `PostType` | `immediate` or `scheduled` |
| `needsBelay` | bool | |
| `offeringBelay` | bool | |
| `expiresAt` | DateTime? | |
| `createdAt` | DateTime? | |
| `isExpired` | bool | Set by Cloud Function (planned) |

**Post types:**
- `immediate` — "Climbing now / today"; expires 12h from creation
- `scheduled` — Future date/time; expires 2h after scheduled time

**Create flow:**
1. Crag detail FAB → `_PostTypeSheet` → "Partner Session"
2. Navigates to `CreatePostScreen` via `context.push('/crag/:id/post', extra: crag)`
3. Form: NOW/PLANNED toggle, date picker (if PLANNED), title, description
4. Submit is mocked (snackbar); no Firestore write yet

**Pending:**
- Party size field
- Belay status toggles (currently removed from form; fields exist on model)
- Wire submit to Firestore

---

## Lost & Found

**Files:** `lib/models/lost_found_item.dart`, `lib/screens/crag/lost_found_screen.dart`

**Model fields:**
| Field | Type | Notes |
|---|---|---|
| `id` | String | |
| `cragId` | String | |
| `userId` | String | |
| `status` | `LostFoundStatus` | `found` or `lost` |
| `category` | `LostFoundCategory` | gear, clothing, personalItem, rope, other |
| `itemName` | String | |
| `description` | String? | |
| `locationNote` | String? | e.g. "Base of Calico Basin wall" |
| `isResolved` | bool | |
| `createdAt` | DateTime? | |

**Current state:**
- Preview rows on crag detail panel work (FOUND/LOST badge, category, item name, time ago)
- `LostFoundScreen` is a stub showing "COMING SOON"

**Pending (LostFoundScreen full implementation):**
- Filter tabs: ALL / FOUND / LOST
- Full `LostFoundCard` widget
- Item detail bottom sheet with "Mark as Resolved" for post owner
- Create form accessible from FAB → Lost & Found path

---

## Community Board / Schedule Screen

**File:** `lib/screens/crag/crag_schedule_screen.dart`

**Current state:** Stub showing "COMING SOON"

**Planned:**
- Full session list (all upcoming posts at this crag, sorted by date)
- Day filter bar — tap a day to filter the list
- Each row: partner name, belay status, time, MESSAGE + CONNECT CTA
- Week/month toggle for heatmap view

---

## Connections

**Files:** `lib/screens/profile/find_climbers_screen.dart`, `lib/screens/profile/notifications_screen.dart`, `lib/models/climbing_notification.dart`

### Find Climbers Screen
- Lists all users except the current user
- Per card: avatar (color-coded by experience level), display name, experience badge, bio, style chips
- Connection button states:
  - **CONNECT** (blue, hard shadow) — sends request, triggers snackbar
  - **PENDING** (grey) — request already sent or incoming
  - **CONNECTED** (green, checkmark) — already connected

### Notifications Screen
- Grouped sections: NEW (unread) and EARLIER (read)
- Three notification types:
  - `catchNeeded` — "X needs a catch at [Crag]" — orange icon, VIEW → crag button
  - `connectionRequest` — "X wants to connect" — blue icon, ACCEPT toggle (local state)
  - `connectionAccepted` — "X accepted your request" — green icon
- Reachable from bell icon on Profile AppBar

**Model:** `ClimbingNotification`
| Field | Type |
|---|---|
| `id` | String |
| `toUserId` | String |
| `fromUserId` | String |
| `fromUserName` | String |
| `type` | `NotificationType` |
| `postId` | String? |
| `cragId` | String? |
| `cragName` | String? |
| `isRead` | bool |
| `createdAt` | DateTime? |

**AppUser connection fields:**
- `connectionIds: List<String>` — confirmed connections
- `pendingConnectionIds: List<String>` — incoming requests not yet accepted

**Key providers:**
- `connectionsProvider` — confirmed connections list
- `pendingConnectionRequestsProvider` — incoming requests
- `discoverableUsersProvider` — all users except current
- `isConnectedProvider(userId)` — bool
- `hasPendingRequestFromProvider(userId)` — bool
- `notificationsProvider` — all notifications for current user
- `unreadNotificationCountProvider` — int for badge

**Notification badge:** Shown on profile tab AppBar. Orange square with white number. Disappears when count is 0.

**Post detail sheet integration:** `_PostActionButtons` on `PostDetailSheet` shows MESSAGE (always) + CONNECT (if not already connected, not own post).

**Pending:**
- Accept/decline actually updates user data (currently local state only)
- Notification `isRead` actually marks as read on open

---

## Home Base

**File:** `lib/screens/crag/crag_detail_screen.dart` (inline `_HomeBaseSheet`, `_SheetTile`)
**Provider/notifier:** `lib/mock/mock_providers.dart` (`HomeSettingsNotifier`, `homeSettingsProvider`, `homeMemberCountProvider`)

**What it does:**
- Each user can designate one home crag and one home gym
- Home Base row on crag/gym detail shows member count and set/unset state
- Tapping opens `_HomeBaseSheet`

### Home Base Sheet
Four settings:

| Setting | Description |
|---|---|
| **Set / Unset as home** | Toggle whether this is your home location; other three settings dim when off |
| **Visible to others** | Public (your name shows in member list) vs. private (hidden but still counted) |
| **Notify: catch needed** | Alert when someone at this location posts they need a belay |
| **Notify: new connections** | Alert when someone new sets this location as their home |

**Member count logic:**
- `homeMemberCountProvider(cragId)` counts all users with `homeCragId == cragId` OR `homeGymId == cragId`
- Counts include private members (visibility only affects name display, not the total)
- Count reacts to the current session: if you set/unset this location as home mid-session, the count updates immediately via `HomeSettingsNotifier`

**AppUser fields:**
| Field | Default |
|---|---|
| `homeGymId` | `null` |
| `homeCragId` | `null` |
| `isHomeVisible` | `true` |
| `notifyHomeCatch` | `true` |
| `notifyHomeConnections` | `false` |

**`HomeSettings` (in-session state):**
`HomeSettingsNotifier` is a `StateNotifier<HomeSettings>` seeded from the mock current user on app start. Methods: `setHomeCragDirect(id?)`, `setHomeGymDirect(id?)`, `toggleVisibility()`, `toggleNotifyHomeCatch()`, `toggleNotifyHomeConnections()`.

**Pending:**
- Persist changes to Firestore when Firebase is active
- Show visible home member avatars/names in a list on the sheet

---

## Favorites

**Model fields on `AppUser`:**
- `favoriteCragIds: List<String>`
- `favoriteGymIds: List<String>`

**Providers:**
- `isFavoriteCragProvider(cragId)` — bool
- `isFavoriteGymProvider(gymId)` — bool

**Current state:** Model and providers exist. No UI wired yet.

**Pending:**
- Favorite toggle button on crag/gym detail screen
- Favorited venues surfaced at top of map list
- Favorites section on profile

---

## Messaging

**Files:** `lib/screens/messages/messages_screen.dart`, `lib/screens/messages/chat_screen.dart`
**Models:** `lib/models/message.dart` (`Message`, `Conversation`)

**What it does:**
- `MessagesScreen` — list of conversations with last message preview and timestamp
- `ChatScreen` — message thread with send input

**Current state:** Full UI, mock data wired. Send action shows a snackbar (no Firestore write).

**Pending:**
- Wire send to `FirestoreService.sendMessage()`
- Unread badge count on Messages nav tab
- New conversation creation from post detail sheet

---

## Profile Screen

**File:** `lib/screens/profile/profile_screen.dart`

**What it does:**
- User avatar (initial, orange circle)
- USER INFO card (name, email, experience level, bio)
- EXPERIENCE card (hatched progress bar)
- CLIMBING STYLES card (type chips)
- FAVORITE CRAGS card (IDs listed; no UI to add/remove yet)
- CONNECTIONS card — confirmed connections list + pending request banner (REVIEW → NotificationsScreen)
- FIND CLIMBERS button → FindClimbersScreen
- Sign out button

**Pending:**
- Edit mode (bio, experience level, styles)
- Favorites UI (add/remove crags and gyms)
- Profile photo upload
