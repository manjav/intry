import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intry/intry.dart';

/// A library for creating a text input widget.
class IntryTextField extends IntryBasicField {
  /// The callback function that gets called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Initializes the [IntryTextField] widget with the provided parameters.
  ///
  /// The [formatter] is a string used to format the text displayed in the text field.
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
  /// when the value changes. It receives the new value as a [String] parameter.

  /// The initial value for the input.
  final String value;

  /// Constructs a [IntryTextField] widget with the given parameters.
  const IntryTextField({
    super.key,
    super.formatter,
    super.mouseCursor,
    super.decoration,
    super.enabled,
    required this.value,
    required this.onChanged,
  }) : super();

  /// Creates the mutable state for this widget at a given location in the
  @override
  IntryBasicFieldState<IntryTextField> createState() => _TextIntryState();
}

/// `_TextIntryState` is a state class for the TextEntry widget.
///
/// It manages the state of the TextEntry widget, including the current value
/// and whether the widget is currently focused. It provides methods to update
/// the value and handle user input.
class _TextIntryState extends IntryBasicFieldState<IntryTextField> {
  /// Controller for managing the text input in the widget
  @override
  Widget textBuilder(
      {String? text, List<TextInputFormatter>? inputFormatters}) {
    text = widget.value;
    return super.textBuilder(text: text);
  }

  /// Sets the text in the text controller and updates the widget's value.
  @override
  void setText() {
    // Pass the result to the `widget.onChanged` callback.
    widget.onChanged?.call(textController.text);
  }
}
