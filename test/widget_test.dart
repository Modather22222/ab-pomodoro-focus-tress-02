import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro_focus/main.dart';

void main() {
  testWidgets('renders the pomodoro timer with a fresh focus phase',
      (tester) async {
    await tester.pumpWidget(const PomodoroFocusApp());

    expect(find.text('Pomodoro Focus'), findsOneWidget);
    expect(find.text('Focus'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('🍅 Sessions completed: 0'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Start'), findsOneWidget);
  });
}
