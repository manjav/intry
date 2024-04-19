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
  IntryState state = IntryState.normal;
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();
  double _startPosition = 0;
  int _startValue = 0;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (e) {
        if (state == IntryState.editting) {
          _setText();
          _foucusOut();
        }
      },
      child: _gestureDetector(
        child: MouseRegion(
          cursor: _getMouseCursor(),
          child: Container(
            constraints: BoxConstraints.tight(const Size(72, 36)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(3),
            ),
            child: _textBuilder(),
          ),
        ),
      ),
    );
  }

  Widget _gestureDetector({required child}) {
    if (state == IntryState.editting) {
      return SizedBox(child: child);
    }
    return GestureDetector(
        onDoubleTap: _foucusIn,
        onHorizontalDragStart: (details) {
          _startValue = widget.value;
          _startPosition = details.globalPosition.dx;
        },
        onHorizontalDragUpdate: (details) =>
            _slideValue(details.globalPosition.dx - _startPosition),
        child: child);
  }

  Widget _textBuilder() {
    var text = widget.value.toString();
    if (state == IntryState.editting) {
      _textController.text = text;
      return TextField(
        focusNode: _focusNode,
        controller: _textController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: (e) {
          _setText();
          _foucusOut();
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9۰-۹]')),
        ],
        decoration: const InputDecoration(
          hintText: "",
          contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ),
      );
    }
    return ValueListenableBuilder(
      valueListenable: _textController,
      builder: (context, value, child) => Text("$text${widget.postfix}"),
    );
  }

  MouseCursor _getMouseCursor() {
    return switch (state) {
      IntryState.editting => MouseCursor.uncontrolled,
      _ => SystemMouseCursors.resizeLeftRight,
    };
  }

  void _setText() {
    var digits = _textController.text.toLatin();
    widget.onChanged(_clamp(_divide(int.parse(digits))));
  }

  Future<void> _selectAll() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _textController.selection = TextSelection(
        baseOffset: 0, extentOffset: _textController.value.text.length);
  }

  void _slideValue(double d) {
    if (state == IntryState.editting) {
      return;
    }

    widget.onChanged(_clamp(_divide(_startValue + (d / 5)).round()));
  }

  void _foucusIn() {
    setState(() => state = IntryState.editting);
    _selectAll();
  }

  void _foucusOut() => setState(() => state = IntryState.normal);

  int _divide(num value) =>
      (value / widget.divisions).round() * widget.divisions;

  int _clamp(int value) {
    if (widget.min != null && value < widget.min!) {
      value = widget.min!;
    }
    if (widget.max != null && value > widget.max!) {
      value = widget.max!;
    }
    return value;
  }
}

extension ToLatinExtension on String {
  String toLatin() {
    const Map<String, String> numbers = {
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    return replaceAllMapped(
      RegExp('[۰-۹]'),
      (match) => numbers[this[match.start]]!,
    );
  }
}
