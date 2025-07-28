// This is a basic Flutter widget test for the Homework Solver app.

import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/main.dart';

void main() {
  testWidgets('Homework Solver app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeworkSolverApp());

    // Verify that the app title appears.
    expect(find.text('Homework Solver'), findsOneWidget);

    // Verify that the photo upload instruction text appears.
    expect(find.textContaining('Take or select a photo'), findsOneWidget);

    // Verify that the Add Photo button exists.
    expect(find.textContaining('Add Photo'), findsOneWidget);

    // Verify that the Solve button exists.
    expect(find.textContaining('Solve'), findsOneWidget);
  });
}
