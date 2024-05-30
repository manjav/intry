# Intry

`Intry` is a highly efficient and rich UI component set designed specifically for creating editor and graphic design applications.
One of the components in Intry, `NumericItery`, combines both slider and text field capabilities in a compact and user-friendly package. With its intuitive interface and extensive customization options, NumericItery makes it effortless to incorporate interactive numerical values into your applications, enhancing the overall user experience.

<p float="left" align="center"><img src="https://github.com/manjav/intry/raw/main/repo_files/intry_demo.gif" alt="Demo" height=298></p>

---

### - Installation
Add `intry` to your pubspec.yaml file:  
For detailed installation instructions, refer to the [installation guide](https://pub.dev/packages/particular/install) on pub.dev.

---

### - Getting Started 
To use this library, import `package:intry_numeric/intry_numeric.dart`.

``` dart
double _integerValue = 0.0;

NumericIntry(
    min: 0.0,
    max: 100.0,
    divisions: 5,
    postfix: "%",
    value: _integerValue,
    onChanged: (int value) => setState(() => _integerValue = value),
);
```
<br>

#### - Custom Decoration  

There are two popular decoration. set decoration arg `NumericIntryDecoration.underline(context)` or `NumericIntryDecoration.outline(context)`. In addition, you can create `MaterialStateProperty<Decoration?>` and overrides the resolve method. This method takes a set of MaterialStates and returns a Decoration object representing the effective decoration.

```dart
/// Custom decoration that draws an topline with a customizable color and width
NumericIntry(
  value: _integerValue,
  onChanged: (int value) => setState(() => _integerValue = value),
  decoration:MaterialStateProperty.resolveWith((states) {
  final isHover = states.contains(MaterialState.hover);
  return BoxDecoration(
    border: Border(
      top: BorderSide(
          color: isHover ? Colors.blue : Colors.red; // Define your desired color here
          width: 2.0, // Define your desired width here
        ),
      ),
    ),
  }),
);
```
<br>

#### - Custom Mouse Cursor

To create a simple custom mouse cursor for the NumericIntry class that you can define a custom cursor using the `SystemMouseCursors` class. Here's a sample code for the custom cursor:

```dart
/// Custom mouse cursor for the NumericInput widget
NumericIntry(
  value: _integerValue,
  onChanged: (int value) => setState(() => _integerValue = value),
  mouseCursor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.focused)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.forbidden;
  }),
);
```

<p float="left" align="center"><img src="https://github.com/manjav/intry/raw/main/repo_files/intry_mousecursor.png" alt="Custom Mouse Cursor"></p>

---

This revised README provides clear installation instructions, options for configuring particles, and steps for integrating the `intry` in your Flutter app. If you have any questions or need further assistance, don't hesitate to ask!