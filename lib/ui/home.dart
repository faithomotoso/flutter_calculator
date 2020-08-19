import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Animation animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = Tween(begin: 1.0, end: 0.5).animate(
        CurvedAnimation(curve: Curves.linear, parent: animationController));

    inputValueController.addListener(() {
      if (inputValueController.text.length > 10) {
        animationController.forward();
      }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ValueListenableBuilder(
          valueListenable: inputValueController,
          builder: (context, inputValue, child) {
            return TextField(
              controller: inputValueController,
              textDirection: TextDirection.rtl,
              readOnly: true,
              showCursor: true,
//              cursorColor: Colors.white.withOpacity(0.1),
              style: TextStyle(
//                fontSize: Theme.of(context).textTheme.headline1.fontSize,
                fontSize: inputValueController.text.length < 10 ? 20 : 30,
              ),
              decoration: InputDecoration.collapsed(hintText: null),
            );

//            return TextField(
//              controller: inputValueController,
//              textDirection: TextDirection.rtl,
//              readOnly: true,
//              showCursor: true,
////              cursorColor: Colors.white.withOpacity(0.1),
//              style: TextStyle(
//                fontSize: Theme.of(context).textTheme.headline1.fontSize,
//              ),
//              decoration: InputDecoration.collapsed(hintText: null),
//            );
          },
        )
      ],
    );
  }
}
