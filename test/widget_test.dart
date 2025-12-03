import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthmate/main.dart';

void main() {
  testWidgets('HealthMate app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HealthMateApp());
    await tester.pumpAndSettle();

    expect(find.text('HealthMate'), findsOneWidget);
    expect(find.text('Your Personal Health Companion'), findsOneWidget);
  });
}

