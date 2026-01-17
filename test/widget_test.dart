// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mindease/main.dart';

void main() {
  testWidgets('MindEase app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MindEaseApp());

    // Verify that the app title is present.
    expect(find.text('MindEase'), findsWidgets);

    // Verify that navigation tabs are present.
    expect(find.text('Affirm'), findsOneWidget);
    expect(find.text('Music'), findsOneWidget);
    expect(find.text('Journal'), findsOneWidget);
    expect(find.text('Mood'), findsOneWidget);
  });
}
