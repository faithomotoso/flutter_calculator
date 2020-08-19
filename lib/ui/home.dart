import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/eq/Equation.dart';
import 'package:flutter_calculator/ui/components/Keypad.dart';
import 'package:flutter_calculator/ui/components/Operator_Keypad.dart';
import 'package:flutter_calculator/ui/components/button_tile.dart';
import 'package:flutter_calculator/ui/components/operator_button.dart';
import 'package:flutter_calculator/ui/components/utils.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // inputValue responds to taps on the keypad
  final TextEditingController inputValueController = TextEditingController();

//  ValueNotifier<String> inputValue = ValueNotifier<String>('');

  // answerController displays the final answer
  final TextEditingController answerController = TextEditingController();

  List<OperatorButton> leftOperatorButtons;
  List<Widget> rightOperatorButtons;

  // boolean determining if to show CLR text or backspace icon
  // CLR is shown when the equal to (=) button is pressed
  ValueNotifier<bool> showCLR = ValueNotifier<bool>(false);

  ValueNotifier<double> scale = ValueNotifier<double>(1.0);

  AnimationController animationController;
  Animation fontSizeAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    fontSizeAnimation = Tween(begin: 90.0, end: 65.0).animate(
        CurvedAnimation(curve: Curves.easeIn, parent: animationController));

    inputValueController.addListener(() {
      // change the size of inputValue when length is > 8
      if (inputValueController.text.length > 8 &&
          animationController.status == AnimationStatus.dismissed) {
        animationController.forward();
      } else if (inputValueController.text.length <= 8 &&
          animationController.status == AnimationStatus.completed) {
        // reverse animation if length is <= 8
        animationController.reverse();
      }

      // trigger Equation.solve when a change occurs
      // assign result to answer controller
//      print("res: ${Equation.solve(inputController: inputValueController)}");
      double result = Equation.solve(inputController: inputValueController);
      answerController.text = result.toString();
      print("Answer: ${answerController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Theme(
                data: Theme.of(context)
                    .copyWith(accentColor: Colors.white.withOpacity(0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: eqWidget(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Keypad(
                            inputValueController: inputValueController,
                          )),
                      Expanded(
                          flex: 1,
                          child: OperatorKeypad(
                            inputValueController: inputValueController,
                            onEqualsTapped: () {
                              print("Equals tapped");
                              answerController.text = "some answer here";
                            },
                          ))
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget eqWidget() {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: inputValueController,
              textDirection: TextDirection.rtl,
              readOnly: true,
              showCursor: true,
//              cursorColor: Colors.white.withOpacity(0.1),
              style: TextStyle(fontSize: fontSizeAnimation.value),
              decoration: InputDecoration.collapsed(hintText: null),
            ),
            TextField(
              controller: answerController,
              textDirection: TextDirection.rtl,
              readOnly: true,
              showCursor: false,
//              cursorColor: Colors.white.withOpacity(0.1),
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline1.fontSize),
              decoration: InputDecoration.collapsed(hintText: null),
            )
          ],
        );
      },
    );
  }
}
