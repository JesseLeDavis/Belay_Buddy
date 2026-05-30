import 'package:belay_buddy/src/features/now/domain/now_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dev preview mode — flips NOW between dense (Version A) and sparse
/// (Version B, forward-loaded) data. Goes away when real data lands.
enum NowDemoMode { dense, sparse }

final nowDemoModeProvider =
    StateProvider<NowDemoMode>((ref) => NowDemoMode.dense);

/// Tonight's sessions at the user's home venue.
///
/// PR #4 introduced the provider; PR #5 added the sparse-night branch.
/// A follow-up derives the dense list from `ClimbingPost`s (live/expected)
/// joined with the recurring-intent windows model (TBD).
final tonightSessionsProvider = Provider<List<NowSession>>((ref) {
  final mode = ref.watch(nowDemoModeProvider);
  return switch (mode) {
    NowDemoMode.dense => _denseTonight,
    NowDemoMode.sparse => _sparseTonight,
  };
});

const _denseTonight = <NowSession>[
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

const _sparseTonight = <NowSession>[
  NowSession(
    userId: 'user_6',
    initial: 'j',
    name: 'Jordan D.',
    timeLabel: 'around 6:30p',
    subtitle: 'usually Tuesdays',
    status: SessionStatus.expected,
  ),
  NowSession(
    userId: 'user_3',
    initial: 'c',
    name: 'Carlos T.',
    timeLabel: 'around 8p',
    subtitle: 'usually Tuesdays',
    status: SessionStatus.expected,
  ),
];

/// One forward-loaded "Thinking past tonight?" card.
///
/// Surfaced when the dense tonight feed has no live or confirmed sessions —
/// the brief's "never empty / forward-load to Thursday" rule.
class ForwardLoadedDay {
  final String dayLabel; // "THU"
  final String windowLabel; // "5–8p"
  final int usualCount; // "7 climbers usual"
  final List<RadarChip> peek; // mini-radar of who's expected
  final String cta; // "i'm usually here Thursdays  →"

  const ForwardLoadedDay({
    required this.dayLabel,
    required this.windowLabel,
    required this.usualCount,
    required this.peek,
    required this.cta,
  });
}

final forwardLoadedDayProvider = Provider<ForwardLoadedDay?>((ref) {
  final sessions = ref.watch(tonightSessionsProvider);
  final hasReachable = sessions.any((s) =>
      s.status == SessionStatus.live || s.status == SessionStatus.confirmed);
  if (hasReachable) return null;

  return const ForwardLoadedDay(
    dayLabel: 'THU',
    windowLabel: '5–8p',
    usualCount: 7,
    cta: 'i’m usually here Thursdays  →',
    peek: [
      RadarChip(
          userId: 'user_2',
          initial: 'm',
          name: 'Maya',
          timeLabel: '',
          status: SessionStatus.confirmed),
      RadarChip(
          userId: 'user_8',
          initial: 'n',
          name: 'Nico',
          timeLabel: '',
          status: SessionStatus.expected),
      RadarChip(
          userId: 'user_5',
          initial: 's',
          name: 'Sam',
          timeLabel: '',
          status: SessionStatus.expected),
      RadarChip(
          userId: 'user_4',
          initial: 'p',
          name: 'Priya',
          timeLabel: '',
          status: SessionStatus.expected),
      RadarChip(
          userId: 'user_9',
          initial: 'k',
          name: 'Kira',
          timeLabel: '',
          status: SessionStatus.expected),
      RadarChip(
          userId: 'user_6',
          initial: 'j',
          name: 'Jordan',
          timeLabel: '',
          status: SessionStatus.expected),
      RadarChip(
          userId: 'user_3',
          initial: 'c',
          name: 'Carlos',
          timeLabel: '',
          status: SessionStatus.expected),
    ],
  );
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
