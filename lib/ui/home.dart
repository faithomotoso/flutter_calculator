import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/Keypad.dart';
import 'package:flutter_calculator/ui/components/button_tile.dart';
import 'package:flutter_calculator/ui/components/operator_button.dart';
import 'package:flutter_calculator/ui/components/utils.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  // inputValue responds to taps on the keypad
  final TextEditingController inputValueController = TextEditingController();

//  ValueNotifier<String> inputValue = ValueNotifier<String>('');

  // answerController displays the final answer
  final TextEditingController answerController = TextEditingController();

  List<NumberKey> numberKeys;
  List<OperatorButton> leftOperatorButtons;
  List<Widget> rightOperatorButtons;

  // boolean determining if to show CLR text or backspace icon
  // CLR is shown when the equal to (=) button is pressed
  ValueNotifier<bool> showCLR = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    initNumberKeys();
    initOperatorButtons();
  }

  void initNumberKeys() {
    numberKeys = [
      NumberKey(
        tileString: "7",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "8",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "9",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "4",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "5",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "6",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "1",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "2",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "3",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: ".",
        inputValue: inputValueController,
      ),
      NumberKey(
        tileString: "0",
        inputValue: inputValueController,
      ),
    ];
  }

  void initOperatorButtons() {
    leftOperatorButtons = [
      OperatorButton(
        operatorString: "\u00f7",
        onTap: () {},
        inputValueController: inputValueController,
      ),
      OperatorButton(
        operatorString: "x",
        onTap: () {},
        inputValueController: inputValueController,
      ),
      OperatorButton(
        operatorString: "-",
        onTap: () {},
        inputValueController: inputValueController,
      ),
      OperatorButton(
        operatorString: "+",
        onTap: () {},
        inputValueController: inputValueController,
      ),
    ];

    // for backspace/clear and equals to buttons
    rightOperatorButtons = [
      InkWell(
          // using inkWell directly to swap between
          // text and icon
          // todo swap when equals to button is tapped
          onTap: () {},
          child: Container(
            child: Center(
                child: ValueListenableBuilder(
              valueListenable: showCLR,
              builder: (context, showCLR, child) {
                return showCLR
                    ? Text(
                        "CLR",
                        style: tileTextStyle,
                      )
                    : Icon(Icons.backspace);
              },
            )),
          )),
      OperatorButton(
        operatorString: "=",
        onTap: () {},
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
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
//              flex: 1,
//              child: Row(
//                children: [
//                  Expanded(flex: 2, child: numPad()),
//                  Expanded(flex: 1, child: operatorKeys())
//                ],
//              ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
//                    Expanded(flex: 2, child: numPad()),
                    Expanded(flex: 2, child: Keypad(inputValueController: inputValueController,)),
                    Expanded(flex: 1, child: operatorKeys())
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

  Widget operatorKeys() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
      child: Row(
        children: [
//          Expanded(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisSize: MainAxisSize.min,
//              children: leftOperatorButtons
//                  .map((e) => Container(
//                        height: 100,
//                        child: e,
//                      ))
//                  .toList(),
//            ),
//          )
          Expanded(
            child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 0),
                shrinkWrap: true,
                itemCount: leftOperatorButtons.length,
                itemBuilder: (context, index) => leftOperatorButtons[index]),
          ),
//          Expanded(
//            child: GridView.builder(
//                gridDelegate:
//                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//                shrinkWrap: true,
//                itemCount: rightOperatorButtons.length,
//
//                itemBuilder: (context, index) => rightOperatorButtons[index]),
//          )
        ],
      ),
    );
  }

  Widget numPad() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [for (int i = 0; i < 3; i++) numberKeys[i]..width = constraints.maxWidth/3],
          ),
        );
      },
    );

//    return GridView.builder(
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 3,
//        ),
//        shrinkWrap: true,
//        itemCount: numberKeys.length,
//        itemBuilder: (context, index) => numberKeys[index]);
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
                fontSize: Theme.of(context).textTheme.headline1.fontSize,
              ),
              decoration: InputDecoration.collapsed(hintText: null),
            );
          },
        )
      ],
    );
  }
}
