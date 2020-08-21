import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/eq/Equation.dart';
import 'package:flutter_calculator/ui/components/Keypad.dart';
import 'package:flutter_calculator/ui/components/Operator_Keypad.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // inputValue responds to taps on the keypad
  final TextEditingController inputValueController = TextEditingController();

  // answerController displays the final answer
  final TextEditingController answerController = TextEditingController();

  ValueNotifier<double> scale = ValueNotifier<double>(1.0);

  AnimationController fontSizeAnimationController;
  Animation fontSizeAnimation;
  Tween sizeTween;
  CurvedAnimation sizeCurveAnimation;

  ValueNotifier<bool> swapIcon; // variable for swapping backspace icon

  @override
  void initState() {
    super.initState();

    fontSizeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    sizeTween = Tween(begin: 90.0, end: 65.0);
    sizeCurveAnimation = CurvedAnimation(
        curve: Curves.easeIn, parent: fontSizeAnimationController);

    fontSizeAnimation = sizeTween.animate(sizeCurveAnimation);

    inputValueController.addListener(() {
      changeInputFontSize();

      // trigger Equation.solve when a change occurs
      // assign result to answer controller
      if (inputValueController.text.length > 0) {
        num result = Equation.solve(inputController: inputValueController);
        answerController.text = "${result ?? ""}";
      } else {
        // clear answerController when inputValueController is empty
        answerController.clear();
      }
    });

    answerController.addListener(() {
      // reset size
      if (answerController.text.isEmpty) {
        sizeTween.begin = 90.0;
        sizeTween.end = 65.0;
        fontSizeAnimationController.reverse();
      }
    });
  }

  void changeInputFontSize() {
    // change the size of inputValue when length is > 8
    if (inputValueController.text.length > 8 &&
        fontSizeAnimationController.status == AnimationStatus.dismissed) {
      fontSizeAnimationController.forward();
    } else if (inputValueController.text.length > 10 &&
        fontSizeAnimationController.status == AnimationStatus.completed &&
        sizeTween.end > 35) {

      sizeTween.begin = sizeTween.end;
      sizeTween.end = sizeTween.begin - 10;

      fontSizeAnimation = sizeTween.animate(sizeCurveAnimation);
      fontSizeAnimationController.reset();

      fontSizeAnimationController.forward();

//      fontSizeAnimationController.forward();
    } else if (inputValueController.text.length <= 8 &&
        fontSizeAnimationController.status == AnimationStatus.completed) {
      // reverse animation if length is <= 8
      fontSizeAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
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
                            onEqualsTapped: onEqualsTapped,
                            onEqualsCreated: (showCLR){
                              swapIcon = showCLR;
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

  void onEqualsTapped() {
    // when equals to button is tapped
    // replace the text in inputValueController with answerController
    // reverse the font size animation in inputValueController
    // clear answerController

    if (answerController.text.isNotEmpty) {
      // isNotEmpty prevents it from clearing when equation is incomplete

      inputValueController.text = answerController.text;
      swapIcon.value = true;
      fontSizeAnimationController.reverse();
//    changeInputFontSize(\);

      answerController.clear();
    }
  }

  Widget eqWidget() {
    return AnimatedBuilder(
      animation: fontSizeAnimationController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
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
                    fontSize:
                        Theme.of(context).textTheme.headline1.fontSize - 40,
                    color: Colors.grey.withOpacity(0.75)),
                decoration: InputDecoration.collapsed(hintText: null),
              )
            ],
          ),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
//      toolbarHeight: 1,
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return List.from([
              PopupMenuItem(
                child: Text("huh"),
              )
            ]);
          },
        )
      ],
    );
  }
}
