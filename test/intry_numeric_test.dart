import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intry/intry.dart';

void main() {
  group('IntryNumericField', () {
    testWidgets(
        'IntryNumericField number input test should create with default value',
        (WidgetTester tester) async {
      //ARRENGE
      double defaultValue = 10;
      Widget intryNumber = MaterialApp(
        home: Scaffold(
          body: IntryNumericField(
            min: 0,
            max: 100,
            value: defaultValue,
            onChanged: (value) => defaultValue = value,
          ),
        ),
      );
      await tester.pumpWidget(intryNumber);

      //ACT
      Finder numericIntryFinder = find.text("10");

      //ASSERT
      expect(numericIntryFinder, findsOneWidget);
    });

    testWidgets(
        'IntryNumericField number input test vertical drag to up should changed the currentValue',
        (WidgetTester tester) async {
      //ARRENGE
      double currentValue = 0;
      Widget intryNumber = MaterialApp(
        home: Scaffold(
          body: IntryNumericField(
            min: -100,
            max: 100,
            value: currentValue,
            onChanged: (value) => currentValue = value,
          ),
        ),
      );
      await tester.pumpWidget(intryNumber);

      Finder intryFinder = find.byType(IntryNumericField);

      expect(intryFinder, findsOneWidget);

      await tester.drag(intryFinder, const Offset(0, -100));
      await tester.pumpAndSettle();

      //ASSERT
      expect(currentValue, isNot(0.0));
    });
  });
}
