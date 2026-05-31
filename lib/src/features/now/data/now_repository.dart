import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/now/domain/now_session.dart';
import 'package:belay_buddy/src/features/posts/data/posts_repository.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dev preview mode — flips NOW between dense (Version A) and sparse
/// (Version B, forward-loaded) data. Goes away when real data lands.
enum NowDemoMode { dense, sparse }

final nowDemoModeProvider =
    StateProvider<NowDemoMode>((ref) => NowDemoMode.dense);

/// Tonight's sessions at the user's home venue.
///
/// Real partner-request posts at the home crag are transformed into
/// NowSessions with status derived from time + respondentIds. We then mix
/// in synthetic "recurring intent" entries for other regulars at the venue
/// who haven't posted today — until the real recurring-intent windows
/// model lands.
final tonightSessionsProvider = Provider<List<NowSession>>((ref) {
  if (ref.watch(nowDemoModeProvider) == NowDemoMode.sparse) {
    return _sparseTonight;
  }

  final currentUser = ref.watch(currentUserNotifierProvider);
  final homeCragId = currentUser?.homeGymId ?? currentUser?.homeCragId;
  if (homeCragId == null) return const [];

  final posts = ref.watch(postsAtCragProvider(homeCragId)).valueOrNull ?? [];
  final currentUserId = currentUser?.uid;

  final fromPosts = posts
      .map((p) => _sessionFromPost(p, currentUserId))
      .whereType<NowSession>()
      .toList();

  // Mix in synthetic recurring intent for regulars who haven't posted —
  // keeps the feed alive when partner-request density is low.
  final usedUserIds = {
    ...fromPosts.map((s) => s.userId),
    if (currentUserId != null) currentUserId,
  };
  final synthetic = _syntheticIntent(homeCragId)
      .where((s) => !usedUserIds.contains(s.userId))
      .toList();

  return [...fromPosts, ...synthetic]..sort(_sessionOrder);
});

/// Catch-radar bubbles — derived from tonight's sessions.
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

// ── Session derivation ────────────────────────────────────────────────────

/// Turn a partner-request post into a NowSession, or null if the post is
/// outside tonight's window (past or further out than ~12 hours).
NowSession? _sessionFromPost(ClimbingPost post, String? currentUserId) {
  final user = MockData.getUserById(post.userId);
  if (user == null) return null;

  final now = DateTime.now();
  final dt = post.dateTime;
  final diff = dt.difference(now);
  final expiresAt = post.expiresAt ?? dt.add(const Duration(hours: 2));

  // Outside the visible window — past expiry or more than 12 hours out.
  if (now.isAfter(expiresAt)) return null;
  if (diff.inHours > 12) return null;

  final isConfirmed = currentUserId != null &&
      post.respondentIds.contains(currentUserId);
  final isLive = !isConfirmed &&
      now.isAfter(dt.subtract(const Duration(hours: 1))) &&
      now.isBefore(expiresAt);

  final SessionStatus status;
  final String timeLabel;
  final String subtitle;
  if (isConfirmed) {
    status = SessionStatus.confirmed;
    timeLabel = 'landing ${_formatTime(dt)}';
    subtitle = '';
  } else if (isLive) {
    status = SessionStatus.live;
    timeLabel = 'til ${_formatTime(expiresAt)}';
    subtitle = 'on the wall now';
  } else {
    status = SessionStatus.expected;
    timeLabel = 'around ${_formatTime(dt)}';
    subtitle = '';
  }

  return NowSession(
    userId: user.uid,
    initial: user.displayName.isNotEmpty
        ? user.displayName[0].toLowerCase()
        : '?',
    name: _shortName(user.displayName),
    timeLabel: timeLabel,
    subtitle: subtitle,
    note: isConfirmed ? post.description : null,
    status: status,
  );
}

/// Strip a display name to "First L." form — "Alex Honnold Jr" → "Alex H."
String _shortName(String fullName) {
  final parts = fullName.trim().split(' ');
  if (parts.isEmpty) return fullName;
  if (parts.length == 1) return parts.first;
  return '${parts.first} ${parts[1][0]}.';
}

String _formatTime(DateTime dt) {
  final h = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
  final m = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour < 12 ? 'a' : 'p';
  return m == '00' ? '$h$ampm' : '$h:$m$ampm';
}

/// Live first, then confirmed, then expected (each block sorted alphabetically
/// for stability across renders).
int _sessionOrder(NowSession a, NowSession b) {
  final ord = a.status.index.compareTo(b.status.index);
  return ord != 0 ? ord : a.name.compareTo(b.name);
}

String _radarTime(NowSession s) {
  switch (s.status) {
    case SessionStatus.live:
      return 'HERE';
    case SessionStatus.confirmed:
      return s.timeLabel.replaceFirst('landing ', '');
    case SessionStatus.expected:
      return s.timeLabel.replaceFirst('around ', '');
  }
}

// ── Synthetic recurring intent ────────────────────────────────────────────
//
// Faked until the real model lands. Per-venue handpicked entries for
// regulars who use the gym on Tuesday evenings but haven't posted today.

List<NowSession> _syntheticIntent(String cragId) {
  return switch (cragId) {
    'gym_movement_denver' => const [
        NowSession(
          userId: 'user_5',
          initial: 's',
          name: 'Sam C.',
          timeLabel: 'til 8:30p',
          subtitle: 'on the wall now',
          status: SessionStatus.live,
        ),
        NowSession(
          userId: 'user_1',
          initial: 'a',
          name: 'Alex H.',
          timeLabel: 'around 7p',
          subtitle: 'usually Tuesdays',
          status: SessionStatus.expected,
        ),
        NowSession(
          userId: 'user_9',
          initial: 'k',
          name: 'Kira P.',
          timeLabel: 'around 7:30p',
          subtitle: 'usually Tuesdays',
          status: SessionStatus.expected,
        ),
      ],
    _ => const [],
  };
}

// ── Sparse-night demo data (Version B) ────────────────────────────────────

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

// ── Forward-load (sparse-night → Thursday peek) ───────────────────────────

class ForwardLoadedDay {
  final String dayLabel;
  final String windowLabel;
  final int usualCount;
  final List<RadarChip> peek;
  final String cta;

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
