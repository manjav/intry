import 'package:flutter_test/flutter_test.dart';
import 'package:intry/intry.dart';

void main() {
  group('Utils.clamp', () {
    test('returns the input value if it is within the range', () {
      // Arrange
      double value = 5;
      double min = 0;
      double max = 10;

      // Act
      final result = Utils.clamp(value, min: min, max: max);

      // Assert
      expect(result, equals(value));
    });

    test('sets the input value to min if it is less than min', () {
      // Arrange
      double value = -1;
      double min = 0;
      double max = 10;

      // Act
      final result = Utils.clamp(value, min: min, max: max);

      // Assert
      expect(result, equals(min));
    });

    test('sets the input value to max if it is greater than max', () {
      // Arrange
      double value = 11;
      double min = 0;
      double max = 10;

      // Act
      final result = Utils.clamp(value, min: min, max: max);

      // Assert
      expect(result, equals(max));
    });
  });

  group('Utils.divide', () {
    test(
        'should divide the given value by the number of divisions and round it to the nearest integer',
        () {
      expect(Utils.divide(12.5, divisions: 10), equals(10));
      expect(Utils.divide(17, divisions: 10), equals(20));
    });
    test(
        'should return the given value if the number of divisions is less than 1',
        () {
      expect(Utils.divide(12.5, divisions: 0), equals(12.5));
      expect(Utils.divide(17, divisions: -1), equals(17));
    });
    test('should handle fractional values', () {
      expect(Utils.divide(12.75, divisions: 2), equals(12));
      expect(Utils.divide(17.25, divisions: 5), equals(15));
    });
    test('should handle negative values', () {
      expect(Utils.divide(-12.5, divisions: 10), equals(-10));
      expect(Utils.divide(-17, divisions: 10), equals(-20));
    });
    test('should handle zero values', () {
      expect(Utils.divide(0, divisions: 10), equals(0));
    });
  });

  test('Replace Persian / Arabic digits with Latin digits', () {
    expect(
      '۰۱۲۳۴۵۶۷۸۹'.toLatin(),
      equals('0123456789'),
    );
    expect('۰۴٥۶۷۸'.toLatin(), equals('045678'));
    expect(''.toLatin(), equals(''));
    expect('abcdefghijklmnopqrstuvwxyz'.toLatin(),
        equals('abcdefghijklmnopqrstuvwxyz'));
    expect('numbers۱۳۵'.toLatin(), equals('numbers135'));
  });
}
