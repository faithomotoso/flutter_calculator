import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/utils.dart';
import 'operator_button.dart';

class OperatorKeypad extends StatefulWidget {
  final TextEditingController inputValueController;

  OperatorKeypad({@required this.inputValueController})
      : assert(inputValueController != null, "Text controller can't be null");

  @override
  State<StatefulWidget> createState() {
    return _OperatorKeypadState();
  }
}

class _OperatorKeypadState extends State<OperatorKeypad> {
  TextEditingController inputValueController;
  List<OperatorButton> leftOperatorButtons;
  List rightOperatorButtons;

  // boolean determining if to show CLR text or backspace icon
  // CLR is shown when the equal to (=) button is pressed
  ValueNotifier<bool> showCLR = ValueNotifier<bool>(false);

  bool preventDuplicates = false; // todo change when triggered

  double keyWidth;
  double keyHeight;

  @override
  void initState() {
    super.initState();
    inputValueController = widget.inputValueController;
    initOperatorButtons();

    inputValueController.addListener(() {
      print(inputValueController.text);

      if (inputValueController.text.length == 0) {
        // reset
        setPreventDuplicates(prevent: false);
      }

      if (inputValueController.text.length == 1) {
        // dup?
        bool isNum = false;
        String firstVal = inputValueController.text[0];
        isNum = int.tryParse(firstVal) != null ? true : false;

        // prevent an operator except '-' from being the first
        if (!isNum && firstVal != "-") {
          // delete last entry
          String delString = inputValueController.text
              .substring(0, inputValueController.text.length - 1);
          inputValueController.text = delString;
        }
      }

      if (inputValueController.text.length > 0) {
        // trigger preventDuplicates when a number follows an operator
        // check if last added value is a number
        bool isNum = false;
        String lastVal =
            inputValueController.text[inputValueController.text.length - 1];
        isNum = int.tryParse(lastVal) != null ? true : false;

        // if isNum is true, set preventDuplicates to false
        // to allow operators again
        // if isNum is false, set preventDuplicates to true
        if (isNum)
          setPreventDuplicates(prevent: false);
        else
          setPreventDuplicates(prevent: true);
      }
    });
  }

  void initOperatorButtons() {
    leftOperatorButtons = [
      OperatorButton(
        operatorString: "\u00f7",
        onTap: () {
//          setPreventDuplicates();
        },
        inputValueController: inputValueController,
        preventDuplicates: preventDuplicates,
      ),
      OperatorButton(
        operatorString: "x",
        onTap: () {},
        inputValueController: inputValueController,
        preventDuplicates: preventDuplicates,
      ),
      OperatorButton(
        operatorString: "-",
        onTap: () {},
        inputValueController: inputValueController,
        preventDuplicates: preventDuplicates,
      ),
      OperatorButton(
        operatorString: "+",
        onTap: () {},
        inputValueController: inputValueController,
        preventDuplicates: preventDuplicates,
      ),
    ];

    // for backspace/clear and equals to buttons
    rightOperatorButtons = [
      backspaceButton(),
      OperatorButton(
        operatorString: "=",
        onTap: () {},
        preventDuplicates: false,
      )
    ];
  }

  void setPreventDuplicates({bool prevent}) {
    preventDuplicates = prevent ?? !preventDuplicates;
    // set boolean for each operator
    leftOperatorButtons.forEach((key) {
      key.preventDuplicates = preventDuplicates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder(
          future: assignDimensionsToKeys(constraints: constraints),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SizedBox();
            return Container(
                decoration:
                    BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                child: buildOperatorKeys());
          },
        );
      },
    );
  }

  Widget buildOperatorKeys() {
    Column leftColumn = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: leftOperatorButtons,
    );

    Column rightColumn = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: rightOperatorButtons.cast<Widget>(),
    );

    return Row(
      children: [leftColumn, rightColumn],
    );
  }

  Future assignDimensionsToKeys({@required BoxConstraints constraints}) async {
    keyWidth = constraints.maxWidth / 2;
    keyHeight = constraints.maxHeight / 4;

    // loop through left and right widget to assign dimensions
    leftOperatorButtons.forEach((key) {
      key
        ..width = keyWidth
        ..height = keyHeight;
    });

    // right widget
    // backspace button widget isn't of type OperatorButton
    // rebuild with new width and height differently
    // at index 0
    rightOperatorButtons.first =
        backspaceButton(height: keyHeight, width: keyWidth);
    rightOperatorButtons.skip(1).forEach((key) {
//      key = key as OperatorButton;
      key..width = keyWidth;
      key..height = keyHeight;
    });
  }

  Widget backspaceButton({double height, double width}) {
    return InkWell(
        // using inkWell directly to swap between
        // text and icon
        // todo swap when equals to button is tapped
        onTap: () {
          try {
            widget.inputValueController.text = widget.inputValueController.text
                .substring(0, widget.inputValueController.text.length - 1);
          } catch (e) {
            debugPrint("Out of range");
          }
        },
        onLongPress: () {
          widget.inputValueController.clear();
        },
        child: Container(
          height: height,
          width: width,
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
        ));
  }
}
