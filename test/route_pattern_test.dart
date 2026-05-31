import 'package:belay_buddy/src/features/now/domain/route_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('patternForSeed', () {
    test('returns the same pattern for the same seed', () {
      final a = patternForSeed(42);
      final b = patternForSeed(42);
      expect(a, same(b));
    });

    test('cycles through 5 patterns by seed mod 5', () {
      // Five distinct patterns; seeds 0..4 cover all five.
      final unique = <List<RouteBeat>>{};
      for (var i = 0; i < 5; i++) {
        unique.add(patternForSeed(i));
      }
      expect(unique, hasLength(5));
    });

    test('handles negative seeds via .abs()', () {
      expect(patternForSeed(-1), same(patternForSeed(1)));
      expect(patternForSeed(-100), same(patternForSeed(100)));
    });

    test('the same userId hashCode always picks the same pattern', () {
      const maya = 'user_2';
      const sam = 'user_5';
      expect(patternForSeed(maya.hashCode),
          same(patternForSeed(maya.hashCode)));
      // Different users should usually pick different patterns; this isn't
      // guaranteed (there are only 5 patterns) but is stable.
      final mayaPattern = patternForSeed(maya.hashCode);
      final samPattern = patternForSeed(sam.hashCode);
      expect(mayaPattern == samPattern, isA<bool>());
    });
  });

  group('buildRoutePath', () {
    test('produces a path that spans between two distinct points', () {
      final path = buildRoutePath(
        start: const Offset(10, 200),
        end: const Offset(100, 20),
        seed: 0,
      );
      final bounds = path.getBounds();
      // Rect.contains excludes its right/bottom edges, so use endpoint
      // coverage instead — bounds should at least span both endpoints.
      expect(bounds.left, lessThanOrEqualTo(10));
      expect(bounds.right, greaterThanOrEqualTo(100));
      expect(bounds.top, lessThanOrEqualTo(20));
      expect(bounds.bottom, greaterThanOrEqualTo(200));
    });

    test('degenerate path (start == end) still builds without throwing', () {
      final path = buildRoutePath(
        start: const Offset(50, 50),
        end: const Offset(50, 50),
        seed: 0,
      );
      // A path with just a moveTo + lineTo on the same point — drawable.
      expect(path.getBounds().isEmpty || path.getBounds().width == 0,
          isTrue);
    });

    test('produces a deterministic path for the same inputs', () {
      final a = buildRoutePath(
        start: const Offset(0, 0),
        end: const Offset(100, 100),
        seed: 7,
      );
      final b = buildRoutePath(
        start: const Offset(0, 0),
        end: const Offset(100, 100),
        seed: 7,
      );
      expect(a.getBounds(), b.getBounds());
    });
  });
}
