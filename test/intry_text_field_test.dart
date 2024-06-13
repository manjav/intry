import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intry/intry.dart';

void main() {
  group('IntryTextField', () {
    testWidgets(
        'IntryTextField number input test should create with default value',
        (WidgetTester tester) async {
      //ARRENGE
      String defaultValue = "200";
      Widget intryText = MaterialApp(
        home: Scaffold(
          body: IntryTextField(
            formatter: "%%s",
            value: defaultValue,
            onChanged: (value) => defaultValue = value,
          ),
        ),
      );
      await tester.pumpWidget(intryText);

      //ACT
      Finder textIntryFinder = find.text("%200");

      //ASSERT
      expect(textIntryFinder, findsOneWidget);
    });
  });
}
