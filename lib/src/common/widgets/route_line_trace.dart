import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/features/now/domain/route_pattern.dart';
import 'package:flutter/material.dart';

/// A small static rendering of a climber's signature route. Drawn bottom-up
/// in a vertical box — the persistent trace left next to their name in the
/// connections list.
///
/// Each climber's `seed` (typically `userId.hashCode`) picks one of five
/// waypoint patterns so the same climber always carries the same shape.
class RouteLineTrace extends StatelessWidget {
  final int seed;
  final double width;
  final double height;

  const RouteLineTrace({
    super.key,
    required this.seed,
    this.width = 18,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _TracePainter(seed: seed, ink: c.ink),
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final int seed;
  final Color ink;

  _TracePainter({required this.seed, required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    // Bottom-up, like a real climb. Pad a little so the ends don't kiss
    // the edges of the box.
    final start = Offset(centerX, size.height - 2);
    final end = Offset(centerX, 2);
    final path = buildRoutePath(start: start, end: end, seed: seed);

    final paint = Paint()
      ..color = ink
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);

    // Anchor dots at base and summit — same visual vocabulary as the
    // animated overlay.
    final dot = Paint()..color = ink;
    canvas.drawCircle(start, 1.8, dot);
    canvas.drawCircle(end, 1.8, dot);
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.seed != seed || old.ink != ink;
}
