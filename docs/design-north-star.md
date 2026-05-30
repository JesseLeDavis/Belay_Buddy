# Belay Buddy — Design North Star

This document is the single source of truth for the redesign. If a PR doesn't move us toward what's written here, it doesn't ship. If this doc is wrong, change this doc first, then change the code.

## The user

**Tess.** 18-month gym climber, post-onboarding, lives in a city, climbs after work, used to have a Tuesday crew that drifted apart. Competent at belaying, low confidence walking up to strangers. Indoor-first. Doesn't read topos on a weeknight.

## What it is

A scheduling utility for one perishable need:

> *"Get me on the wall tonight with someone safe, without texting eight people."*

## What it is not

- A social network
- A bulletin board
- A feed
- A map of climbing destinations
- A friend graph
- A messaging app

## The core loop (3 taps, under 10 seconds)

`Open → "Tonight at Movement — 4 climbing" → tap avatar → "say you're coming" → confirmed → meet → "again?" → edge formed`

## IA

- **NOW** — home-venue feed of who's reachable tonight. The product lives here.
- **CHATS** — messages + notifications merged. A consequence, not a destination.
- **+ POST** — center FAB, one-tap "I'm climbing → when."
- **ME** — avatar top-right. Holds settings, home gym, theme. No tab.
- Crag pages are bottom sheets, not screens. No map tab anywhere.

## Brand bet

> **"Lime means someone is on the wall. Everything else gets out of the way."**

## Tonal contract

> **Chrome is quiet. Content is sincere. Lime is a person.**

## Visual system — "Chalk & Static"

| Token | Value | Use |
| --- | --- | --- |
| Canvas | `#EDE6D3` | Warm manila base. Not bone, not cream. |
| Ink | near-black | All text, hairlines, default UI |
| Ambient | chalk-blue `#C8D4DE` | Soft rings, "expected" states, secondary metadata |
| Signal | electric lime `#D8FF3C` | **Reserved exclusively for "a human is reachable."** Never decoration. |
| UI type | GT America | Names, labels, buttons |
| Mono | ABC Diatype Mono | Timestamps, venue codes, day-of-week |
| Strokes | 1.5px hairline, slightly irregular | Drawn, not specced |
| Shadows | none | Flat |
| Radius | 0 | No rounded corners anywhere |
| Tactile element | Handwritten day-of-week header ("TUE") over a hairline | The only smudge in the system |

### Motion

- **Default:** invisible. 120ms opacity, no easing showmanship.
- **Exception — the Route Line:** when "I'm in" is mutual, a 240ms hairline contour draws between the two avatars. Persists in the connections list. The one signature moment.

## Hard rules (PR-blocking)

1. **No ambient telemetry.** No green presence dots, online indicators, read receipts, typing indicators, "last seen," or "now viewing." Only intentional, time-boxed signals.
2. **No friend graph until earned** via the `again?` tap after a session.
3. **No exclamation marks.** Ever. Sentence case throughout.
4. **Lime is rationed.** Appears only when a real human is reachable. Buttons that post, wave, or open settings use ink, not lime.
5. **No map tab, header, or pill** on NOW. Map lives behind `ME → Change home gym`.
6. **PostType collapses to one verb:** *I'm climbing [when] at [where].* No intros, no lost & found.
7. **No empty states.** When tonight is sparse, forward-load to "Thursday — 7 climbers usual" with a one-tap "I'm usually here Thursdays."

## Cold start

- Launch in **one city** (Boulder / SLC / Brooklyn — pick one).
- Hand-recruit **30 climbers** at one anchor gym.
- **Recurring intent windows** ("usually here Tues/Thurs 6–9pm at Movement") are the data substrate that makes 30 users feel like a scene.
- User never sees the word "recurring" or "pulse" — they see *presence*, with three states:
  - Soft-ringed avatar = "usually here Tuesdays" (intent inferred)
  - Lime-marked avatar = "here now · til 8:30" (live or near-term confirmed)
  - Lime + checkmark = "confirmed with you"

## Metrics

- **North star:** Weekly Climbs Confirmed Per Active User
- **V1 operating metric:** Window Fill Rate — % of intent windows that convert to a confirmed pair within 4 hours

## The App Store image

A woman's chalk-dusted forearm resting on an open gym locker door. Phone in her other hand, screen out of focus, **one lime dot visible**. Fluorescent hallway wash, 7:14 PM, slight blur. No face, no logo, no rope.

---

## Day-1 NOW screen (Tess, Tuesday 5:42 PM)

### Version A — Healthy density (1 live · 3 expected · 1 confirmed)

```
┌──────────────────────────────────────┐
│ TUE 5:42p          MOVEMENT BLDR  ⓣ │  MONO timestamp + venue code,
│ ──────────────────────────────────── │  avatar "ⓣ" top-right = ME
│                                      │
│  Tonight at your gym                 │
│                                      │
│   ◉    ○    ○    ○    +              │  catch-radar row
│  Maya  Dev  Sam  Priya               │  ◉ = lime dot
│  HERE  6p   7p   7:30                │  ○ = chalk-blue soft ring
│                                      │
│ ──────────────────────────────────── │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ ● Maya K.            til 8:30p   │ │  lime left-bar
│ │   on the wall now                │ │
│ │   slab • 5.10s                   │ │
│ │                                  │ │
│ │   ┌──────────────────────────┐   │ │
│ │   │   say you're coming  →   │   │ │  lime fill button
│ │   └──────────────────────────┘   │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ ● Dev R.   ✓ confirmed with you  │ │  lime + check
│ │   landing 6:00p                  │ │
│ │   "bringing the kilter board     │ │
│ │    beta from sunday"             │ │
│ │                          chat →  │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ ○ Sam T.             around 7p   │ │  hairline only, no lime
│ │   usually Tuesdays               │ │
│ │   overhang • projecting 5.11     │ │
│ │                       wave →     │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ ○ Priya M.         around 7:30p  │ │
│ │   usually Tuesdays               │ │
│ │   ropes • 5.9–5.10               │ │
│ │                       wave →     │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ──────────────────────────────────── │
│   NOW            ⊕            CHATS  │  center FAB "+ POST"
│                [POST]                │  (ink outline, NOT lime)
└──────────────────────────────────────┘
```

**Interaction:** Tess taps "say you're coming" on Maya's card. Button flips to lime-filled *"you're in · til 8:30"*, Maya's avatar in the radar row gains the ✓, and a quiet line slides into the card: *"Maya knows."* No modal, no toast. The commitment is the feedback.

### Version B — Sparse night (0 live · 2 expected, forward-loaded)

```
┌──────────────────────────────────────┐
│ TUE 5:42p          MOVEMENT BLDR  ⓣ │
│ ──────────────────────────────────── │
│                                      │
│  Tonight at your gym                 │
│                                      │
│   ○    ○    +                        │  no lime anywhere in row
│  Jordan Lee                          │
│  6:30   8p                           │
│                                      │
│ ──────────────────────────────────── │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ ○ Jordan A.        around 6:30p  │ │  chalk-blue ring, hairline
│ │   usually Tuesdays               │ │
│ │   ropes • 5.10                   │ │
│ │                                  │ │
│ │   ┌──────────────────────────┐   │ │
│ │   │   wave — i'll be there   │   │ │  ink outline button,
│ │   └──────────────────────────┘   │ │  NOT lime (not live yet)
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ ○ Lee H.             around 8p   │ │
│ │   usually Tuesdays               │ │
│ │   boulders • V3–V5               │ │
│ │                                  │ │
│ │   ┌──────────────────────────┐   │ │
│ │   │   wave — i'll be there   │   │ │
│ │   └──────────────────────────┘   │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ──────────────────────────────────── │
│                                      │
│  Thinking past tonight?              │  forward-load, not "empty"
│                                      │
│ ┌──────────────────────────────────┐ │
│ │  THU 5–8p     7 climbers usual   │ │
│ │  ────────────────────────────    │ │
│ │  ◉ ○ ○ ○ ○ ○ ○                   │ │  1 lime peek = someone
│ │                                  │ │  already confirmed Thu
│ │  i'm usually here Thursdays →    │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ──────────────────────────────────── │
│   NOW            ⊕            CHATS  │
│                [POST]                │
└──────────────────────────────────────┘
```

**Interaction:** Tess taps *"i'm usually here Thursdays."* A bottom sheet asks one question: *"5–8p sound right?"* with `[yes] / [tweak]`. Tapping yes silently writes a recurring intent — her avatar joins the Thursday ring. The phrase *"recurring availability"* never appears in copy.
