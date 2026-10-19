import 'package:flutter_test/flutter_test.dart';

import 'package:dismissible_task_demo/main.dart';

void main() {
  testWidgets('shows the task inbox and presentation controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskSwipeDemo());

    expect(find.text('Swipe to clear'), findsOneWidget);
    expect(find.text('Reply to project feedback'), findsOneWidget);
    expect(find.text('direction = endToStart'), findsOneWidget);
    expect(find.text('background = shown'), findsOneWidget);
    expect(find.text('resizeDuration = 300 ms'), findsOneWidget);
  });

  testWidgets('swiping a task removes it and offers undo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskSwipeDemo());

    await tester.drag(
      find.text('Reply to project feedback'),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reply to project feedback'), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);
  });
}
