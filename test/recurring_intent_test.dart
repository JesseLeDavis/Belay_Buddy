import 'package:belay_buddy/src/features/now/domain/recurring_intent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecurringIntent', () {
    // A standing intent: every Tuesday 5pm–8pm at Movement Denver.
    const intent = RecurringIntent(
      id: 'a',
      userId: 'u',
      cragId: 'gym_movement_denver',
      weekday: DateTime.tuesday,
      startMinute: 17 * 60,
      endMinute: 20 * 60,
    );

    group('isLiveAt', () {
      test('true when now is inside the window on the right weekday', () {
        // Tuesday 6:30pm — inside the window.
        final now = DateTime(2026, 6, 2, 18, 30);
        expect(now.weekday, DateTime.tuesday); // sanity
        expect(intent.isLiveAt(now), isTrue);
      });

      test('false right before the window opens', () {
        final now = DateTime(2026, 6, 2, 16, 59);
        expect(intent.isLiveAt(now), isFalse);
      });

      test('false at the moment the window closes (endMinute is exclusive)',
          () {
        final now = DateTime(2026, 6, 2, 20, 0);
        expect(intent.isLiveAt(now), isFalse);
      });

      test('false on a different weekday even when the time matches', () {
        final wednesday = DateTime(2026, 6, 3, 18, 30);
        expect(wednesday.weekday, DateTime.wednesday);
        expect(intent.isLiveAt(wednesday), isFalse);
      });

      test('false when intent is inactive', () {
        final tuesday = DateTime(2026, 6, 2, 18, 30);
        expect(intent.copyWith(active: false).isLiveAt(tuesday), isFalse);
      });
    });

    group('isExpectedAt', () {
      test('true when today is the right weekday and start is later', () {
        final now = DateTime(2026, 6, 2, 14, 0); // tuesday 2pm
        expect(intent.isExpectedAt(now), isTrue);
      });

      test('false once we are inside the window (now live, not expected)', () {
        final now = DateTime(2026, 6, 2, 18, 0);
        expect(intent.isExpectedAt(now), isFalse);
      });

      test('false after the window has closed', () {
        final now = DateTime(2026, 6, 2, 21, 0);
        expect(intent.isExpectedAt(now), isFalse);
      });

      test('false on a different weekday', () {
        final wednesday = DateTime(2026, 6, 3, 14, 0);
        expect(intent.isExpectedAt(wednesday), isFalse);
      });
    });

    test('copyWith preserves all fields when only active is changed', () {
      final flipped = intent.copyWith(active: false);
      expect(flipped.id, intent.id);
      expect(flipped.userId, intent.userId);
      expect(flipped.cragId, intent.cragId);
      expect(flipped.weekday, intent.weekday);
      expect(flipped.startMinute, intent.startMinute);
      expect(flipped.endMinute, intent.endMinute);
      expect(flipped.active, isFalse);
    });
  });
}
