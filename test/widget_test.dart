// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:krishi_sarthi/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KrishiSarthiApp());

    // Verify that our counter starts at 0.
    // Note: Since the real app doesn't have a counter, this test will fail.
    // I will update it to a basic sanity check of the splash screen.
    expect(find.byIcon(Icons.agriculture), findsOneWidget);
  });
}
