import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intry/intry.dart';

void main() {
  group('NumericIntry with inputType = number', () {
    testWidgets(
        'NumericIntry number input test should create with default value',
        (WidgetTester tester) async {
      //ARRENGE
      double defaultValue = 10;
      Widget intryNumber = MaterialApp(
        home: Scaffold(
          body: NumericIntry(
            inputType: IntryInputType.number,
            min: 0,
            max: 100,
            value: defaultValue,
            onNumberChanged: (value) => defaultValue = value,
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
        'NumericIntry number input test vertical drag to up should changed the currentValue',
        (WidgetTester tester) async {
      //ARRENGE
      double currentValue = 0;
      Widget intryNumber = MaterialApp(
        home: Scaffold(
          body: NumericIntry(
            inputType: IntryInputType.number,
            min: -100,
            max: 100,
            value: currentValue,
            onNumberChanged: (value) => currentValue = value,
          ),
        ),
      );
      await tester.pumpWidget(intryNumber);

      Finder intryFinder=find.byType(NumericIntry);

      expect(intryFinder, findsOneWidget);

      //ACT
      // await tester.tap(find.byType(NumericIntry));
      // await tester.pumpAndSettle();

      await tester.drag(intryFinder, const Offset(0, -100));
      await tester.pumpAndSettle();

      //ASSERT
      expect(currentValue, isNot(0.0));
    });
  });
}
