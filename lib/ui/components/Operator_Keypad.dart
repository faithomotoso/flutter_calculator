import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/utils.dart';
import 'operator_button.dart';

class OperatorKeypad extends StatefulWidget {
  final TextEditingController inputValueController;
  final Function onEqualsTapped;
  // using this to pass ValueNotfier for swapping
  // backspace icon for 'CLR'
  Function onEqualsCreated;

  OperatorKeypad(
      {@required this.inputValueController,
      this.onEqualsTapped,
      this.onEqualsCreated})
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

  bool preventDuplicates = false;

  double keyWidth;
  double keyHeight;


  @override
  void initState() {
    super.initState();
    inputValueController = widget.inputValueController;
    initOperatorButtons();

    inputValueController.addListener(() {
      if (inputValueController.text.length == 0) {
        // reset
        setPreventDuplicates(prevent: false);
      }

      if (inputValueController.text.length == 1) {
        // dup?
        String firstVal = inputValueController.text[0];
        bool isNum = int.tryParse(firstVal) != null ? true : false;
        // for '.'
        isNum = firstVal == "." ? true : isNum;

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
        String lastVal =
            inputValueController.text[inputValueController.text.length - 1];
        bool isNum = int.tryParse(lastVal) != null ? true : false;

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
        onTap: () {},
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
        onTap: () {
          widget.onEqualsTapped?.call();
        },
        preventDuplicates: false,
      )
    ];

    // pass value notifier to swap icons
    widget.onEqualsCreated?.call(showCLR);
  }

  void setPreventDuplicates({bool prevent}) {
    preventDuplicates = prevent ?? !preventDuplicates;
    // set boolean for each operator
    leftOperatorButtons.forEach((key) {
      if (key.operatorString != '-') key.preventDuplicates = preventDuplicates;
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      key..width = keyWidth;
      key..height = keyHeight;
    });
  }

  Widget backspaceButton({double height, double width}) {
    return ValueListenableBuilder(
      valueListenable: showCLR,
      builder: (context, showCLR, child) {
        return InkWell(
            // using inkWell directly to swap between
            // text and icon
            // todo swap when equals to button is tapped
            onTap: !showCLR
                ? () {
                    try {
                      widget.inputValueController.text =
                          widget.inputValueController.text.substring(
                              0, widget.inputValueController.text.length - 1);
                    } catch (e) {
                      debugPrint("Out of range");
                    }
                  }
                : () {
                    widget.inputValueController.clear();
                  },
            onLongPress: !showCLR
                ? () {
                    widget.inputValueController.clear();
                  }
                : null,
            child: Container(
              height: height,
              width: width,
              child: Center(
                  child: showCLR
                      ? Text(
                          "CLR",
                          style: tileTextStyle,
                        )
                      : Icon(Icons.backspace)),
            ));
      },
    );
  }
}
