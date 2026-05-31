import 'dart:ui';

/// The Chalk & Static signature path — a topo-style polyline with sharp
/// corners and alternating perpendicular bows.
///
/// Five waypoint patterns; the seed (typically `userId.hashCode`) picks one
/// deterministically so each climber gets their own signature route. Used
/// both for the Route Line overlay on confirmation and for the persistent
/// trace next to each entry in the connections list.

/// `(fraction-along-path, perpendicular-bow-as-fraction-of-distance)`.
typedef RouteBeat = (double, double);

const _patterns = <List<RouteBeat>>[
  // 0 — Gentle: balanced bows, no drama. The friendly route.
  [(0.22, 0.08), (0.45, -0.10), (0.68, 0.07), (0.85, -0.05)],
  // 1 — Crux middle: small at the start, big swing in the middle.
  [(0.18, 0.05), (0.40, -0.13), (0.55, 0.14), (0.80, -0.06)],
  // 2 — Top-heavy: long approach, sharper finishing moves.
  [(0.30, 0.06), (0.55, -0.05), (0.72, 0.11), (0.88, -0.09)],
  // 3 — Wandering: 6 small beats. A sustained pitch.
  [
    (0.16, 0.06), (0.30, -0.09), (0.46, 0.07),
    (0.62, -0.08), (0.78, 0.06), (0.90, -0.04),
  ],
  // 4 — Traverse: 3 bigger lateral throws, fewer waypoints.
  [(0.25, 0.13), (0.50, -0.10), (0.78, 0.12)],
];

List<RouteBeat> patternForSeed(int seed) =>
    _patterns[seed.abs() % _patterns.length];

/// Build a topo-style polyline path from `start` to `end` using the pattern
/// seeded by `seed`. Sharp `lineTo` corners; bows perpendicular to the
/// direct path.
Path buildRoutePath({
  required Offset start,
  required Offset end,
  required int seed,
}) {
  final path = Path()..moveTo(start.dx, start.dy);
  final delta = end - start;
  final dist = delta.distance;
  if (dist < 1) {
    path.lineTo(end.dx, end.dy);
    return path;
  }

  final perp = Offset(-delta.dy, delta.dx) / dist;
  final beats = patternForSeed(seed);

  for (final beat in beats) {
    final p = start + delta * beat.$1 + perp * (dist * beat.$2);
    path.lineTo(p.dx, p.dy);
  }
  path.lineTo(end.dx, end.dy);

  return path;
}
