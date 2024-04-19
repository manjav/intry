import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum IntryState {
  normal,
  editting,
}

class NumericIntry extends StatefulWidget {
  final int? min;
  final int? max;
  final int value;
  final int divisions;
  final String postfix;
  final Function(int value) onChanged;

  const NumericIntry({
    super.key,
    this.min,
    this.max,
    this.postfix = "",
    this.divisions = 1,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumericIntry> createState() => _NumericIntryState();
}

class _NumericIntryState extends State<NumericIntry> {

  @override
  Widget build(BuildContext context) {
  }
  }
