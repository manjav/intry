import 'package:flutter/material.dart';

class NumericIntryDecoration {
  static MaterialStateProperty<Decoration?> underline(BuildContext context) {
    return MaterialStateProperty.resolveWith((states) {
      final color = _getEffectiveColor(context, states)!;

      return BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: color,
          width: states.contains(MaterialState.pressed) ? 1.5 : 1.0,
        )),
      );
    });
  }

  static MaterialStateProperty<Decoration?> outline(BuildContext context) {
    return MaterialStateProperty.resolveWith((states) {
      final color = _getEffectiveColor(context, states)!;

      return BoxDecoration(
        border: Border.all(
          color: color,
          width: states.contains(MaterialState.pressed) ? 1.5 : 1.0,
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
  /// If the [states] contains [MaterialState.pressed], the focus color is
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
    if (states.contains(MaterialState.hovered)) {
      return themeData.unselectedWidgetColor;
    }
    if (states.contains(MaterialState.pressed)) {
      return themeData.primaryColor;
    }

    return themeData.focusColor;
  }
}
