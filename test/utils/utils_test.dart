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

}
