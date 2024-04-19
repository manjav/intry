# Intry

A library for creating a numeric input widget. The [NumericIntry] widget provides a numeric input field with configurable minimum and maximum values, initial value,number of divisions, and postfix. It also provides a callback function that gets called when the value changes.

<p float="left" align="center"><img src="https://github.com/manjav/test/raw/main/repo_files/intry_demo.gif" alt="Demo"></p>

---

### - Installation
Add `intry` to your pubspec.yaml file:  
For detailed installation instructions, refer to the [installation guide](https://pub.dev/packages/particular/install) on pub.dev.

---

### - Getting Started 
To use this library, import `package:intry_numeric/intry_numeric.dart`.<br>

``` dart
int _integerValue = 0;

NumericIntry(
    min: 0,
    max: 100,
    divisions: 5,
    postfix: "%",
    value: _integerValue,
    onChanged: (int value) {
    setState(() {
        _integerValue = value;
    });
    },
),
```

---

This revised README provides clear installation instructions, options for configuring particles, and steps for integrating the `intry` in your Flutter app. If you have any questions or need further assistance, don't hesitate to ask!