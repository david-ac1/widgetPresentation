import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dismissible_task_demo/main.dart';

void main() {
  testWidgets('shows the mailbox and swipe preferences', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MailboxApp());

    expect(find.text('Mailbox'), findsOneWidget);
    expect(find.text('Maya Chen'), findsOneWidget);
    expect(find.text('Swipe left on a message to archive it.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Swipe preferences'), findsOneWidget);
    expect(find.text('direction = endToStart'), findsOneWidget);
    expect(find.text('background = shown'), findsOneWidget);
    expect(find.text('resizeDuration = 300 ms'), findsOneWidget);
  });

  testWidgets('swiping a task removes it and offers undo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MailboxApp());

    await tester.drag(find.text('Maya Chen'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Maya Chen'), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);
  });
}
