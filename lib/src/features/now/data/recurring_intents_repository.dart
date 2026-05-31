import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/now/domain/recurring_intent.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory store of recurring intent windows. Seeded with mock data that
/// always fires "today" so the demo stays alive regardless of which weekday
/// the app is opened on.
///
/// Production wires this to Firestore; for now it's a StateNotifier so
/// new intents written from the forward-load sheet are visible immediately.
class RecurringIntentsNotifier extends StateNotifier<List<RecurringIntent>> {
  RecurringIntentsNotifier() : super(_seed());

  /// Add a new intent for `userId` at `cragId` on the current weekday.
  void add({
    required String userId,
    required String cragId,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) {
    final id = 'intent_${state.length + 1}_${DateTime.now().millisecondsSinceEpoch}';
    state = [
      ...state,
      RecurringIntent(
        id: id,
        userId: userId,
        cragId: cragId,
        weekday: weekday,
        startMinute: startMinute,
        endMinute: endMinute,
      ),
    ];
  }

  void remove(String id) {
    state = state.where((i) => i.id != id).toList();
  }

  static List<RecurringIntent> _seed() {
    // Lock the weekday to today so the demo's "usually Tuesdays" data
    // surfaces regardless of when the user opens the app.
    final today = DateTime.now().weekday;
    const denver = 'gym_movement_denver';
    return [
      // Alex H. — usually here early evening. Already on the wall now.
      RecurringIntent(
        id: 'intent_alex_denver',
        userId: 'user_1',
        cragId: denver,
        weekday: today,
        startMinute: 17 * 60, // 5pm
        endMinute: 19 * 60, // 7pm
      ),
      // Sam C. — on the wall now, lingers later than most.
      RecurringIntent(
        id: 'intent_sam_denver',
        userId: 'user_5',
        cragId: denver,
        weekday: today,
        startMinute: 17 * 60 + 30, // 5:30pm
        endMinute: 20 * 60 + 30, // 8:30pm
      ),
      // Kira P. — shows up after work.
      RecurringIntent(
        id: 'intent_kira_denver',
        userId: 'user_9',
        cragId: denver,
        weekday: today,
        startMinute: 19 * 60 + 30, // 7:30pm
        endMinute: 22 * 60, // 10pm
      ),
      // A Thursday entry so the sparse-night peek shows real users.
      const RecurringIntent(
        id: 'intent_alex_denver_thu',
        userId: 'user_1',
        cragId: denver,
        weekday: DateTime.thursday,
        startMinute: 17 * 60,
        endMinute: 20 * 60,
      ),
    ];
  }
}

final recurringIntentsProvider = StateNotifierProvider<
    RecurringIntentsNotifier, List<RecurringIntent>>(
  (ref) => RecurringIntentsNotifier(),
);

/// Active intents at a venue that fire today, excluding the current user
/// (no point surfacing yourself in your own feed).
final tonightIntentsAtCragProvider =
    Provider.family<List<RecurringIntent>, String>((ref, cragId) {
  final all = ref.watch(recurringIntentsProvider);
  final me = ref.watch(currentUserIdSyncProvider);
  final now = DateTime.now();
  return all.where((i) {
    if (i.userId == me) return false;
    if (i.cragId != cragId) return false;
    if (i.weekday != now.weekday || !i.active) return false;
    // Drop intents whose window has fully passed.
    final m = now.hour * 60 + now.minute;
    return i.endMinute > m;
  }).toList();
});

/// Intents the current user has created. Used by ME → "My availability".
final myIntentsProvider = Provider<List<RecurringIntent>>((ref) {
  final all = ref.watch(recurringIntentsProvider);
  final me = ref.watch(currentUserIdSyncProvider);
  return all.where((i) => i.userId == me && i.active).toList();
});

/// Whether the current user has any intent at the given crag (any weekday).
/// Used by the forward-load sheet to detect whether the user already
/// committed.
final hasIntentAtCragProvider = Provider.family<bool, String>((ref, cragId) {
  final mine = ref.watch(myIntentsProvider);
  return mine.any((i) => i.cragId == cragId);
});

/// Whether the current user has an intent at the given crag for a specific
/// weekday.
final hasIntentForWeekdayProvider =
    Provider.family<bool, ({String cragId, int weekday})>((ref, args) {
  final mine = ref.watch(myIntentsProvider);
  return mine.any((i) => i.cragId == args.cragId && i.weekday == args.weekday);
});

/// Avoid pulling in MockData here — that's the repository's job. Kept thin.
String displayNameFor(String userId) {
  return MockData.getUserById(userId)?.displayName ?? '?';
}
