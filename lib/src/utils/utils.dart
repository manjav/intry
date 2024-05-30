class Utils {
  /// Divide the given value by the number of divisions and round it to the nearest integer.
  /// Then, multiply the result by the number of divisions.
  ///
  /// This function is used to ensure that the value is a multiple of the number of divisions.
  ///
  /// Parameters:
  ///   - value: The value to divide.
  ///
  /// Returns:
  ///   - The value divided by the number of divisions, rounded to the nearest number,
  ///     then multiplied by the number of divisions.
  ///
  /// Example:
  ///   If the number of divisions is 10 and the value is 12.5, the result would be 10.
  ///   If the number of divisions is 10 and the value is 17, the result would be 20.
  static num divide(
    num value, {
    int divisions = 1,
  }) {
    // Divide the given value by the number of divisions and round it to the nearest number
    if (divisions < 1) {
      divisions = 1;
    }
    var dividedValue = value / divisions;
    var roundedValue = dividedValue.round();
    return roundedValue * divisions;
  }

  /// Clamps the given value to the range defined by `widget.min` and `widget.max`.
  ///
  /// If `widget.min` is not null and `value` is less than `widget.min`,
  /// the function sets `value` to `widget.min`.
  /// If `widget.max` is not null and `value` is greater than `widget.max`,
  /// the function sets `value` to `widget.max`.
  ///
  /// Parameters:
  ///   - value: The value to be clamped.
  ///
  /// Returns:
  ///   - The clamped value.
  static double clamp(
    double value, {
    required double? min,
    required double? max,
  }) {
    // Clamp the value to the range defined by `widget.min` and `widget.max`.
    // If `min` is not null and `value` is less than `min`,
    // set `value` to `min`.
    if (min != null && value < min) {
      value = min;
    }

    // If `max` is not null and `value` is greater than `max`,
    // set `value` to `max`.
    if (max != null && value > max) {
      value = max;
    }

    return value;
  }
}

/// Converts this string, which contains Persian digits, to a string with Latin digits.
extension ToLatinExtension on String {
  /// Converts this string, which contains Persian digits, to a string with Latin digits.
  ///
  /// The function uses a map to replace Persian digits with Latin digits.
  /// The map is defined as a constant inside the extension function.
  ///
  /// Returns:
  ///   - A new string with Latin digits.
  String toLatin() {
    // The map is a constant that maps Persian digits to Latin digits.
    const Map<String, String> numbers = {
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '٤': '4',
      '۵': '5',
      '٥': '5',
      '۶': '6',
      '٦': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    // The `replaceAllMapped` method replaces all occurrences of Persian digits
    // with the corresponding Latin digits. The RegExp pattern `[۰-۹]` matches
    // any Persian digit. The function passed to `replaceAllMapped` as the
    // second argument retrieves the matched Persian digit and returns the
    // corresponding Latin digit from the `numbers` map.
    return replaceAllMapped(
      RegExp('[۰-۹٤-۶]'),
      (match) => numbers[this[match.start]]!,
    );
  }
}
