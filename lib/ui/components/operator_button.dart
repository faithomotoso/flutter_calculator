import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/utils.dart';

class OperatorButton extends StatefulWidget {
  final String operatorString;
  Function onTap;
  TextEditingController inputValueController;

  // prevent duplicates of operators
  // e.g 2x+2
  bool preventDuplicates;

  double height;
  double width;

  OperatorButton(
      {@required this.operatorString,
      this.onTap,
      this.inputValueController,
      @required this.preventDuplicates,
      this.height,
      this.width})
      : assert(preventDuplicates != null,
            "Prevent Duplicates variable can't be null");

  @override
  _OperatorButtonState createState() => _OperatorButtonState();
}

class _OperatorButtonState extends State<OperatorButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
//        print("Prevent duplicates: ${widget.operatorString} = ${widget.preventDuplicates}");

//        if (widget.preventDuplicates) {
//          print("existing string: ${widget.inputValueController.text}");
//          // check if operator is in string
//          if (!(widget.inputValueController.text
//              .contains(widget.operatorString))) {
//            widget.inputValueController?.text += widget.operatorString;
//            widget.onTap?.call();
//          }
//        } else {
//          widget.inputValueController?.text += widget.operatorString;
//          widget.onTap?.call();
//        }


        // prevent operators from following each other
        // e.g 2+-, 4*-1

        // if true, do nothing
        if (widget.preventDuplicates) {

        } else {
          // if false append operator to string and trigger onTap
          widget.inputValueController?.text += widget.operatorString;
          widget.onTap?.call();
        }
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(
            widget.operatorString,
            style: tileTextStyle,
          ),
        ),
      ),
    );
  }
}
