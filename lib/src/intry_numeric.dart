import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intry/intry.dart';
import 'package:math_parser/math_parser.dart';

/// A library for creating a numeric input widget.
///
/// The [NumericIntry] widget provides a numeric input field with
/// configurable minimum and maximum values, initial value,
/// number of divisions, and postfix. It also provides a callback
/// function that gets called when the value changes.
///
/// To use this library, import `package:intry_numeric/intry_numeric.dart`.

class NumericIntry extends BasicIntry {
  /// The minimum value for the numeric input.
  final double? min;

  /// The maximum value for the numeric input.
  final double? max;

  /// The initial value for the input.
  final double value;

  /// Represents the list of divisions to display.
  /// Each division should be an object with the following properties:
  /// - `name`: The name of the division.
  /// - `value`: The value of the division.
  ///
  /// Type: int
  ///
  /// Default: 1
  final int divisions;

  /// Represents the speed at which the animation progresses.
  /// The value should be a number greater than 0.
  /// A higher value indicates faster changes.
  ///
  /// Type: double
  ///
  /// Default: 0.2
  final double slidingSpeed;

  /// The direction in which the value can be slid.
  ///
  /// Possible values are [Axis.horizontal] and [Axis.vertical].
  ///
  /// Default: Axis.vertical
  final Axis slidingDirection;

  /// Represents the number of decimal places to round the fraction.
  /// The value should be a non-negative integer.
  /// A higher value indicates more decimal places to round.
  ///
  /// Type: int
  ///
  /// Default: 0
  final int fractionDigits;

  /// The callback function that gets called when the value changes.
  final ValueChanged<double>? onChanged;

  /// Initializes the [NumericIntry] widget with the provided parameters.
  ///
  /// The [min] parameter sets the minimum value for the widget. If provided, the
  /// [value] will be clamped to be greater than or equal to [min].
  ///
  /// The [max] parameter sets the maximum value for the widget. If provided, the
  /// [value] will be clamped to be less than or equal to [max].
  ///
  /// The [postfix] parameter sets the postfix string to be appended to the
  /// displayed value.
  ///
  /// The [divisions] parameter sets the number of divisions to be displayed on
  /// the widget.
  ///
  /// The [fractionDigits] parameter sets the number of decimal places to be
  /// displayed for the value.
  ///
  /// The [slidingSpeed] parameter sets the speed at which the value changes
  /// when sliding the widget.
  ///
  /// The [slidingDirection] parameter sets the direction in which the widget
  /// can be slid. It can be either [Axis.vertical] or [Axis.horizontal].
  ///
  /// The [mouseCursor] parameter sets the mouse cursor to be displayed when
  /// hovering over the widget.
  ///
  /// The [decoration] parameter sets the decoration of the widget.
  ///
  /// The [enabled] parameter sets whether the widget is enabled or disabled.
  ///
  /// The [value] parameter sets the initial value of the widget.
  ///
  /// The [onChanged] parameter is a callback function that gets called
  /// when the value changes. It receives the new value as a [double] parameter.

  ///
  const NumericIntry({
    super.key,
    super.postfix,
    super.mouseCursor,
    super.decoration,
    super.enabled,
    this.min,
    this.max,
    this.divisions = 1,
    this.fractionDigits = 0,
    this.slidingSpeed = 0.2,
    this.slidingDirection = Axis.vertical,
    required this.value,
    required this.onChanged,
  }) : super();

  /// Creates the mutable state for this widget at a given location in the
  @override
  BasicIntryState<BasicIntry> createState() => _NumericIntryState();
}

/// `_NumericIntryState` is a state class for the NumericEntry widget.
///
/// It manages the state of the NumericEntry widget, including the current value
/// and whether the widget is currently focused. It provides methods to update
/// the value and handle user input.
class _NumericIntryState extends BasicIntryState<NumericIntry> {
  /// Initial position of the widget
  double _startPosition = 0;

  /// Initial value of the widget
  double _startValue = 0;

  /// Wraps the child with a GestureDetector to detect gestures.
  ///
  /// If the state is set to IntryState.editting, it returns a
  /// `SizedBox` widget wrapping the child. Otherwise, it returns a
  /// `GestureDetector` widget that listens for double taps to call
  /// `_foucusIn` and horizontal drag start and update events to call
  /// `_slideValue`. The child parameter represents the child widget.
  ///
  /// Parameters:
  ///   - child: The child widget to wrap with a GestureDetector.
  @override
  Widget gestureDetector({required child}) {
    if (isTextEditting) {
      return SizedBox(child: child);
    }

    // If not, it returns a GestureDetector wrapping the child
    return GestureDetector(
      onDoubleTap: () => setState(() => isTextEditting = true),
      onVerticalDragStart: (details) {
        if (widget.slidingDirection == Axis.vertical) {
          _startValue = widget.value;
          _startPosition = details.globalPosition.dy;
        }
      },
      onHorizontalDragStart: (details) {
        if (widget.slidingDirection == Axis.horizontal) {
          _startValue = widget.value;
          _startPosition = details.globalPosition.dx;
        }
      },
      onVerticalDragUpdate: (details) {
        if (widget.slidingDirection == Axis.vertical) {
          _slideValue(_startPosition - details.globalPosition.dy);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (widget.slidingDirection == Axis.horizontal) {
          _slideValue(_startPosition - details.globalPosition.dx);
        }
      },
      child: child,
    );
  }

  /// Builds the text input widget.
  ///
  /// If the state is set to IntryState.editting, it returns a
  /// `TextField` widget to edit the value. Otherwise, it returns a
  /// `ValueListenableBuilder` widget that displays the value with
  /// the postfix.
  @override
  Widget textBuilder(
      {String? text, List<TextInputFormatter>? inputFormatters}) {
    text = widget.value.toStringAsFixed(widget.fractionDigits);
    return super.textBuilder(
      text: text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9۰-۹*/+-^%()]')),
      ],
    );
  }

  /// Parses the text from the text controller, converts it to Latin digits,
  /// converts it to an integer, divides it by the number of divisions, and
  /// passes the result to the `widget.onChanged` callback.
  ///
  /// The `widget.onChanged` callback is called with the result of `_clamp`,
  /// which ensures that the value is between `widget.min` and `widget.max`,
  /// if they are set.
  @override
  void setText() {
    // Parse the text from the text controller and convert it to Latin digits
    var digits = textController.text.toLatin();

    // Parse and evaluate the digits as an integer
    var node = MathNodeExpression.fromString(digits);
    var value = node.calc(MathVariableValues.none).toDouble();

    // Divide the value by the number of divisions
    value = Utils.divide(value, divisions: widget.divisions).toDouble();

    // Pass the result to the `widget.onChanged` callback, after ensuring
    // it is between `widget.min` and `widget.max`, if they are set.
    widget.onChanged?.call(Utils.clamp(
      value,
      min: widget.min,
      max: widget.max,
    ));
  }

  /// Slide the value by a given amount.
  ///
  /// If the state is set to IntryState.editting, this function does nothing.
  /// Otherwise, it updates the value by adding the given amount to the
  /// current value, divides the result by the number of divisions, and passes
  /// the result to the `widget.onChanged` callback, after ensuring that it is
  /// between `widget.min` and `widget.max`, if they are set.
  ///
  /// Parameters:
  ///   - position: The amount to slide the value by.
  void _slideValue(double position) {
    // If editing, do nothing
    if (isTextEditting) {
      return;
    }

    // Calculate the new value
    var newValue = Utils.divide(_startValue + (position * widget.slidingSpeed),
            divisions: widget.divisions)
        .roundToDouble();

    // Ensure the new value is between `widget.min` and `widget.max`, if they are set
    var clampedValue = Utils.clamp(
      newValue,
      min: widget.min,
      max: widget.max,
    );

    // Pass the result to the `widget.onChanged` callback
    widget.onChanged?.call(clampedValue);
  }
}
