import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> buildCragMarker({
  Color navy = const Color(0xFF0F0F0F),
  Color fill = const Color(0xFFFF6B2B),
  Color iconColor = const Color(0xFFFFFFFF),
}) =>
    _buildMarker(isGym: false, navy: navy, fill: fill, iconColor: iconColor);

Future<BitmapDescriptor> buildGymMarker({
  Color navy = const Color(0xFF0F0F0F),
  Color fill = const Color(0xFF1D63D4),
  Color iconColor = const Color(0xFFFFFFFF),
}) =>
    _buildMarker(isGym: true, navy: navy, fill: fill, iconColor: iconColor);

Future<BitmapDescriptor> _buildMarker({
  required bool isGym,
  required Color navy,
  required Color fill,
  required Color iconColor,
}) async {
  // Render at 2x for retina, but keep the logical size compact.
  const double s = 2.0;
  const double w = 48 * s;
  const double bodyH = 48 * s;
  const double tipH = 12 * s;
  const double border = 3.0 * s;
  const double shadowOff = 4.0 * s;
  const double canvasW = w + shadowOff;
  const double canvasH = bodyH + tipH + shadowOff;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, canvasW, canvasH));

  // navy, fill, and iconColor are now passed as parameters

  // Hard-offset shadow
  canvas.drawPath(
    _pinPath(shadowOff, shadowOff, w, bodyH, tipH),
    Paint()..color = navy.withAlpha(70),
  );

  // Dark outline
  canvas.drawPath(_pinPath(0, 0, w, bodyH, tipH), Paint()..color = navy);

  // Color fill
  canvas.drawPath(
    _pinPath(border, border, w - border * 2, bodyH - border * 2, tipH - 2 * s),
    Paint()..color = fill,
  );

  // Icon area (centered in the body)
  const iconInset = border + 8 * s;
  const iconRect = Rect.fromLTWH(
    iconInset,
    iconInset,
    w - iconInset * 2,
    bodyH - iconInset * 2,
  );

  if (isGym) {
    _drawGymIcon(canvas, iconRect, s, iconColor: iconColor, fill: fill);
  } else {
    _drawCragIcon(canvas, iconRect, s, iconColor: iconColor, fill: fill);
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(canvasW.ceil(), canvasH.ceil());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(data!.buffer.asUint8List());
}

Path _pinPath(double x, double y, double w, double h, double tipH) {
  final r = w * 0.08; // proportional corner rounding
  return Path()
    ..moveTo(x + r, y)
    ..lineTo(x + w - r, y)
    ..arcToPoint(Offset(x + w, y + r), radius: Radius.circular(r))
    ..lineTo(x + w, y + h - r)
    ..arcToPoint(Offset(x + w - r, y + h), radius: Radius.circular(r))
    ..lineTo(x + w / 2 + tipH * 0.5, y + h)
    ..lineTo(x + w / 2, y + h + tipH)
    ..lineTo(x + w / 2 - tipH * 0.5, y + h)
    ..lineTo(x + r, y + h)
    ..arcToPoint(Offset(x, y + h - r), radius: Radius.circular(r))
    ..lineTo(x, y + r)
    ..arcToPoint(Offset(x + r, y), radius: Radius.circular(r))
    ..close();
}

/// Crag icon — bold two-peak mountain with snow cap.
/// Kept to 3 shapes so it reads crisp at small size.
void _drawCragIcon(Canvas canvas, Rect a, double s,
    {required Color iconColor, required Color fill}) {
  final iconPaint = Paint()
    ..color = iconColor
    ..style = PaintingStyle.fill;

  // Back peak (smaller, offset right, semi-transparent)
  canvas.drawPath(
    Path()
      ..moveTo(a.left + a.width * 0.62, a.top + a.height * 0.25)
      ..lineTo(a.right, a.bottom)
      ..lineTo(a.left + a.width * 0.35, a.bottom)
      ..close(),
    Paint()..color = iconColor.withAlpha(100),
  );

  // Main peak
  final peakX = a.left + a.width * 0.38;
  final peakY = a.top;
  canvas.drawPath(
    Path()
      ..moveTo(peakX, peakY)
      ..lineTo(a.right - a.width * 0.1, a.bottom)
      ..lineTo(a.left, a.bottom)
      ..close(),
    iconPaint,
  );

  // Snow cap — clean triangle cutout at the summit
  final capH = a.height * 0.32;
  final capW = capH * 0.7;
  canvas.drawPath(
    Path()
      ..moveTo(peakX, peakY)
      ..lineTo(peakX + capW, peakY + capH)
      ..lineTo(peakX - capW, peakY + capH)
      ..close(),
    Paint()..color = fill, // match crag fill to "punch out"
  );

  // Re-draw snow in slightly transparent white so it's visible but distinct
  canvas.drawPath(
    Path()
      ..moveTo(peakX, peakY)
      ..lineTo(peakX + capW, peakY + capH)
      ..lineTo(peakX - capW, peakY + capH)
      ..close(),
    Paint()..color = iconColor.withAlpha(180),
  );
}

/// Gym icon — bold climbing wall with 3 holds.
/// Angled wall silhouette + chunky hold dots = instantly readable.
void _drawGymIcon(Canvas canvas, Rect a, double s,
    {required Color iconColor, required Color fill}) {
  final iconPaint = Paint()
    ..color = iconColor
    ..style = PaintingStyle.fill;
  final holdFill = Paint()
    ..color = fill
    ..style = PaintingStyle.fill;

  // Angled wall slab
  canvas.drawPath(
    Path()
      ..moveTo(a.left + a.width * 0.12, a.bottom)
      ..lineTo(a.left + a.width * 0.28, a.top)
      ..lineTo(a.right, a.top)
      ..lineTo(a.right, a.bottom)
      ..close(),
    iconPaint,
  );

  // Three bold climbing holds (staggered)
  final holdR = 3.6 * s;
  final holds = [
    Offset(a.left + a.width * 0.52, a.top + a.height * 0.28),
    Offset(a.left + a.width * 0.72, a.top + a.height * 0.55),
    Offset(a.left + a.width * 0.48, a.top + a.height * 0.78),
  ];
  for (final pt in holds) {
    canvas.drawCircle(pt, holdR, holdFill);
    canvas.drawCircle(
      pt,
      holdR,
      Paint()
        ..color = iconColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s,
    );
  }
}
