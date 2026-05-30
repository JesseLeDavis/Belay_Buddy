/// A NOW-screen session — one row in the "Tonight at your gym" feed.
///
/// Surfaces three presence states (see docs/design-north-star.md):
/// - `live`     — checked in / on the wall right now (lime pip)
/// - `confirmed`— the current user has said they're coming too (lime check)
/// - `expected` — recurring intent fires into tonight's window (chalk-blue ring)
///
/// Intentionally light: name, time, an optional one-line note. Discipline /
/// grade live on the user's profile, not on the presence card.
enum SessionStatus { live, confirmed, expected }

class NowSession {
  /// Stable id for the underlying climber, used for tap navigation and
  /// for keying the in-memory "I confirmed with them" set.
  final String userId;

  /// Lowercase initial for the avatar dot. Single character.
  final String initial;

  /// Display name, "Maya K." style.
  final String name;

  /// Display-ready time string ("til 8:30p", "around 7p", "landing 6:00p").
  /// Caller pre-formats — the screen never does date math.
  final String timeLabel;

  /// Display-ready subtitle ("on the wall now", "usually Tuesdays", "").
  final String subtitle;

  /// Optional one-line note from the climber. Rendered italic in quotes.
  final String? note;

  final SessionStatus status;

  const NowSession({
    required this.userId,
    required this.initial,
    required this.name,
    required this.timeLabel,
    required this.subtitle,
    required this.status,
    this.note,
  });
}

/// One bubble in the catch-radar row at the top of NOW.
class RadarChip {
  final String userId;
  final String initial;
  final String name; // first name only
  final String timeLabel; // "HERE" for live, "6p" for confirmed/expected
  final SessionStatus status;

  const RadarChip({
    required this.userId,
    required this.initial,
    required this.name,
    required this.timeLabel,
    required this.status,
  });
}
