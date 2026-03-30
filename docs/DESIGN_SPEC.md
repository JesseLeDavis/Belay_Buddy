# Belay Buddy — Design Specification

**Version:** 1.0
**Status:** Living document
**Platform:** iOS + Android (Flutter)

---

## Table of Contents

1. [Design Vision](#1-design-vision)
2. [Design System](#2-design-system)
3. [Component Library](#3-component-library)
4. [Screen-by-Screen Design Review](#4-screen-by-screen-design-review)
5. [Navigation Architecture](#5-navigation-architecture)
6. [Interaction Patterns](#6-interaction-patterns)
7. [Accessibility](#7-accessibility)
8. [Dark Mode](#8-dark-mode)

---

## 1. Design Vision

### The Feeling

Belay Buddy should feel like the crag parking lot at 7am on a Saturday — purposeful, communal, a little rugged, and unmistakably outdoorsy. It is not a polished corporate fitness app. It is not Tinder for climbers. It is the digital equivalent of the handwritten note pinned to the board at the Red Rock Canyon visitor center: practical, personal, and slightly charming in its informality.

The bulletin board metaphor is the right instinct and it should be committed to fully. Physical community boards at crags are tactile, impermanent, slightly chaotic, and deeply human. The app should evoke that same quality — organized enough to be useful, textured enough to feel real.

### Emotional Tone

**Grounded confidence.** Climbers are self-reliant but community-oriented. The app should feel like a tool that respects their judgment, not a service that hand-holds them. Minimal empty encouragement ("You're doing great!"). Maximum utility.

**Adventure-adjacent warmth.** The palette and typography should evoke worn granite, chalk-dusted hands, and the smell of sunscreen on a sandstone crag. Earthy, not austere.

**Low friction, high trust.** The single biggest fear with a partner-finding app is safety. The design should signal trustworthiness through clarity — clear experience levels, clear belay status, visible user histories — without becoming paranoid or bureaucratic.

### Competitive Positioning

| App | Strengths | Where Belay Buddy Differentiates |
|---|---|---|
| **Mountain Project** | Authoritative route data, large community | Hyper-local real-time presence; the board is about *today*, not history |
| **AllTrails** | Clean UX, mass appeal | Climbing-specific vocabulary and flows; no dumbing down |
| **Gaia GPS** | Deep mapping, offline | Simpler, social-first; the map is a launchpad, not the destination |
| **The Crag** | Global logbook, community | Ephemeral availability posts; meeting people, not logging sends |

The differentiator is **presence**: who is at the crag *right now*, and who will be there tomorrow. No other major app owns this space.

---

## 2. Design System

### 2.1 Color Palette

The existing olive/orange/tan foundation is correct in spirit but incomplete. The following builds it out into a proper token system.

#### Brand Colors

| Token | Hex | Usage |
|---|---|---|
| `brand.primary` | `#5C7A1F` | Primary actions, active nav, app bar — slightly deeper olive than current `#6B8E23` for better contrast |
| `brand.primaryLight` | `#7A9E2E` | Hover/pressed states on primary |
| `brand.primaryContainer` | `#D4E6A0` | Filled backgrounds behind primary content |
| `brand.secondary` | `#C4571A` | Secondary actions, NOW badge, FAB — slightly deeper than current `#D2691E` |
| `brand.secondaryLight` | `#E07840` | Hover/pressed states on secondary |
| `brand.secondaryContainer` | `#FFDEC8` | Warm accent surfaces |
| `brand.tertiary` | `#A0785A` | Tertiary text, decorative accents |
| `brand.tertiaryContainer` | `#D2B48C` | Cork board surface — keep as-is, it is perfect |

#### Surface Colors

| Token | Hex | Usage |
|---|---|---|
| `surface.canvas` | `#FAF9F6` | App background (scaffolds) |
| `surface.card` | `#FFFFFF` | Standard card surfaces |
| `surface.noteImmediate` | `#FFE4B5` | PostCard for NOW posts (moccasin) — keep |
| `surface.noteScheduled` | `#FFF8DC` | PostCard for PLANNED posts (cornsilk) — keep |
| `surface.cork` | `#C8A87A` | Cork board background — darken slightly from `#D2B48C` for more contrast |
| `surface.corkDark` | `#A8885A` | Cork board border/edge shadow |
| `surface.inputFill` | `#F5F4F0` | Text field fills |

#### Semantic Colors

| Token | Hex | Usage |
|---|---|---|
| `semantic.success` | `#3D7A47` | "Can Belay" chip, success toasts, PLANNED badge |
| `semantic.successContainer` | `#C8E6C9` | "Can Belay" chip background |
| `semantic.error` | `#C0392B` | "Need Belay" chip border, error states, push pin |
| `semantic.errorContainer` | `#FADADD` | "Need Belay" chip background |
| `semantic.warning` | `#D4831A` | Expiring soon indicators |
| `semantic.warningContainer` | `#FFF0CC` | Warning backgrounds |
| `semantic.info` | `#2C6FAC` | Informational chips, links |

#### Text Colors

| Token | Hex | Usage |
|---|---|---|
| `text.primary` | `#1A1A18` | Body text, headings — warm near-black |
| `text.secondary` | `#5A5A52` | Supporting text, captions |
| `text.disabled` | `#9A9A90` | Placeholder text, disabled controls |
| `text.onPrimary` | `#FFFFFF` | Text on olive primary surfaces |
| `text.onSecondary` | `#FFFFFF` | Text on orange secondary surfaces |
| `text.onCork` | `#2A1F14` | Text on cork board surfaces |

### 2.2 Typography

Use **Google Fonts** available via `google_fonts` Flutter package. Two typefaces maximum.

#### Heading Typeface: Cabin

Cabin is a humanist sans-serif with slight personality — not sterile like Roboto, not precious like a display serif. It reads well at small sizes and has a slightly rugged quality that suits climbing culture. Used for all headings, labels, and UI text.

#### Body Typeface: Cabin (Regular)

Keep it single-family. Use weight variation for hierarchy rather than a second typeface. The exception: post note titles on the bulletin board can use a slightly more textured feel — consider **Kalam** or **Caveat** for the PostCard title only (handwritten feel, legible at 18sp).

#### Type Scale

| Style | Font | Size | Weight | Line Height | Usage |
|---|---|---|---|---|---|
| `displayLarge` | Cabin | 32sp | 700 | 1.2 | App name on login |
| `headlineLarge` | Cabin | 26sp | 700 | 1.25 | Screen titles |
| `headlineMedium` | Cabin | 22sp | 600 | 1.3 | Section headers |
| `headlineSmall` | Cabin | 18sp | 600 | 1.3 | Card titles, crag name |
| `titleMedium` | Cabin | 16sp | 600 | 1.4 | Form section labels |
| `titleSmall` | Cabin | 14sp | 600 | 1.4 | Sub-labels, chip text |
| `bodyLarge` | Cabin | 16sp | 400 | 1.5 | Primary body text |
| `bodyMedium` | Cabin | 14sp | 400 | 1.5 | Secondary body text |
| `bodySmall` | Cabin | 12sp | 400 | 1.5 | Captions, metadata |
| `labelLarge` | Cabin | 14sp | 600 | 1.0 | Button text |
| `labelSmall` | Cabin | 11sp | 600 | 1.0 | Badge text, chip labels |
| `noteTitle` | Kalam | 18sp | 700 | 1.3 | PostCard title only |

### 2.3 Spacing System

Base unit: **4dp**

| Token | Value | Usage |
|---|---|---|
| `space.xs` | 4dp | Icon-to-text gaps, tight padding |
| `space.sm` | 8dp | Internal component padding, chip padding |
| `space.md` | 16dp | Standard content padding, card padding |
| `space.lg` | 24dp | Section separation |
| `space.xl` | 32dp | Major section breaks |
| `space.xxl` | 48dp | Hero area vertical spacing |

**Content Margin:** 16dp on all screen edges (match current implementation).
**Card Gap:** 8dp vertical between cards in a list (match current).
**Section Gap:** 24dp between distinct content sections.

### 2.4 Border Radius

| Token | Value | Usage |
|---|---|---|
| `radius.xs` | 2dp | PostCard note corners (intentionally almost square — paper-like) |
| `radius.sm` | 6dp | Chips, small badges |
| `radius.md` | 12dp | Standard cards, input fields |
| `radius.lg` | 16dp | Bottom sheets, modals |
| `radius.xl` | 24dp | FAB, pill buttons |
| `radius.full` | 999dp | Circular avatars, toggle pills |

Note: The current PostCard uses `borderRadius: 2` which is intentional and correct. The "almost no radius" on the paper note creates the physical card illusion. Do not round it further.

### 2.5 Elevation and Shadow System

Avoid Material 3's default tonal elevation (flat colored shadows). Use directional shadows that evoke physical objects on a cork board.

| Level | Usage | Shadow |
|---|---|---|
| `elevation.0` | Flat surfaces (app bar, cork header) | None |
| `elevation.1` | Standard cards | `0 1dp 3dp rgba(0,0,0,0.10)` |
| `elevation.2` | PostCard notes | `2dp 4dp 8dp rgba(0,0,0,0.15)` — offset slightly right-down for pinned effect |
| `elevation.3` | Bottom sheets, active cards | `0 8dp 24dp rgba(0,0,0,0.18)` |
| `elevation.4` | FAB | `0 4dp 16dp rgba(0,0,0,0.22)` |
| `elevation.pin` | Push pin | `1dp 2dp 4dp rgba(0,0,0,0.35)` — deeper shadow for 3D pin illusion |

### 2.6 Icon Style

Use **Material Symbols** (Outlined weight, Grade 0, Optical size 24). Avoid mixing filled and outlined styles within the same screen. The outlined variants feel lighter and less corporate.

Key icon assignments:
- Terrain / mountain: `landscape` or `terrain` — keep current usage
- Push pin: `push_pin` — keep, it is the right call
- Belay need: `back_hand` (more intuitive than `front_hand`)
- Belay offer: `check_circle_outline` (outlined to match style)
- Messages: `chat_bubble_outline`
- Profile: `person_outline`
- Map: `map` (keep)
- Search: `search` (keep)
- Location: `location_on` (keep)
- Close/dismiss: `close`
- Settings: `settings`
- Favorite crag: `bookmark_outline` / `bookmark` (filled when saved)

---

## 3. Component Library

### 3.1 CragMarker (Map Pin)

**Current state:** Standard `BitmapDescriptor.defaultMarkerWithHue(hueOrange)` — the default Google Maps teardrop pin tinted orange.

**Problem:** The default marker is generic and small. With 8+ crags on the map, it reads as noise. There is no indication of activity level — a dead crag and a busy crag look identical.

**Recommended design:**

A custom marker rendered as a `BitmapDescriptor` from a widget. Two states:

**Inactive marker (no active posts):**
```
  ┌─────────┐
  │  ⛰️   │  ← Icon inside a rounded rect
  └────┬────┘
       │       ← Pointer
       ▼
```
- Background: `surface.cork` (#C8A87A)
- Border: 1.5dp `brand.tertiary` (#A0785A)
- Icon: `landscape` icon in `text.onCork`
- Size: 40x44dp (body + 4dp pointer)
- No badge

**Active marker (1+ active posts):**
- Background: `brand.secondary` (#C4571A)
- Border: 2dp white
- Icon: white `landscape`
- Badge: small circle top-right, `brand.primary` (#5C7A1F), white number text
- Drop shadow: `elevation.pin`
- Size: 44x48dp (slightly larger to indicate activity)

**Pressed state:** Scale up 1.1x with a 150ms spring animation.

**Implementation note:** Render this via `RepaintBoundary` → `toImage()` pipeline before map load, then cache `BitmapDescriptor` instances.

### 3.2 PostCard (Bulletin Board Note)

**Current state:** Paper-colored container with slight rotation, push pin icon, belay chips. The concept is correct. Several details need refinement.

**Full visual spec:**

```
     📌  ← push pin, positioned top-right, slightly overlapping edge
┌─────────────────────────────────────┐
│  ○  Alex R.          ┌────────┐     │  ← Avatar (olive bg) + name + NOW chip
│     in 2h            │  NOW  │     │  ← timestamp + type badge
├─────────────────────────────────────┤  ← light divider line (0.5dp, grey[300])
│  Looking for belay partner at       │  ← noteTitle style (Kalam 18sp bold)
│  the main wall this afternoon       │
│                                     │
│  Comfortable leading 5.10, sport.   │  ← bodyMedium, grey[700]
│  Happy to take turns on TR too.     │
│                                     │
│  ┌─────────────┐  ┌─────────────┐  │
│  │ ✋ Need Belay│  │             │  │  ← chips in Wrap
│  └─────────────┘  └─────────────┘  │
│                          → Contact  │  ← right-aligned tap prompt
└─────────────────────────────────────┘
```

**Card surface colors:**
- NOW posts: `#FFE4B5` (moccasin) — keep
- PLANNED posts: `#FFF8DC` (cornsilk) — keep
- A subtle texture can be added via a very faint `DecorationImage` with `BlendMode.multiply` on a paper noise texture (PNG asset, ~5% opacity) to add tactile warmth.

**Push pin:**
- Color: `#CC2222` (pure red, more saturated than current `Colors.red[700]`)
- Size: 22dp (current 28dp is too large — it dominates the card)
- Position: `top: -6, right: 16` (slightly hanging over the top edge)
- Shadow: `elevation.pin`
- Consider a 2dp highlight at the pin head top-left: `rgba(255,255,255,0.4)` for 3D effect

**Rotation:**
- Current: `(hashCode % 3 - 1) * 0.02` radians — values of approximately -1.1°, 0°, or +1.1°
- Recommendation: Expand range slightly: `(hashCode % 5 - 2) * 0.015` — gives 5 variants from -1.7° to +1.7°. More variety, still subtle.
- Never rotate more than 2° — beyond that it hurts scannability.

**Type badge (NOW / PLANNED):**
- NOW: background `brand.secondary` (#C4571A), white text, `labelSmall` style
- PLANNED: background `semantic.success` (#3D7A47), white text, `labelSmall` style
- Shape: `radius.sm` (6dp) — current 12dp is too pill-like; slightly rectangular reads better as a "stamp"

**Belay chips:**
- Need Belay: background `semantic.errorContainer` (#FADADD), border `semantic.error` at 0.7 opacity, icon `back_hand` 14dp, text `semantic.error`
- Can Belay: background `semantic.successContainer` (#C8E6C9), border `semantic.success` at 0.7 opacity, icon `check_circle_outline` 14dp, text `semantic.success`
- Remove current border `color.withOpacity(0.5)` — replace with explicit border color per above

**"Contact" tap prompt:**
- Right-aligned, `bodySmall`, `brand.secondary` color, with a `›` character suffix
- Only visible on cards that belong to other users (not the viewer's own posts)
- Tap area: full card (keep current `GestureDetector`)

**Own post indicator:**
- Replace "Contact" with a row of small icon buttons: `edit` and `delete`
- Only show when `post.userId == currentUserId`

### 3.3 UserAvatar

Three sizes used across the app:

| Size | Diameter | Usage |
|---|---|---|
| `avatar.sm` | 28dp | PostCard header, message list item |
| `avatar.md` | 40dp | Post detail, conversation header |
| `avatar.lg` | 72dp | Profile screen hero |

**Visual spec:**
- Circular clip
- Background: deterministic color from username hash — cycle through `[brand.primary, brand.secondary, #2C6FAC, #7A4A9E, #2E7D32]`
- Initials: first initial of display name + first initial of last name if available; fallback to first two chars of display name
- Text: `text.onPrimary`, Cabin SemiBold, scaled to ~38% of avatar diameter
- When `photoUrl` is present: `CachedNetworkImage` with circular clip, fade-in 200ms, initials placeholder while loading
- Border: 1.5dp white border always (helps it stand out on both cork and white backgrounds)

**Online/active indicator (future):**
- 8dp circle, `semantic.success` fill, white 1.5dp border
- Positioned at bottom-right of avatar (clock position ~5)
- Only show when `lastActive` is within 30 minutes

### 3.4 BelayStatusChip

Used both on PostCard and as filter chips on the bulletin board header.

**Display variant (PostCard):**

```
┌──────────────────────┐
│ ✋  Need Belay        │
└──────────────────────┘
```

- Height: 28dp
- Horizontal padding: 8dp
- Icon: 14dp
- Label: `labelSmall` (11sp, 600 weight)
- Border radius: `radius.sm` (6dp)
- Colors: per semantic tokens above

**Filter variant (BulletinBoard header):**

Larger, toggleable, shows current filter state.

```
┌───────────────────────┐     ┌───────────────────────┐
│ ✋  Need Belay    ○   │     │ ✅  Can Belay     ○   │
└───────────────────────┘     └───────────────────────┘
     (inactive)                      (active — filled bg)
```

- Height: 36dp
- Toggle behavior: tapping switches between outlined (inactive) and filled (active)
- Active state: filled background color from semantic token
- Inactive state: transparent fill, colored border, colored icon/text

### 3.5 BottomSheet Patterns

The app uses bottom sheets in two contexts: crag quick-info when tapping a marker before navigating to the full board, and future post-detail views.

**CragPreviewSheet** (triggered by map marker tap, before navigating to full board):

```
┌────────────────────────────────────────┐
│  ▬▬▬  ← drag handle                   │
│                                        │
│  ⛰️  Red Rock Canyon           ☆      │
│     Red Rock, Nevada                   │
│                                        │
│  ┌──────┐  ┌──────┐  ┌──────┐         │
│  │SPORT │  │ TRAD │  │BOULD │         │  ← crag type chips
│  └──────┘  └──────┘  └──────┘         │
│                                        │
│  3 climbers posted today               │  ← activity summary
│                                        │
│  ┌────────────────────────────────┐   │
│  │      View Community Board  →   │   │  ← primary CTA
│  └────────────────────────────────┘   │
└────────────────────────────────────────┘
```

- Height: ~220dp (peekable, not full screen)
- Background: `surface.canvas`
- Rounded top corners: `radius.lg` (16dp)
- Drag handle: centered, 32x4dp, `#C0BDB8` color
- Animation: slide up 300ms, `Curves.easeOutCubic`
- Dismiss: swipe down OR tap outside

**PostDetailSheet** (tapping a PostCard):

Full-height modal bottom sheet. Shows expanded post content, poster's profile summary, and message CTA. Discussed in Section 4 (Crag Bulletin Board).

### 3.6 Empty States

Empty states must feel editorial, not like error pages. They should match the cork board aesthetic when used inside the bulletin board context.

**Bulletin Board — No Posts:**

```
   ┌─────────────────────────────────┐
   │                                 │
   │        📋                       │  ← large muted icon
   │                                 │
   │   No one's posted yet.          │  ← headlineSmall, text.secondary
   │                                 │
   │   Be the first to pin your      │  ← bodyMedium, text.disabled
   │   availability to the board.    │
   │                                 │
   │   ┌─────────────────────────┐  │
   │   │   📌  Post Your Plans   │  │  ← secondary CTA button
   │   └─────────────────────────┘  │
   │                                 │
   └─────────────────────────────────┘
```

- Background: `surface.cork` at 25% opacity (maintains board feel)
- Icon: `note_add_outlined`, 56dp, `text.disabled`
- Do NOT use the current `Colors.grey[400]` for the icon — use `#B8A898` for a warmer disabled feel

**Map — No Crags Loaded (network error):**

Not a cork board context. Use standard centered layout with terrain illustration (simple SVG or emoji). Offer a retry button.

**Messages — No Conversations:**

Centered layout. Icon: `chat_bubble_outline` 56dp. Text: "Start a conversation by tapping Contact on any post." No CTA button — the action lives elsewhere. Keep it understated.

### 3.7 Loading States

**Map loading (full screen):**
- Show the terrain map underneath immediately (Google Maps loads fast)
- Animate markers in: each marker fades + scales up from 0.5 with a staggered 50ms delay per marker
- While loading: show a 40dp `CircularProgressIndicator` in `brand.primary` centered over the map, wrapped in a white-backed circle container

**Bulletin Board loading (posts):**
- Show 2-3 skeleton PostCards: same dimensions and rotation as real cards, but with shimmer animation on the content areas
- Shimmer colors: `#E8E4DC` → `#F5F2EC` (warm, not cold grey)
- Never show a naked `CircularProgressIndicator` in the board context — it shatters the illusion

**Skeleton card:**
```
┌─────────────────────────────────────┐
│  ○○○  ████████████    ██████        │  ← shimmer rows
│       ████████                      │
├─────────────────────────────────────┤
│  ████████████████████████████████   │
│  ████████████████████████           │
│                                     │
│  ██████████   █████████████         │
└─────────────────────────────────────┘
```

**PostCard user avatar loading:**
- Currently: blank `SizedBox()` while loading — this causes a pop-in flash
- Fix: show initials placeholder immediately using a deterministic color from `post.userId.hashCode`, and update to real name when loaded. The user ID is always available, so derive something from it.

### 3.8 Error States

**Inline error (field validation):**
- Standard Flutter form validation — keep but apply correct error color (`semantic.error`)
- Error text: `bodySmall`, `semantic.error`

**Full-screen error (failed to load crag/map):**

```
   ┌─────────────────────────────────┐
   │                                 │
   │        ⚠️                       │
   │                                 │
   │   Couldn't load the map         │  ← headlineSmall
   │                                 │
   │   Check your connection and     │  ← bodyMedium, text.secondary
   │   try again.                    │
   │                                 │
   │   ┌─────────────────────────┐  │
   │   │         Try Again       │  │  ← primary FilledButton
   │   └─────────────────────────┘  │
   │                                 │
   └─────────────────────────────────┘
```

- Do not expose raw error strings (e.g., current `'Error loading crags: $error'`) in production
- Log the error, show a human message
- Offer a retry action — never a dead end

**Toast/SnackBar errors:**
- Use a custom `SnackBar` style: `semantic.error` background, white text, `close` icon action
- Duration: 4 seconds for errors, 2 seconds for success confirmations
- Position: above FAB when FAB is visible (use `snackBarBehavior: SnackBarBehavior.floating` with bottom margin = FAB height + 16dp)

---

## 4. Screen-by-Screen Design Review

### 4.1 Onboarding / Login

**What works:**
- Single-screen login/signup toggle is correct for MVP scope
- `FilledButton` with loading state in-place is a good pattern
- Centered scrollable layout handles small screens well

**What's broken / needs improvement:**

1. **No visual identity.** The `Icons.terrain` Material icon at 80dp is a placeholder. A logo mark — even a simple custom SVG of a carabiner or stylized mountain silhouette — would make the first impression dramatically better.

2. **Background is dead white.** The `Scaffold` default background is `#FAF9F6` which is fine for content screens but feels clinical on a login screen. The login screen should feel immersive.

3. **No brand story.** The subtitle "Find climbing partners at your favorite crags" is accurate but flat.

4. **Form fields use `OutlineInputBorder` which is slightly heavy** for a login form. Consider `UnderlineInputBorder` or a softer outlined style with `radius.md`.

**Recommended redesign:**

```
┌─────────────────────────────────────┐
│                                     │
│  [gradient bg: olive top → tan bot] │  ← full-screen background
│                                     │
│           ╔═══════╗                 │
│           ║  [🏔] ║                 │  ← custom logo mark, white
│           ╚═══════╝                 │
│                                     │
│         Belay Buddy                 │  ← displayLarge, white
│    Find your climbing partner       │  ← bodyMedium, white at 0.8 opacity
│                                     │
│  ┌─────────────────────────────┐   │
│  │  [white card, radius.lg]    │   │
│  │                             │   │
│  │  Email                      │   │
│  │  ─────────────────────────  │   │
│  │                             │   │
│  │  Password                   │   │
│  │  ─────────────────────────  │   │
│  │                             │   │
│  │  ┌─────────────────────┐   │   │
│  │  │     Sign In         │   │   │
│  │  └─────────────────────┘   │   │
│  │                             │   │
│  │  Don't have an account?     │   │
│  │  Sign up →                  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

- Background: `LinearGradient` from `brand.primary` (#5C7A1F) at top to `#8B6914` (dark amber) at bottom — evokes dawn at the crag
- Logo: white asset image or custom painted icon
- Form card: white, `elevation.3`, `radius.lg` (16dp), with `16dp` padding
- Form fields inside card: `UnderlineInputBorder`, no `OutlineInputBorder`
- Button: `brand.primary` filled, full width, `radius.xl` (24dp)
- Toggle: `TextButton`, `brand.secondaryLight` color on white background

**After signup flow (not currently built):**

After creating an account, redirect to a profile setup screen before the map. This should capture:
- Display name (required — critical for PostCard attribution)
- Experience level (beginner / intermediate / advanced / expert — required)
- Climbing styles (sport / trad / boulder / all — multi-select, required)

Without this, every PostCard shows "Unknown" and belay status chips have no experience context. Profile completion should be enforced at account creation, not deferred.

### 4.2 Map Screen

**What works:**
- Terrain map type is exactly right — it shows topography, which is relevant context
- Bottom nav bar exists (even if stubs are not wired)
- Orange marker hue is visible against terrain tiles
- FAB for post creation is correctly positioned

**What's broken / needs improvement:**

1. **FAB creates a post with no crag context.** The button says "Post Availability" but there's no crag-picker flow. This will confuse users. Either: (a) disable the FAB and let users navigate to a crag first, or (b) build a crag-picker step into the post creation flow. Option (b) is better UX.

2. **The bottom nav "Posts" tab goes nowhere.** SnackBar stubs break trust. Either build the feature or hide the tab until it's ready. A navigation item that produces a "coming soon" message actively degrades the experience — it signals incompleteness. Remove the tab until the feature exists, or replace it with a working feature.

3. **Profile and Sign Out are buried in a PopupMenuButton overflow menu.** Profile is a primary app feature, not a utility action. It should live in the bottom nav (replacing the stub "Posts" tab) until a dedicated Posts feed is built.

4. **AppBar title "Find Belay Buddies" is too long at smaller font sizes.** Truncate to "Belay Buddy" or replace with the logo mark.

5. **No empty state for the map.** If Firestore returns no crags, the map just shows a blank terrain with no markers and no explanation.

6. **My Location button (Google Maps default) overlaps** with the FAB in the bottom-right. Reposition by setting `padding` on the `GoogleMap` widget to push the default controls above the FAB.

**Recommended layout:**

```
┌─────────────────────────────────────┐
│  [🏔]  Belay Buddy    🔍            │  ← app bar, olive
│─────────────────────────────────────│
│                                     │
│                                     │
│       [TERRAIN MAP TILES]           │
│                                     │
│                  📍(active marker)  │
│       📍(inactive)                  │
│                                     │
│                   [My Location btn] │  ← repositioned above FAB
│                                     │
│          ┌────────────────────┐     │
│          │  📌  Post Plans    │     │  ← FAB, brand.secondary
│          └────────────────────┘     │
│─────────────────────────────────────│
│  🗺 Map    💬 Messages   👤 Profile │  ← bottom nav, 3 tabs
└─────────────────────────────────────┘
```

**Map marker tap flow (improved):**

Currently: tap marker → immediately navigate to CragDetailScreen.
Recommended: tap marker → show `CragPreviewSheet` (see Section 3.5) → tap "View Community Board" → navigate to CragDetailScreen. This two-step flow lets users see a summary without committing to navigation, which is standard map app behavior (AllTrails, Google Maps). It also eliminates the accidental navigation problem where a mis-tap launches a new screen.

### 4.3 Crag Bulletin Board (CragDetailScreen)

**What works:**
- `SliverAppBar` with collapsing header is the right pattern
- Cork board section header with post count badge is well-conceived
- PostCard design direction is correct and charming
- The gradient-to-olive placeholder when there's no image is a good fallback

**What's broken / needs improvement:**

1. **The cork board header is floating in the wrong place.** The header row (`Community Board` label + post count) has cork coloring but it's separated from the cork board background below — there's a white `scaffoldBackgroundColor` section (crag info) between the SliverAppBar and the cork section. The visual rhythm is: photo → white section → cork header → posts on cork. This works but the white section should use `surface.canvas` not pure white to feel integrated.

2. **Crag type chips use default Material chip styling.** They should use the custom chip style — `radius.sm`, themed colors, `labelSmall` typography.

3. **The "Community Board" text and `Icons.campaign` icon feel mismatched.** `campaign` (megaphone) is a notification/broadcast icon, not a bulletin board icon. Use `push_pin` or `dashboard` instead.

4. **No FAB on this screen.** The primary action — creating a post — is completely absent from the crag detail screen. This is a critical omission. Users who navigate here and find an empty board have no obvious path to post. Add a FAB: "📌 Post Here" using `brand.secondary`.

5. **The crag header image is missing in all 8 seeded crags** (no `imageUrl` in seed data). The gradient placeholder works but every crag looks identical. Add a CTA in the header area for users to eventually submit a photo ("Add a photo →").

6. **The `SliverList` for posts** renders all cards vertically. For boards with many posts (10+), consider switching to a `SliverGrid` with 2 columns on larger devices, or at minimum, adding a "show older posts" fold after the first 5.

**Recommended crag header (collapsed state, 56dp):**

```
← [crag name]                    🔍  📌
```

**Recommended crag header (expanded state, 200dp):**

```
┌─────────────────────────────────────┐
│                                     │
│  [photo or gradient placeholder]    │
│                                     │
│           Red Rock Canyon    ↙      │  ← title with shadow
└─────────────────────────────────────┘
```

**Recommended bulletin board section:**

```
┌─────────────────────────────────────┐  ← cork texture background begins
│  📌 Community Board      [3 posts]  │  ← header row on cork
├─────────────────────────────────────┤
│                                     │
│  [PostCard rotated slightly]        │
│                                     │
│  [PostCard rotated slightly]        │
│                                     │
│  [PostCard rotated slightly]        │
│                                     │
└─────────────────────────────────────┘
                            [ 📌 Post Here ]  ← FAB
```

The cork background color (#C8A87A) should extend for the full scrollable area below the header — not just the visible viewport. The `SliverFillRemaining` approach for the empty state achieves this but the non-empty path needs a `SliverToBoxAdapter` wrapping a `Container` with `color: surface.cork.withOpacity(0.3)` behind the `SliverList`.

**PostCard tap → PostDetailSheet:**

Currently: shows a SnackBar with `post.userId`. This must be replaced immediately — leaking UIDs to users is poor practice and looks broken.

Tapping a PostCard should open a `PostDetailSheet` (modal bottom sheet, ~70% height) containing:

```
┌─────────────────────────────────────┐
│  ▬▬▬                               │
│                                     │
│  ○  Alex R.                 NOW     │  ← avatar (md), name, badge
│     Intermediate · Sport, Trad      │  ← experience + styles
│                                     │
│  Looking for belay partner          │  ← noteTitle style
│  at the main wall                   │
│                                     │
│  Comfortable leading 5.10, sport.   │  ← bodyMedium
│  Happy to take turns on TR too.     │
│                                     │
│  ✋ Need Belay                       │  ← belay status chips
│                                     │
│  ────────────────────────────────   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   💬  Send Message          │   │  ← primary CTA
│  └─────────────────────────────┘   │
│                                     │
│  Posted 3 minutes ago               │  ← bodySmall, text.disabled
└─────────────────────────────────────┘
```

### 4.4 Create Post Screen

**What works:**
- `SegmentedButton` for post type selection is excellent — clear, touch-friendly
- `CheckboxListTile` for belay status is readable and accessible
- The crag context card at the top is helpful — user always knows where they're posting
- `FilledButton` submit CTA with `push_pin` icon is on-brand
- The check icon in the app bar as a secondary submit path is a nice desktop-native convention

**What's broken / needs improvement:**

1. **The screen feels like a generic form, not a "pinning a note to a board" moment.** The create post flow is the most emotionally important moment in the app — it should feel special. The bulletin board aesthetic exists on the crag detail screen but disappears here.

2. **No character count on the title field.** The title shows on the card prominently — users should know roughly how much space they have.

3. **The belay checkboxes allow both checked simultaneously.** A user can claim "I need a belay" and "I can belay" at the same time. This is technically valid (they want to swap leads, or they want someone to climb with regardless of belay situation), but should have a copy note explaining: "You can select both — some climbers want a swap partner." Without this, it reads like a bug.

4. **The `_isSignUp` pattern used in login for submit button is inconsistent.** Here it uses `IconButton(Icons.check)` in the AppBar. Neither is wrong but the app should pick one primary pattern: the `FilledButton` at the bottom of the form is better (more accessible, more visible). Remove the AppBar icon button and keep only the form-bottom button.

5. **Date/time picker uses system default pickers** (Material date picker, time picker). These are fine but could be styled to match the app theme via `showDatePicker` `builder` parameter.

6. **No confirmation of expiry time.** The user doesn't know that an "immediate" post expires in 12 hours. This should be shown as a note under the segment selector: "Immediate posts expire after 12 hours."

**Recommended redesign of the create post screen:**

Introduce a light cork-themed background for the form, and frame the title/description fields as if the user is literally writing on a note card.

```
┌─────────────────────────────────────┐
│ ←  Post to Red Rock Canyon          │  ← app bar, olive
│─────────────────────────────────────│
│  [surface.canvas background]        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  When are you climbing?     │   │  ← section header
│  │  [Today/Now] [Scheduled]    │   │  ← SegmentedButton
│  │  Expires in 12 hours        │   │  ← bodySmall, text.disabled
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │  ← "paper note" card
│  │  [cork-colored top strip]   │   │      brand.tertiaryContainer top 8dp
│  │  Write your note...         │   │
│  │                             │   │
│  │  ┌─────────────────────┐   │   │  ← title field, noteTitle style
│  │  │  Title              │   │   │      no border, just underline
│  │  └─────────────────────┘   │   │
│  │  ─────────────────────────  │   │
│  │  ┌─────────────────────┐   │   │  ← description, bodyMedium
│  │  │  Details (optional) │   │   │
│  │  └─────────────────────┘   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Belay Status                       │
│  [✋ Need Belay toggle]             │
│  [✅ Can Belay toggle]              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   📌  Pin to Board          │   │  ← primary CTA
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

Replace `CheckboxListTile` with a toggle-style card that looks like the BelayStatusChip in its filter variant (Section 3.4) — tapping the chip toggles its active state. This is more visually consistent with the rest of the app.

### 4.5 User Profile Screen (Not Yet Built)

The profile screen serves two purposes: self-expression and trust signals. Climbers evaluating a potential partner need to know experience level, climbing style, and some minimal history. The design should surface trust signals prominently without feeling like a dating profile.

**Recommended structure:**

```
┌─────────────────────────────────────┐
│ ←                         ✏️ Edit   │  ← app bar (own profile only)
│─────────────────────────────────────│
│                                     │
│  ╔═══════════════════════════════╗  │
│  ║  [gradient header bg]         ║  │  ← 140dp height
│  ║        ○ Alex R.              ║  │  ← avatar.lg, centered
│  ║    alex.reynolds@gmail.com    ║  │  ← bodySmall, text.disabled
│  ╚═══════════════════════════════╝  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Intermediate               │   │  ← experience level badge
│  │  Sport · Trad               │   │  ← climbing style chips
│  └─────────────────────────────┘   │
│                                     │
│  Bio                                │
│  "5.11 sport climber, learning      │
│  trad. Happy to belay and swap..."  │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  Favorite Crags                     │
│  ┌──────────┐  ┌──────────┐        │
│  │ Red Rock │  │  Yosemite│        │  ← horizontal scroll, crag cards
│  └──────────┘  └──────────┘        │
│                                     │
│  My Active Posts                    │
│  [PostCard — mini style]            │  ← user's own posts, editable
│  [PostCard — mini style]            │
│                                     │
│  ─────────────────────────────────  │
│  Sign Out                           │  ← at bottom, bodyMedium, semantic.error
└─────────────────────────────────────┘
```

**Key design decisions:**
- Experience level badge: uses `brand.primary` container with white text, `headlineSmall`. Displayed prominently — it is the first trust signal another climber looks for.
- Climbing style chips: outlined chips, `radius.sm`, colored by style type
- Bio: inline editable on own profile (tap to edit pattern vs. navigating to edit screen)
- Favorite crags: horizontal scrolling chip/card row, saved via `favoriteCragIds`
- Active posts section: shows the user's own PostCards with edit/delete affordances
- Sign Out: text-only button at the very bottom. Never prominent. Destructive-adjacent color.

### 4.6 Messaging Screen (Not Yet Built)

The messaging feature exists in the data model (`Conversation`, `Message`) but has no UI. This is the feature that converts "I found a potential partner" into "we actually climbed together."

**Design principles for messaging:**
- Keep it simple: this is a coordination tool, not a social network. No reactions, no image sharing in v1, no read receipts parade.
- Entry point: "Send Message" on the PostDetailSheet (Section 4.3). The message includes context about which post triggered it.
- The conversation list is in the bottom nav "Messages" tab.

**Conversation List:**

```
┌─────────────────────────────────────┐
│  Messages                           │  ← app bar
│─────────────────────────────────────│
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ○  Alex R.         2m ago  │   │  ← avatar.sm, name, timestamp
│  │     "See you at the wall!"  │   │  ← last message preview, 1 line
│  │                    ●        │   │  ← unread dot (brand.secondary)
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ○  Jordan M.      1h ago   │   │
│  │     "Sounds good, I'll b..."│   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Conversation View:**

Standard chat bubble layout. No design novelty needed here — the bulletin board aesthetic does not carry into the messaging context. This is a utility screen and should feel clean and fast.

- Sent messages: `brand.primaryContainer` (#D4E6A0) bubble, right-aligned
- Received messages: white bubble with 1dp `#E0DDD8` border, left-aligned
- Timestamps: shown once per cluster of messages (not per-message), `bodySmall`, `text.disabled`, centered
- Input field: single-line, `surface.inputFill` background, `radius.xl`, `send` icon button

**Conversation header context card:**

Pinned at the top of the conversation, a small dismissable context card showing which post initiated the conversation:

```
┌─────────────────────────────────────┐
│  📌 Red Rock Canyon · NOW   [✕]     │
│  "Looking for belay partner"         │
└─────────────────────────────────────┘
```

This is a `PostCard` in compact/mini mode, pinned above the message list. It reminds both users what they're meeting up for. Dimissable after the user has read it.

---

## 5. Navigation Architecture

### 5.1 Recommended Structure

**Bottom Navigation: 3 tabs**

| Tab | Icon | Label | Screen |
|---|---|---|---|
| 1 | `map` | Map | MapScreen (home) |
| 2 | `chat_bubble_outline` | Messages | ConversationListScreen |
| 3 | `person_outline` | Profile | UserProfileScreen |

Remove the "Posts" stub tab. A global posts feed (all crags) is a future feature and should only be added when it has real functionality.

**Why 3 tabs, not 4 or 5:**
- The app's core loop is: map → crag → post/contact → message. The map is home. Messaging is the output. Profile is the settings/identity layer. Three tabs covers this cleanly.
- A "Posts" global feed tab makes sense later, but it would be the fourth tab and only works if it's searchable/filterable. Add it in v2.

**Navigation hierarchy:**

```
App Root
├── /login          (no bottom nav)
│
├── /map            (bottom nav tab 1)
│   └── /crag/:id   (pushed onto nav stack, has back button)
│       └── /crag/:id/create-post  (modal sheet or pushed)
│
├── /messages       (bottom nav tab 2)
│   └── /messages/:conversationId  (pushed)
│
└── /profile        (bottom nav tab 3)
    └── /profile/edit  (pushed or modal)
```

### 5.2 Deep Linking Strategy

go_router is already in use. Define the following named routes:

| Route Name | Path | Description |
|---|---|---|
| `login` | `/login` | Auth screen |
| `map` | `/map` | Home map |
| `crag` | `/crag/:id` | Bulletin board |
| `createPost` | `/crag/:id/post` | Create post for crag |
| `messages` | `/messages` | Conversation list |
| `conversation` | `/messages/:id` | Single conversation |
| `profile` | `/profile` | Own profile |
| `userProfile` | `/user/:id` | Another user's profile |

**Deep link examples:**
- `belaybuddy://crag/red-rock-canyon` → opens map then navigates to Red Rock board
- `belaybuddy://messages/abc123` → opens messages tab then opens conversation
- Push notification CTA for new messages should deep link to `conversation/:id`

### 5.3 Transition Animations

| Transition | Animation |
|---|---|
| Bottom nav tab switch | Fade, 150ms |
| Push route (map → crag) | Slide from right, 250ms |
| Modal sheet | Slide from bottom, 300ms, `easeOutCubic` |
| Login → Map (auth success) | Fade, 400ms (feels like entering the outdoors) |
| Crag marker tap → preview sheet | Slide from bottom, 280ms |

Do not use `ZoomPageTransitionsBuilder` — it looks fine on Android but feels wrong for this app's aesthetic.

---

## 6. Interaction Patterns

### 6.1 Gestures

| Gesture | Target | Action |
|---|---|---|
| Tap | Map marker | Open CragPreviewSheet |
| Tap | CragPreviewSheet CTA | Navigate to CragDetailScreen |
| Tap | PostCard | Open PostDetailSheet |
| Long press | PostCard (own) | Show edit/delete action sheet |
| Swipe down | Modal sheet | Dismiss |
| Swipe left | Conversation list item | Reveal delete action |
| Pull to refresh | Bulletin board | Re-fetch posts (though real-time stream makes this less necessary) |
| Pinch | Map | Standard Google Maps zoom |

### 6.2 Haptic Feedback

Use `HapticFeedback` from `flutter/services.dart`:

| Event | Haptic type |
|---|---|
| PostCard tap | `selectionClick` |
| Post submitted successfully | `mediumImpact` |
| Belay chip toggled (create post) | `selectionClick` |
| Error (form validation failure) | `vibrate` (light) |
| Long press action sheet appears | `heavyImpact` |
| Message sent | `lightImpact` |

Do not add haptics to every interactive element — only key confirmation moments and navigation triggers. Over-haptic-ing cheapens the feedback.

### 6.3 Toast / Feedback Patterns

Replace all current `SnackBar` usages with a consistent pattern:

**Success toast:**
```
┌──────────────────────────────────────┐
│  ✓  Posted to the board!             │
└──────────────────────────────────────┘
```
- Background: `semantic.success` (#3D7A47)
- Icon: `check_circle_outline`, white
- Text: white, `bodyMedium`
- Duration: 2 seconds
- `SnackBarBehavior.floating`, bottom margin 80dp (above FAB/nav)

**Error toast:**
```
┌──────────────────────────────────────┐
│  ✕  Couldn't save your post.  Retry  │
└──────────────────────────────────────┘
```
- Background: `semantic.error` (#C0392B)
- Action button: white text "Retry"
- Duration: 4 seconds (or until dismissed)

**Info toast (no action needed):**
- Background: `#2C2C2A` (near-black, neutral)
- Duration: 2 seconds

### 6.4 Loading Feedback

| Context | Pattern |
|---|---|
| Initial map load | Spinner centered over map (see Section 3.7) |
| Bulletin board posts loading | Skeleton cards (see Section 3.7) |
| Form submit (create post) | Button converts to spinner in-place; disable all inputs |
| Auth submit (login/signup) | Same as form submit |
| Image load (crag header) | Fade-in from placeholder gradient |
| Avatar load | Initials placeholder, never blank |

### 6.5 Empty / First-Use Guidance

On first login (account age < 24 hours), show a one-time tooltip overlay on the map:

```
                  ▲
┌────────────────────────────────┐
│  Tap any orange marker to see  │
│  who's climbing today.         │
│                        Got it  │
└────────────────────────────────┘
```

Triggered by: `SharedPreferences` flag `hasSeenMapTooltip`. Show once, dismiss on "Got it" tap or 5 seconds auto-dismiss.

Do not use multiple tooltip overlays simultaneously. One at a time, maximum two total in the onboarding sequence (map tooltip + bulletin board tooltip on first crag visit).

---

## 7. Accessibility

### 7.1 Minimum Requirements

These are non-negotiable for release:

**Color contrast:**
- All text must meet WCAG AA: 4.5:1 for body text, 3:1 for large text (18sp+ or 14sp bold+)
- Current `brand.primary` (#5C7A1F) on white: check via contrast tool — the adjusted value passes AA
- `text.secondary` (#5A5A52) on white: 7.4:1 — passes AAA
- Belay chip text on chip background: verify `semantic.error` (#C0392B) on `semantic.errorContainer` (#FADADD) — this combination may be marginal; use the darker `#A02020` on errorContainer if needed

**Touch targets:**
- Minimum 44x44dp for all interactive elements (iOS HIG and Material guidelines)
- Current PostCard: the full card is tappable — good. The push pin icon at top-right is decorative only and should have `ExcludeSemantics` wrapper.
- Current map markers: Google Maps handles touch areas natively — no action needed
- Checkbox tiles: already full-width — good

**Screen reader (TalkBack/VoiceOver):**
- All `IconButton` widgets must have `tooltip` parameter set
- `PostCard`: wrap in `Semantics` with a meaningful label synthesized from the post content:
  - `semanticsLabel: '${user.displayName}, ${post.type == PostType.immediate ? "climbing now" : "climbing ${formatDateTime(post.dateTime)}"}, ${post.title}'`
- Map markers: add `semanticsLabel` to `Marker` (supported via `Marker.contentDescription` in newer google_maps_flutter versions)
- Belay chips: label them as "Need Belay status chip" and "Can Belay status chip" — the icon alone is not sufficient
- Avatar: `Semantics(label: '${user.displayName} avatar', child: CircleAvatar(...))`

**Keyboard / hardware accessibility:**
- All forms must be navigable via Tab key (relevant for tablet/desktop Flutter targets)
- `TextFormField` widgets should have appropriate `textInputAction` set:
  - Email field: `TextInputAction.next`
  - Password field: `TextInputAction.done` (triggers submit)
  - Post title: `TextInputAction.next`
  - Post description: `TextInputAction.done` (last field)

**Dynamic text sizing:**
- Do not hardcode pixel sizes for layout-critical components; use `sp` (scaled pixels) which Flutter handles via `MediaQuery.textScaleFactor`
- PostCard: the paper card should expand vertically when text is larger — avoid fixed heights

### 7.2 Color-Blind Considerations

The "Need Belay" vs. "Can Belay" distinction currently relies entirely on color (red vs. green). This fails for deuteranopia (red-green color blindness, affects ~8% of males).

**Fix:** The icon choice already helps: `back_hand` (palm facing out = "stop, I need help") vs. `check_circle_outline` (check = "I can do this"). Ensure these icons are always shown alongside the color and never hidden. Do not rely on color alone for any status distinction.

---

## 8. Dark Mode

### 8.1 Should It Exist?

Yes. Climbers use their phones in a variety of outdoor conditions — pre-dawn alpine starts, headlamp conditions, campfire light. Dark mode also extends battery life on OLED screens, which matters on all-day crag trips.

However, dark mode should not be rushed. A poorly executed dark mode is worse than no dark mode. It should be built as a distinct theme, not auto-generated by inverting the light palette.

**Priority:** Implement after core feature set (profile + messaging) is complete. Target v1.1.

### 8.2 Dark Mode Token Mappings

The core challenge is maintaining the warm, earthy quality of the light theme in dark mode. Do not go cold/grey — keep the warmth by using warm-tinted darks.

| Light Token | Dark Value | Notes |
|---|---|---|
| `surface.canvas` (#FAF9F6) | `#1A1916` | Warm near-black (not pure `#000000`) |
| `surface.card` (#FFFFFF) | `#242220` | Warm dark surface |
| `surface.cork` (#C8A87A) | `#3D3025` | Very dark warm brown — cork in shadow |
| `surface.noteImmediate` (#FFE4B5) | `#3D2E1A` | Dark amber — still evokes the warmth |
| `surface.noteScheduled` (#FFF8DC) | `#2E2A1A` | Dark cream |
| `brand.primary` (#5C7A1F) | `#8FB84A` | Lighter olive for dark bg contrast |
| `brand.secondary` (#C4571A) | `#E87A45` | Lighter orange for dark bg contrast |
| `text.primary` (#1A1A18) | `#F0EDEA` | Warm near-white |
| `text.secondary` (#5A5A52) | `#A8A49E` | Mid warm grey |
| `text.disabled` (#9A9A90) | `#6A6660` | |
| `semantic.success` (#3D7A47) | `#5DB870` | Lightened for dark bg |
| `semantic.error` (#C0392B) | `#E85D50` | Lightened for dark bg |

**Cork board in dark mode:**

The cork board is the most challenging component. In dark mode, `surface.cork` (#3D3025) creates a surface that still reads as "wooden/tactile" but now evokes a weathered, fire-lit quality rather than a sun-lit afternoon. The PostCard paper notes use their dark equivalents and the slight rotation + shadow effect must be adjusted:

- Shadow on dark PostCards: `rgba(0,0,0,0.5)` (heavier — shadows are less visible on dark surfaces at low opacity)
- Push pin: stays red — `#CC2222` actually reads well on dark cork backgrounds

**App bar in dark mode:**

- Do not use `brand.primary` (#8FB84A) as app bar background — too lime-green on dark
- Use `surface.card` (#242220) for the app bar in dark mode, with `text.primary` (#F0EDEA) foreground
- Or use the same dark olive: `#2E3D10` (very dark olive, maintains brand identity)

**Map in dark mode:**

Google Maps supports a custom map style via `GoogleMap(style: ...)` parameter. In dark mode, load a custom map style JSON that uses a dark terrain style (Google provides a few presets; "Midnight Command" is a reasonable starting point, then adjust the road/terrain colors toward olive tones to match the app).

### 8.3 Implementation Approach

Use Flutter's `ThemeMode.system` as the default — respect the OS setting. Provide a manual override in Profile settings under "Display."

Define the dark theme as a fully explicit `ThemeData` object (do not rely on `ColorScheme.fromSeed` to auto-generate dark variants — the auto-generated colors will be too saturated and cold). Map every token explicitly as shown in Section 8.2.

---

## Appendix: Quick Reference

### Color Tokens Summary

```
Brand:
  primary:          #5C7A1F  (olive)
  primaryLight:     #7A9E2E
  primaryContainer: #D4E6A0
  secondary:        #C4571A  (orange)
  secondaryLight:   #E07840
  secondaryContainer:#FFDEC8
  tertiary:         #A0785A
  tertiaryContainer:#D2B48C  (cork)

Surface:
  canvas:           #FAF9F6
  card:             #FFFFFF
  noteImmediate:    #FFE4B5
  noteScheduled:    #FFF8DC
  cork:             #C8A87A
  inputFill:        #F5F4F0

Semantic:
  success:          #3D7A47
  successContainer: #C8E6C9
  error:            #C0392B
  errorContainer:   #FADADD
  warning:          #D4831A

Text:
  primary:          #1A1A18
  secondary:        #5A5A52
  disabled:         #9A9A90
```

### Key Design Decisions Summary

1. Bulletin board aesthetic is the right bet — commit to it fully. Texture the cork, use the push pin, lean into the paper note metaphor.
2. The `PostCard` is the most important component in the app. Every design decision about it has outsized impact.
3. Experience level and climbing style are trust signals. They must be visible on every profile-adjacent surface.
4. Three bottom nav tabs: Map, Messages, Profile. No stubs.
5. Profile completion at signup is required, not optional. "Unknown" poster names are a dealbreaker.
6. Every loading state in the bulletin board context must use skeleton cards, not spinners. Spinners break the physical metaphor.
7. Dark mode exists but is a v1.1 feature. Do not ship a broken dark theme.
8. Haptics on key moments only. Less is more.
