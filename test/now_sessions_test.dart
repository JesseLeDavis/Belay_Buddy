import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/now/data/now_repository.dart';
import 'package:belay_buddy/src/features/now/data/recurring_intents_repository.dart';
import 'package:belay_buddy/src/features/now/domain/now_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('tonightSessionsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('returns a non-empty list for the seeded home gym in dense mode', () {
      final sessions = container.read(tonightSessionsProvider);
      expect(sessions, isNotEmpty,
          reason: 'Tess + Movement Denver should always have recurring '
              'intents firing today');
    });

    test('sorts live → confirmed → expected, alphabetical within', () {
      final sessions = container.read(tonightSessionsProvider);
      var lastStatusIndex = -1;
      String? lastNameInBlock;
      for (final s in sessions) {
        expect(
          s.status.index >= lastStatusIndex,
          isTrue,
          reason:
              'Session "${s.name}" (${s.status}) appeared after a later-status block',
        );
        if (s.status.index == lastStatusIndex) {
          expect(
            s.name.compareTo(lastNameInBlock!) >= 0,
            isTrue,
            reason: 'Within ${s.status} block, "${s.name}" out of order',
          );
        } else {
          lastStatusIndex = s.status.index;
          lastNameInBlock = null;
        }
        lastNameInBlock ??= s.name;
      }
    });

    test('never surfaces the current user in the feed', () {
      final me = container.read(currentUserIdSyncProvider);
      final sessions = container.read(tonightSessionsProvider);
      expect(sessions.where((s) => s.userId == me), isEmpty);
    });

    test('sparse mode returns only the sparse seed data', () {
      container.read(nowDemoModeProvider.notifier).state = NowDemoMode.sparse;
      final sessions = container.read(tonightSessionsProvider);
      // Sparse mock has 2 hardcoded entries; should not exceed that count.
      expect(sessions.length, 2);
      // Sparse data is all expected — no live or confirmed.
      expect(
        sessions.every((s) => s.status == SessionStatus.expected),
        isTrue,
      );
    });
  });

  group('forwardLoadedDayProvider', () {
    // The "null in dense mode" assertion is brittle in a test harness — the
    // stream provider that supplies posts hasn't emitted yet, so we can't
    // reliably tell whether dense mode has any live/confirmed sessions.
    // We only test the deterministic sparse case.

    test('non-null when night is sparse', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(nowDemoModeProvider.notifier).state = NowDemoMode.sparse;
      final day = container.read(forwardLoadedDayProvider);
      expect(day, isNotNull);
      expect(day!.dayLabel, 'THU');
    });
  });

  group('radarChipsProvider', () {
    test('one chip per session in the same order', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final sessions = container.read(tonightSessionsProvider);
      final chips = container.read(radarChipsProvider);
      expect(chips.length, sessions.length);
      for (var i = 0; i < chips.length; i++) {
        expect(chips[i].userId, sessions[i].userId);
      }
    });

    test('live chip reads "HERE", expected chip starts with a digit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final chips = container.read(radarChipsProvider);
      for (final chip in chips) {
        switch (chip.status) {
          case SessionStatus.live:
            expect(chip.timeLabel, 'HERE');
          case SessionStatus.expected:
            expect(
              RegExp(r'^\d').hasMatch(chip.timeLabel),
              isTrue,
              reason: 'expected chip should start with a digit, got '
                  '"${chip.timeLabel}"',
            );
          case SessionStatus.confirmed:
            // confirmed chips strip "landing " prefix → starts with digit
            expect(RegExp(r'^\d').hasMatch(chip.timeLabel), isTrue);
        }
      }
    });
  });

  group('recurringIntentsProvider', () {
    test('starts with the seeded denver intents', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final intents = container.read(recurringIntentsProvider);
      expect(intents, isNotEmpty);
      final denverIntents =
          intents.where((i) => i.cragId == 'gym_movement_denver').toList();
      expect(denverIntents.length, greaterThanOrEqualTo(3));
    });

    test('add() appends and remove() drops', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(recurringIntentsProvider.notifier);
      final before = container.read(recurringIntentsProvider).length;
      notifier.add(
        userId: 'test_user',
        cragId: 'gym_movement_denver',
        weekday: DateTime.friday,
        startMinute: 17 * 60,
        endMinute: 20 * 60,
      );
      final after = container.read(recurringIntentsProvider);
      expect(after.length, before + 1);
      final added = after.firstWhere((i) => i.userId == 'test_user');
      notifier.remove(added.id);
      expect(container.read(recurringIntentsProvider).length, before);
    });
  });
}
