import 'package:flutter/material.dart';

/// Class for creating decorations for the [NumericIntry] widget.
///
/// The `NumericIntryDecoration` class provides static methods for creating
/// decorations that can be used to customize the appearance of the
/// [NumericIntry] widget.
///
/// The decorations can be used to draw an underline or an outline around
/// the widget based on the state of the widget. The color of the underline
/// or outline can be customized based on the state of the widget.
class NumericIntryDecoration {
  /// Creates a decoration that draws an underline with a customizable width and
  /// color based on the state of the [NumericIntry] widget.
  ///
  /// The [context] parameter is used to determine the color of the underline.
  static MaterialStateProperty<Decoration?> underline(BuildContext context) {
    return MaterialStateProperty.resolveWith((states) {
      final color = _getEffectiveColor(context, states)!;

      return BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: color,
          width: states.contains(MaterialState.focused) ? 1.5 : 1.0,
        )),
      );
    });
  }

  /// Creates a decoration that draws an outline with a customizable color and
  /// border width based on the state of the [NumericIntry] widget.
  ///
  /// The [context] parameter is used to determine the color of the outline.
  static MaterialStateProperty<Decoration?> outline(BuildContext context) {
    return MaterialStateProperty.resolveWith((states) {
      final color = _getEffectiveColor(context, states)!;

      return BoxDecoration(
        border: Border.all(
          color: color,
          width: states.contains(MaterialState.focused) ? 1.5 : 1.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      );
    });
  }

  /// Returns the effective color based on the given [BuildContext] and
  /// [MaterialState] set.
  ///
  /// This method checks the given [states] for specific [MaterialState]s and
  /// returns the corresponding color from the [ThemeData] of the given
  /// [BuildContext].
  ///
  /// If the [states] contains [MaterialState.disabled], the disabled color is
  /// returned.
  /// If the [states] contains [MaterialState.hovered], the primary color is
  /// returned.
  /// If the [states] contains [MaterialState.focused], the focus color is
  /// returned.
  /// In all other cases, the unselected widget color is returned.
  static Color? _getEffectiveColor(
    BuildContext context,
    Set<MaterialState> states,
  ) {
    final ThemeData themeData = Theme.of(context);
    if (states.contains(MaterialState.disabled)) {
      return themeData.disabledColor;
    }
    if (states.contains(MaterialState.focused)) {
      return themeData.primaryColor;
    }
    if (states.contains(MaterialState.hovered)) {
      return themeData.brightness == Brightness.light
          ? themeData.unselectedWidgetColor
          : themeData.cardColor;
    }

    return themeData.splashColor;
  }
}
