# Intry

`Intry` is a highly efficient and rich UI component set designed specifically for creating editor and graphic design applications.
One of the components in Intry, `NumericItery`, combines both slider and text field capabilities in a compact and user-friendly package. With its intuitive interface and extensive customization options, NumericItery makes it effortless to incorporate interactive numerical values into your applications, enhancing the overall user experience.


---

### - Installation
Add `intry` to your pubspec.yaml file:  
For detailed installation instructions, refer to the [installation guide](https://pub.dev/packages/particular/install) on pub.dev.

---

### - Getting Started 
To use this library, import `package:intry_numeric/intry_numeric.dart`.

#### - IntryNumericField

``` dart
double _numericValue = 10;

IntryNumericField(
  min: 0,
  max: 100,
  divisions: 5,
  formatter: "%sMB",
  value: _numericValue,
  onChanged: (double value) =>
      setState(() => _numericValue = value),
),
```
<br>

#### - IntryTextField
```dart
String _textValue = "Test";

IntryTextField(
  value: _textValue,
  decoration: IntryFieldDecoration.outline(context),
  onChanged: (String value) =>
      setState(() => _textValue = value),
),

```

<p float="left" align="center"><img src="https://github.com/manjav/intry/raw/main/repo_files/intry_demo.png" alt="Custom Mouse Cursor"></p>

---

This revised README provides clear installation instructions, options for configuring particles, and steps for integrating the `intry` in your Flutter app. If you have any questions or need further assistance, don't hesitate to ask!