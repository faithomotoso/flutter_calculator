import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/utils.dart';

class OperatorButton extends StatelessWidget {
  final String operatorString;
  Function onTap;
  TextEditingController inputValueController;

  OperatorButton(
      {@required this.operatorString, this.onTap, this.inputValueController});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        inputValueController?.text += operatorString;
      },
      child: Container(
        child: Center(
          child: Text(
            operatorString,
            style: tileTextStyle,
          ),
        ),
      ),
    );
  }
}
