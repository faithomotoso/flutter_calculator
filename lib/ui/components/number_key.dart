import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/Operator_Keypad.dart';
import 'package:flutter_calculator/ui/components/utils.dart';

class NumberKey extends StatefulWidget {
  final String tileString;

  // pass input text to append to
  final TextEditingController inputValue;

  double height;
  double width;

  // set to true to prevent entering value twice
  // e.g 23.45.6, multiple "." not allowed this way
  bool preventDuplicates;

  NumberKey(
      {@required this.tileString,
      @required this.inputValue,
      this.height,
      this.width,
      this.preventDuplicates = false})
      : assert(tileString != null, "Tile string can't be null"),
        assert(inputValue != null, "Input value can't be null");

  @override
  _NumberKeyState createState() => _NumberKeyState();
}

class _NumberKeyState extends State<NumberKey> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // check if value is in string
        if (widget.preventDuplicates) {
          if (!(widget.inputValue.text.contains(widget.tileString))) {
            input();
          }
        } else {
          input();
        }
      },
      child: Container(
        decoration: BoxDecoration(),
        height: widget.height,
        width: widget.width,
        child: Center(
          child: Text(
            widget.tileString,
            style: tileTextStyle,
          ),
        ),
      ),
    );
  }

  void input() {
    widget.inputValue.text += this.widget.tileString;
    if (showCLR.value) {
      // swap from CLR to backspace icon if showCLR is true
      showCLR.value = false;
      // replace the whole string with the number tapped
      // only do this when equals to has been tapped and the answer is in display
      widget.inputValue.text = this.widget.tileString;
    }
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    super.toString();
    return "${this.runtimeType} ${widget.tileString}";
  }
}
