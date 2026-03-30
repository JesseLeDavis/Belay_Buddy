import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> buildCragMarker() => _buildMarker(isGym: false);
Future<BitmapDescriptor> buildGymMarker() => _buildMarker(isGym: true);

Future<BitmapDescriptor> _buildMarker({required bool isGym}) async {
  const double w = 64;
  const double bodyH = 64;
  const double tipH = 14;
  const double border = 4.0;
  const double canvasW = w + 6;
  const double canvasH = bodyH + tipH + 6;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, canvasW, canvasH));

  const navy = Color(0xFF0F0F0F);
  final fill = isGym ? const Color(0xFF1D63D4) : const Color(0xFFFF6B2B);

  // Shadow
  canvas.drawPath(
    _pinPath(5, 5, w, bodyH, tipH),
    Paint()..color = const Color(0x55000000),
  );

  // Navy outline
  canvas.drawPath(_pinPath(0, 0, w, bodyH, tipH), Paint()..color = navy);

  // Colored fill (inset by border)
  canvas.drawPath(
    _pinPath(border, border, w - border * 2, bodyH - border * 2, tipH - 2),
    Paint()..color = fill,
  );

  // Icon
  final iconRect = Rect.fromLTWH(
    border + 8, border + 8,
    w - border * 2 - 16, bodyH - border * 2 - 16,
  );
  if (isGym) {
    _drawBuilding(canvas, iconRect);
  } else {
    _drawMountain(canvas, iconRect);
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(canvasW.ceil(), canvasH.ceil());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(data!.buffer.asUint8List());
}

Path _pinPath(double x, double y, double w, double h, double tipH) {
  return Path()
    ..moveTo(x, y)
    ..lineTo(x + w, y)
    ..lineTo(x + w, y + h)
    ..lineTo(x + w / 2 + tipH * 0.6, y + h)
    ..lineTo(x + w / 2, y + h + tipH)
    ..lineTo(x + w / 2 - tipH * 0.6, y + h)
    ..lineTo(x, y + h)
    ..close();
}

void _drawMountain(Canvas canvas, Rect area) {
  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  // Background peak (slightly lighter)
  canvas.drawPath(
    Path()
      ..moveTo(area.left + area.width * 0.55, area.top + area.height * 0.2)
      ..lineTo(area.right, area.bottom)
      ..lineTo(area.left + area.width * 0.3, area.bottom)
      ..close(),
    Paint()..color = Colors.white.withAlpha(100),
  );

  // Main peak
  canvas.drawPath(
    Path()
      ..moveTo(area.center.dx, area.top)
      ..lineTo(area.right, area.bottom)
      ..lineTo(area.left, area.bottom)
      ..close(),
    paint,
  );
}

void _drawBuilding(Canvas canvas, Rect area) {
  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  final l = area.left;
  final t = area.top;
  final w = area.width;
  final h = area.height;

  // Main body
  canvas.drawRect(Rect.fromLTWH(l + w * 0.1, t + h * 0.3, w * 0.8, h * 0.7), paint);

  // Taller center tower
  canvas.drawRect(Rect.fromLTWH(l + w * 0.3, t, w * 0.4, h * 0.75), paint);

  // Windows (dark cutouts)
  final windowPaint = Paint()
    ..color = const Color(0xFF1D63D4)
    ..style = PaintingStyle.fill;
  final winW = w * 0.18;
  final winH = h * 0.18;
  final winY = t + h * 0.45;
  canvas.drawRect(Rect.fromLTWH(l + w * 0.14, winY, winW, winH), windowPaint);
  canvas.drawRect(Rect.fromLTWH(l + w * 0.68, winY, winW, winH), windowPaint);
  canvas.drawRect(Rect.fromLTWH(l + w * 0.38, t + h * 0.12, w * 0.24, winH), windowPaint);
}
