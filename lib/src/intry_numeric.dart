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
  final double? min;

  /// The maximum value for the numeric input.
  final double? max;

  /// The initial value for the numeric input.
  final double value;

  /// The number of divisions for the numeric input.
  final int divisions;

  final double changeSpeed;

  final int fractionDigits;

  /// The postfix for the numeric input.
  final String postfix;

  /// The callback function that gets called when the value changes.
  final ValueChanged<double> onChanged;

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
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.hovered] => Hover state.
  ///  * [MaterialState.focused] => Text edittig state.
  ///  * [MaterialState.disabled] => Disabled state.
  final MaterialStateProperty<Decoration?>? decoration;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget. (COMMING SOON)
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.hovered] => Hover state.
  ///  * [MaterialState.focused] => Text edittig state.
  ///  * [MaterialState.disabled] => Disabled state.
  ///
  /// If this property is null, [MaterialStateMouseCursor.clickable] will be used.
  ///
  /// The [mouseCursor] is the only property of [TextField] that controls the
  /// appearance of the mouse pointer. All other properties related to "cursor"
  /// stand for the text cursor, which is usually a blinking vertical line at
  /// the editing position.
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

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
    this.fractionDigits = 0,
    this.changeSpeed = 0.2,
    this.enabled,
    this.decoration,
    this.mouseCursor,
    required this.value,
    required this.onChanged,
  });

  /// Creates the mutable state for this widget at a given location in the
  @override
  State<NumericIntry> createState() => _NumericIntryState();
}

/// `_NumericIntryState` is a state class for the NumericEntry widget.
///
/// It manages the state of the NumericEntry widget, including the current value
/// and whether the widget is currently focused. It provides methods to update
/// the value and handle user input.
class _NumericIntryState extends State<NumericIntry> {
  /// Controller for managing the text input in the widget
  final TextEditingController _textController = TextEditingController();

  /// Focus node for handling focus in the widget
  final FocusNode _focusNode = FocusNode();

  /// Initial position of the widget
  double _startPosition = 0;

  /// Initial value of the widget
  double _startValue = 0;

  /// Flag to indicate if the widget is being hovered over
  bool _isHover = false;

  /// Flag to indicate if the widget is currently in edit mode
  bool _isTextEditting = false;

  /// Flag to indicate if the widget is enabled or disabled.
  ///
  /// If [widget.enabled] is not null, it is used as the value of this field.
  /// Otherwise, it is set to `true` by default.
  ///
  /// This field determines whether the widget is enabled or disabled. It is
  /// used to control the user interaction with the widget, such as allowing
  /// or disallowing input and changing the appearance based on the state.
  bool get _isEnabled => widget.enabled ?? true;

  /// Returns a set of [MaterialState]s representing the current state of the widget.
  Set<MaterialState> get _states => <MaterialState>{
        if (!_isEnabled) MaterialState.disabled,
        if (_isHover) MaterialState.hovered,
        if (_isTextEditting) MaterialState.focused,
      };

  /// Builds the widget tree for this state.
  /// Returns a `Widget` that represents the widget tree built in this method.
  @override
  Widget build(BuildContext context) {
    // Builds the widget tree
    return TapRegion(
      onTapOutside: (e) {
        if (_isTextEditting) {
          _setText();
          _foucusOut();
        }
      },
      child: _gestureDetector(
        child: MouseRegion(
          onEnter: (event) => setState(() => _isHover = true),
          onExit: (event) => setState(() => _isHover = false),
          cursor:
              _mouseCursorStates.resolve(_states) ?? MouseCursor.uncontrolled,
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
    if (_isTextEditting) {
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
    var text = widget.value.toStringAsFixed(widget.fractionDigits);
    if (_isTextEditting) {
      // Set the TextField's text to the current value
      _textController.text = text;
      return TextField(
        focusNode: _focusNode,
        controller: _textController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
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

  /// Returns the effective decoration based on the current state.
  ///
  /// It first creates a set of [MaterialState]s containing the current state.
  /// Then, it checks if [widget.decoration] is not null. If it is not null,
  /// it assigns it to [stateDecorator]. Otherwise, it uses the
  /// [NumericIntryDecoration.underline] constructor to create a default
  /// underline decoration using the provided [BuildContext].
  ///
  /// Finally, it calls the [resolve] method on [stateDecorator] passing the
  /// set of states to retrieve the effective decoration.
  ///
  /// This method is used to determine the decoration to apply to the widget
  /// based on its current state.
  ///
  /// Returns a [Decoration] object representing the effective decoration.
  Decoration? _getEffectiveDecoration() {
    final stateDecorator =
        widget.decoration ?? NumericIntryDecoration.underline(context);
    return stateDecorator.resolve(_states);
  }

  MaterialStateProperty<MouseCursor?> get _mouseCursorStates {
    return widget.mouseCursor ??
        MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.focused)) {
            return SystemMouseCursors.resizeLeftRight;
          }
          return SystemMouseCursors.basic;
        });
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
    var value = double.parse(digits);

    // Divide the value by the number of divisions
    value = _divide(value).toDouble();

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
    if (_isTextEditting) {
      return;
    }

    // Calculate the new value
    var newValue =
        _divide(_startValue + (position * widget.changeSpeed)).roundToDouble();

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
    setState(() => _isTextEditting = true);

    // Call `_selectAll` method to select all the text in the text controller.
    _selectAll();
  }

  /// Call this method to focus out of the numeric input widget.
  ///
  /// It sets the state to `IntryState.notEditting` to disable editing.
  void _foucusOut() {
    setState(() => _isTextEditting = false);
  }

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
  num _divide(num value) {
    // Divide the given value by the number of divisions and round it to the nearest number
    var dividedValue = value / widget.divisions;
    var roundedValue = dividedValue.round();
    return roundedValue * widget.divisions;
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
  double _clamp(double value) {
    // Clamp the value to the range defined by `widget.min` and `widget.max`.
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
