// Smoke test — does the root widget tree build without throwing?
//
// We don't pump frames or wait for the router because the GoRouter setup
// kicks off async work that's brittle in a test harness. The point is to
// catch the case where the root widget itself fails to build.

import 'package:belay_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BelayBuddyApp builds', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BelayBuddyApp()),
    );
    expect(find.byType(BelayBuddyApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
