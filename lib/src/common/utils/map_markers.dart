import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Orange triangle pin for crags — same scale as default Google markers.
Future<BitmapDescriptor> buildCragMarker({
  Color border = const Color(0xFF0F0F0F),
  Color fill = const Color(0xFFFF6B2B),
}) async {
  // Match default marker size (~27x43 logical pixels at 2x).
  const double dpr = 2.0;
  const double logicalW = 27.0;
  const double logicalH = 43.0;
  const double w = logicalW * dpr;
  const double h = logicalH * dpr;
  const double bw = 1.5 * dpr;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, w, h));

  // Outer shape (border)
  canvas.drawPath(_trianglePin(0, 0, w, h), Paint()..color = border);
  // Inner fill
  canvas.drawPath(_trianglePin(bw, bw * 1.2, w - bw * 2, h - bw * 2.2), Paint()..color = fill);
  // Small white dot center for Google-pin feel
  canvas.drawCircle(const Offset(w / 2, h * 0.36), 4.0 * dpr, Paint()..color = Colors.white);
  canvas.drawCircle(
    const Offset(w / 2, h * 0.36),
    4.0 * dpr,
    Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * dpr,
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(w.ceil(), h.ceil());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(data!.buffer.asUint8List());
}

/// Blue square pin for gyms — same scale as default Google markers.
Future<BitmapDescriptor> buildGymMarker({
  Color border = const Color(0xFF0F0F0F),
  Color fill = const Color(0xFF1D63D4),
}) async {
  const double dpr = 2.0;
  const double logicalW = 27.0;
  const double logicalH = 43.0;
  const double w = logicalW * dpr;
  const double h = logicalH * dpr;
  const double bw = 1.5 * dpr;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, w, h));

  // Outer shape (border)
  canvas.drawPath(_squarePin(0, 0, w, h), Paint()..color = border);
  // Inner fill
  canvas.drawPath(_squarePin(bw, bw, w - bw * 2, h - bw * 2), Paint()..color = fill);
  // Small white dot center for Google-pin feel
  const double boxH = h * 0.58;
  canvas.drawCircle(const Offset(w / 2, boxH / 2), 4.0 * dpr, Paint()..color = Colors.white);
  canvas.drawCircle(
    const Offset(w / 2, boxH / 2),
    4.0 * dpr,
    Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * dpr,
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(w.ceil(), h.ceil());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(data!.buffer.asUint8List());
}

/// Triangle top tapering to a point at the bottom.
Path _trianglePin(double x, double y, double w, double h) {
  final cx = x + w / 2;
  final triH = h * 0.58;
  final pinTip = y + h;
  return Path()
    ..moveTo(cx, y) // top point
    ..lineTo(x + w, y + triH) // bottom-right of triangle
    ..lineTo(cx + w * 0.12, y + triH)
    ..lineTo(cx, pinTip) // pin tip
    ..lineTo(cx - w * 0.12, y + triH)
    ..lineTo(x, y + triH) // bottom-left of triangle
    ..close();
}

/// Square top with rounded corners, tapering to a point at the bottom.
Path _squarePin(double x, double y, double w, double h) {
  final cx = x + w / 2;
  final boxH = h * 0.58;
  final pinTip = y + h;
  final r = w * 0.1;
  return Path()
    ..moveTo(x + r, y)
    ..lineTo(x + w - r, y)
    ..arcToPoint(Offset(x + w, y + r), radius: Radius.circular(r))
    ..lineTo(x + w, y + boxH - r)
    ..arcToPoint(Offset(x + w - r, y + boxH), radius: Radius.circular(r))
    ..lineTo(cx + w * 0.12, y + boxH)
    ..lineTo(cx, pinTip) // pin tip
    ..lineTo(cx - w * 0.12, y + boxH)
    ..lineTo(x + r, y + boxH)
    ..arcToPoint(Offset(x, y + boxH - r), radius: Radius.circular(r))
    ..lineTo(x, y + r)
    ..arcToPoint(Offset(x + r, y), radius: Radius.circular(r))
    ..close();
}
