import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intry/intry.dart';

/// A library for creating a numeric input widget.
///
/// The [IntryBasicField] widget provides a numeric input field with
/// configurable minimum and maximum values, initial value,
/// number of divisions, and postfix. It also provides a callback
/// function that gets called when the value changes.
///
/// To use this library, import `package:intry_numeric/intry_numeric.dart`.

class IntryBasicField extends StatefulWidget {
  /// A string used to format the text displayed in the text field.
  ///
  /// The string should contain a "%s" placeholder which will be replaced
  /// with the current value of the text field. For example, if the formatter
  /// is "%s km" and the current value is 10, the text field will display
  /// "10 km".
  final String formatter;

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

  /// Initializes the [IntryBasicField] widget with the provided parameters.
  /// The [formatter] parameter sets the postfix string to be appended to the
  /// displayed value.
  /// The [mouseCursor] parameter sets the mouse cursor to be displayed when
  /// hovering over the widget.
  ///
  /// The [decoration] parameter sets the decoration of the widget.
  ///
  /// The [enabled] parameter sets whether the widget is enabled or disabled.
  ///
  const IntryBasicField({
    super.key,
    this.formatter = "%s",
    this.mouseCursor,
    this.decoration,
    this.enabled,
  });

  /// Creates the mutable state for this widget at a given location in the
  @override
  State<IntryBasicField> createState() => IntryBasicFieldState();
}

/// `_BasicIntryState` is a state class for the NumericEntry widget.
///
/// It manages the state of the NumericEntry widget, including the current value
/// and whether the widget is currently focused. It provides methods to update
/// the value and handle user input.
class IntryBasicFieldState<T extends IntryBasicField> extends State<T> {
  /// Controller for managing the text input in the widget
  final TextEditingController textController = TextEditingController();

  /// Focus node for handling focus in the widget
  final FocusNode _focusNode = FocusNode();

  /// Flag to indicate if the widget is being hovered over
  bool isHover = false;

  /// Flag to indicate if the widget is currently in edit mode
  bool isTextEditting = false;

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
        if (isHover) MaterialState.hovered,
        if (isTextEditting) MaterialState.focused,
      };

  /// Builds the widget tree for this state.
  /// Returns a `Widget` that represents the widget tree built in this method.
  @override
  Widget build(BuildContext context) {
    // Builds the widget tree
    return TapRegion(
      onTapOutside: (e) {
        if (isTextEditting) {
          setText();
          setState(() => isTextEditting = false);
        }
      },
      child: gestureDetector(
        child: MouseRegion(
          onEnter: (event) => onHover(true),
          onExit: (event) => onHover(false),
          cursor:
              mouseCursorStates.resolve(_states) ?? MouseCursor.uncontrolled,
          child: Container(
            constraints: BoxConstraints.tight(const Size(64, 32)),
            alignment: Alignment.center,
            decoration: _getEffectiveDecoration(),
            child: textBuilder(), // Builds the child of the Container
          ),
        ),
      ),
    );
  }

  /// Handles the hover event by updating the state of the widget.
  ///
  /// This function is called when the user hovers over the widget. It takes a
  /// parameter [isHover] which indicates whether the user is currently hovering
  /// over the widget. If the widget is currently in text editing mode, the function
  /// returns without updating the state. Otherwise, it updates the state of the
  /// widget by setting the [_isHover] property to [isHover].
  ///
  /// Parameters:
  ///   - isHover: A boolean value indicating whether the user is currently
  ///             hovering over the widget.
  void onHover(bool isHover) {}

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
  Widget gestureDetector({required child}) {
    if (isTextEditting) {
      return child;
    }

    // If not, it returns a GestureDetector wrapping the child
    return GestureDetector(
      onDoubleTap: () => setState(() => isTextEditting = true),
      child: child,
    );
  }

  /// Builds the text input widget.
  ///
  /// If the state is set to IntryState.editting, it returns a
  /// `TextField` widget to edit the value. Otherwise, it returns a
  /// `ValueListenableBuilder` widget that displays the value with
  /// the postfix.
  Widget textBuilder({
    String text = "",
    List<TextInputFormatter>? inputFormatters,
  }) {
    if (isTextEditting) {
      // Set the TextField's text to the current value
      textController.text = text;
      return TextField(
        focusNode: _focusNode,
        controller: textController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (e) {
          setText();
          setState(() => isTextEditting = false);
        },

        // Allow only Latin and Persian digits
        inputFormatters: inputFormatters,

        // Set blank decoration of the TextField
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16),
            border: InputBorder.none),
      );
    }

    return Text(widget.formatter.replaceFirst(RegExp(r'%s'), text));
  }

  /// Returns the effective decoration based on the current state.
  ///
  /// It first creates a set of [MaterialState]s containing the current state.
  /// Then, it checks if [widget.decoration] is not null. If it is not null,
  /// it assigns it to [stateDecorator]. Otherwise, it uses the
  /// [BasicIntryDecoration.underline] constructor to create a default
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

  MaterialStateProperty<MouseCursor?> get mouseCursorStates {
    return widget.mouseCursor ??
        MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.focused)) {
            return SystemMouseCursors.text;
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
}
