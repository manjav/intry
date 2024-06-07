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
  String _textValue = "Test";
  double _numericValue = 10;

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
            Column(
              children: [
                const SizedBox(height: 10),
                const Text("IntryTextField"),
                const SizedBox(height: 20),
                IntryTextField(
                  value: _textValue,
                  decoration: IntryFieldDecoration.outline(context),
                  onChanged: (String value) =>
                      setState(() => _textValue = value),
                ),
                const SizedBox(height: 40),
                Text(
                  'Value: $_textValue\nValue: "$_textValue"\nDecoration:outline',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(width: 80),
            Column(
              children: [
                const SizedBox(height: 10),
                const Text("IntryNumericField"),
                const SizedBox(height: 20),
                IntryNumericField(
                  min: 0,
                  max: 100,
                  divisions: 5,
                  formatter: "%sMB",
                  value: _numericValue,
                  onChanged: (double value) =>
                      setState(() => _numericValue = value),
                ),
                const SizedBox(height: 40),
                Text(
                  'Min: 0\nMax: 100\nDivision: 5\nFormatter: "%sMB"\nValue: $_numericValue',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
