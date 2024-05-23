import 'package:flutter/material.dart';
import 'package:intry/intry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intry Demo',
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'Intry Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _stringValue = "Hello";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumericIntry(
              inputType: IntryInputType.text,
              min: 0,
              max: 100,
              divisions: 5,
              postfix: "%",
              value: _stringValue,
              onTextChanged: (String value) =>
                  setState(() => _stringValue = value),
            ),
            const SizedBox(width: 30),
            Text(
              'Min: 0\nMax: 100\nDivision: 5\nPostfix: "%"\nValue: $_stringValue',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
