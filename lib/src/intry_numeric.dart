import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intry/intry.dart';

/// A library for creating a numeric input widget.
///
/// The [NumericIntry] widget provides a numeric input field with
/// configurable minimum and maximum values, initial value,
/// number of divisions, and postfix. It also provides a callback
/// function that gets called when the value changes.
///
/// To use this library, import `package:intry_numeric/intry_numeric.dart`.

class NumericIntry extends StatefulWidget {
  /// The minimum value for the numeric input.
  final int? min;

  /// The maximum value for the numeric input.
  final int? max;

  /// The initial value for the numeric input.
  final int value;

  /// The number of divisions for the numeric input.
  final int divisions;

  /// The postfix for the numeric input.
  final String postfix;

  /// The callback function that gets called when the value changes.
  final ValueChanged<int> onChanged;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [InputDecoration.enabled] property.
  final bool? enabled;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final MaterialStateProperty<Decoration?>? decoration;

  /// Creates a widget for a numeric input with the given configurations.
  ///
  /// The [value] argument must not be null.
  /// The [onChanged] argument must not be null.
  const NumericIntry({
    super.key,
    this.min,
    this.max,
    this.postfix = "",
    this.divisions = 1,
    this.decoration,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumericIntry> createState() => _NumericIntryState();
}

class _NumericIntryState extends State<NumericIntry> {
  MaterialState _state = MaterialState.selected;
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();
  double _startPosition = 0;
  int _startValue = 0;

  /// Builds the widget tree for this state.
  /// Returns a `Widget` that represents the widget tree built in this method.
  @override
  Widget build(BuildContext context) {
    // Builds the widget tree
    return TapRegion(
      onTapOutside: (e) {
        if (_state == MaterialState.pressed) {
          _setText();
          _foucusOut();
        }
      },
      child: _gestureDetector(
        child: MouseRegion(
          onEnter: (event) => _onMouseHover(true),
          onExit: (event) => _onMouseHover(false),
          cursor: _getMouseCursor(),
          child: Container(
            constraints: BoxConstraints.tight(const Size(72, 36)),
            alignment: Alignment.center,
            decoration: _getEffectiveDecoration(),
            child: _textBuilder(), // Builds the child of the Container
          ),
        ),
      ),
    );
  }

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
  Widget _gestureDetector({required child}) {
    if (_state == MaterialState.pressed) {
      return SizedBox(child: child);
    }

    // If not, it returns a GestureDetector wrapping the child
    return GestureDetector(
      onDoubleTap: _foucusIn,
      onHorizontalDragStart: (details) {
        _startValue = widget.value;
        _startPosition = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) =>
          _slideValue(details.globalPosition.dx - _startPosition),
      child: child,
    );
  }

  /// Builds the text input widget.
  ///
  /// If the state is set to IntryState.editting, it returns a
  /// `TextField` widget to edit the value. Otherwise, it returns a
  /// `ValueListenableBuilder` widget that displays the value with
  /// the postfix.
  Widget _textBuilder() {
    var text = widget.value.toString();
    if (_state == MaterialState.pressed) {
      // Set the TextField's text to the current value
      _textController.text = text;
      return TextField(
        focusNode: _focusNode,
        controller: _textController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (e) {
          _setText();
          _foucusOut();
        },

        // Allow only Latin and Persian digits
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9۰-۹]')),
        ],

        // Set blank decoration of the TextField
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 20),
            border: InputBorder.none),
      );
    }

    return Text("$text${widget.postfix}");
  }

  Decoration? _getEffectiveDecoration() {
    final Set<MaterialState> states = <MaterialState>{_state};
    final stateDecorator =
        widget.decoration ?? NumericIntryDecoration.underline(context);
    return stateDecorator.resolve(states);
  }


  /// Returns the mouse cursor based on the state.
  ///
  /// If the state is set to [IntryState.editting], it returns
  /// [MouseCursor.uncontrolled] to indicate that the mouse cursor
  /// should be uncontrolled. Otherwise, it returns
  /// [SystemMouseCursors.resizeLeftRight] to indicate that the
  /// mouse cursor should be a resize cursor for left and right.
  ///
  /// This method is used to determine the mouse cursor appearance
  /// based on the state of the widget.
  MouseCursor _getMouseCursor() {
    return switch (_state) {
      MaterialState.pressed => MouseCursor.uncontrolled,
      _ => SystemMouseCursors.resizeLeftRight,
    };
  }

  /// Parses the text from the text controller, converts it to Latin digits,
  /// converts it to an integer, divides it by the number of divisions, and
  /// passes the result to the `widget.onChanged` callback.
  ///
  /// The `widget.onChanged` callback is called with the result of `_clamp`,
  /// which ensures that the value is between `widget.min` and `widget.max`,
  /// if they are set.
  void _setText() {
    // Parse the text from the text controller and convert it to Latin digits
    var digits = _textController.text.toLatin();

    // Parse the digits as an integer
    var value = int.parse(digits);

    // Divide the value by the number of divisions
    value = _divide(value);

    // Pass the result to the `widget.onChanged` callback, after ensuring
    // it is between `widget.min` and `widget.max`, if they are set.
    widget.onChanged(_clamp(value));
  }

  /// Selects all the text in the text controller.
  ///
  /// This method is useful for implementing a "select all" functionality.
  Future<void> _selectAll() async {
    // Set the text selection to select all the text in the text controller.
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.value.text.length,
    );
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
    if (_state == MaterialState.pressed) {
      return;
    }

    // Calculate the new value
    var newValue = _divide(_startValue + (position / 5)).round();

    // Ensure the new value is between `widget.min` and `widget.max`, if they are set
    var clampedValue = _clamp(newValue);

    // Pass the result to the `widget.onChanged` callback
    widget.onChanged(clampedValue);
  }

  /// Call this method to focus in to the numeric input widget.
  ///
  /// It sets the state to `IntryState.editting` and calls `_selectAll` method
  /// to select all the text in the text controller.
  void _foucusIn() {
    // Set the state to `IntryState.editting` to enable editing.
    setState(() => _state = MaterialState.pressed);

    // Call `_selectAll` method to select all the text in the text controller.
    _selectAll();
  }

  /// Updates the state of the widget based on whether the mouse is hovering over it.
  ///
  /// If the widget is currently in the selected or hovered state, it will change
  /// to the hovered state if the mouse is hovering over it, or to the selected
  /// state if it is not.
  ///
  /// Parameters:
  ///   - isHover: A boolean indicating whether the mouse is hovering over the widget.
  void _onMouseHover(bool isHover) {
    if (_state == MaterialState.selected || _state == MaterialState.hovered) {
      _state = isHover ? MaterialState.hovered : MaterialState.selected;
      setState(() {});
    }
  }

  void _foucusOut() => setState(() => _state = MaterialState.selected);

  /// Divide the given value by the number of divisions and round it to the nearest integer.
  /// Then, multiply the result by the number of divisions.
  ///
  /// This function is used to ensure that the value is a multiple of the number of divisions.
  ///
  /// Parameters:
  ///   - value: The value to divide.
  ///
  /// Returns:
  ///   - The value divided by the number of divisions, rounded to the nearest integer,
  ///     then multiplied by the number of divisions.
  ///
  /// Example:
  ///   If the number of divisions is 10 and the value is 12.5, the result would be 10.
  ///   If the number of divisions is 10 and the value is 17, the result would be 20.
  int _divide(num value) {
    // Divide the given value by the number of divisions and round it to the nearest integer
    var dividedValue = value / widget.divisions;
    var roundedValue = dividedValue.round();
    return roundedValue * widget.divisions;
  }

  /// Clamps the given value to the range specified by `widget.min` and `widget.max`.
  ///
  /// If `widget.min` is not null and `value` is less than `widget.min`,
  /// `value` is set to `widget.min`.
  /// If `widget.max` is not null and `value` is greater than `widget.max`,
  /// `value` is set to `widget.max`.
  ///
  /// Parameters:
  ///   - value: The value to clamp.
  ///
  /// Returns:
  ///   - The clamped value.
  int _clamp(int value) {
    // If `widget.min` is not null and `value` is less than `widget.min`,
    // set `value` to `widget.min`.
    if (widget.min != null && value < widget.min!) {
      value = widget.min!;
    }

    // If `widget.max` is not null and `value` is greater than `widget.max`,
    // set `value` to `widget.max`.
    if (widget.max != null && value > widget.max!) {
      value = widget.max!;
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
      '۵': '5',
      '۶': '6',
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
      RegExp('[۰-۹]'),
      (match) => numbers[this[match.start]]!,
    );
  }
}
