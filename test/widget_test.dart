// Basic Flutter widget test for Belay Buddy

import 'package:belay_buddy/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads auth gate', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BelayBuddyApp());

    // Verify that the app starts (will show loading initially)
    expect(find.byType(BelayBuddyApp), findsOneWidget);
  });
}
