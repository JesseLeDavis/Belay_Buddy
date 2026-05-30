import 'package:belay_buddy/src/features/now/domain/now_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tonight's sessions at the user's home venue.
///
/// PR #4: returns hardcoded sessions so NowScreen can stop owning data.
/// A follow-up PR derives these from `ClimbingPost`s (live/expected) joined
/// with the recurring-intent windows model that doesn't exist yet.
final tonightSessionsProvider = Provider<List<NowSession>>((ref) {
  return const [
    NowSession(
      userId: 'user_2',
      initial: 'm',
      name: 'Maya K.',
      timeLabel: 'til 8:30p',
      subtitle: 'on the wall now',
      status: SessionStatus.live,
    ),
    NowSession(
      userId: 'user_8',
      initial: 'n',
      name: 'Nico C.',
      timeLabel: 'landing 6:00p',
      subtitle: '',
      note: 'bringing the kilter board beta from sunday',
      status: SessionStatus.confirmed,
    ),
    NowSession(
      userId: 'user_5',
      initial: 's',
      name: 'Sam C.',
      timeLabel: 'around 7p',
      subtitle: 'usually Tuesdays',
      status: SessionStatus.expected,
    ),
    NowSession(
      userId: 'user_4',
      initial: 'p',
      name: 'Priya B.',
      timeLabel: 'around 7:30p',
      subtitle: 'usually Tuesdays',
      status: SessionStatus.expected,
    ),
  ];
});

/// Catch-radar bubbles — derived from tonight's sessions.
/// Sort matches the feed order so the radar lines up visually.
final radarChipsProvider = Provider<List<RadarChip>>((ref) {
  final sessions = ref.watch(tonightSessionsProvider);
  return sessions.map((s) {
    return RadarChip(
      userId: s.userId,
      initial: s.initial,
      name: s.name.split(' ').first,
      timeLabel: _radarTime(s),
      status: s.status,
    );
  }).toList();
});

String _radarTime(NowSession s) {
  switch (s.status) {
    case SessionStatus.live:
      return 'HERE';
    case SessionStatus.confirmed:
      // "landing 6:00p" → "6p"
      final match = RegExp(r'(\d{1,2})(?::(\d{2}))?').firstMatch(s.timeLabel);
      if (match == null) return s.timeLabel;
      final hour = match.group(1);
      final mins = match.group(2);
      return mins == null || mins == '00' ? '${hour}p' : '$hour:$mins';
    case SessionStatus.expected:
      // "around 7p" / "around 7:30p" → "7p" / "7:30"
      return s.timeLabel.replaceFirst('around ', '');
  }
}
