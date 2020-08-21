import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/components/utils.dart';
import 'number_key.dart';

class Keypad extends StatefulWidget {
  final TextEditingController inputValueController;

  Keypad({@required this.inputValueController})
      : assert(inputValueController != null, "Text controller can't be null");

  @override
  State<StatefulWidget> createState() {
    return _KeypadState();
  }
}

class _KeypadState extends State<Keypad> {
  TextEditingController inputValueController;
  List<NumberKey> numberKeys;
  int tilesPerRow = 3;
  BoxConstraints
      boxConstraints; // boxConstraints used to assign dimensions to tiles
  int dotIndex; // index of '.' key

  @override
  void initState() {
    super.initState();
    inputValueController = widget.inputValueController;
    initNumberKeys();

    widget.inputValueController.addListener(() {
      preventDuplicateDots();
    });
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
        preventDuplicates:
            true,
      ),
      NumberKey(
        tileString: "0",
        inputValue: inputValueController,
      ),
    ];

    // store dot index
    dotIndex = numberKeys.indexWhere((k) => k.tileString == '.');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        boxConstraints = constraints;
//        assignDimensionsToKeys(constraints: constraints);

        // using FutureBuilder for size change in foldables
        // app was tested on android emulator foldable device

        return FutureBuilder(
          future: assignDimensionsToKeys(constraints: constraints),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SizedBox();

            return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: buildKeys());
          },
        );
      },
    );
  }

  Future assignDimensionsToKeys({@required BoxConstraints constraints}) async {
    // assign width and height to all number keys in the list
    double keyWidth = constraints.maxWidth / tilesPerRow;

    int rows = (numberKeys.length / tilesPerRow)
        .round(); // find the number of rows being used

    double keyHeight = constraints.maxHeight / rows;
    numberKeys.forEach((key) {
      key
        ..width = keyWidth
        ..height = keyHeight;
    });
  }

  Widget buildKeys() {
    // append row to rows list based on tilesPerRow
    List<Row> rows = [];
    int start = 0;
    int end = 3;

    while (true) {
      if (end > numberKeys.length) {
        end = numberKeys.length;
      }

      Row r = Row(
        children: numberKeys.getRange(start, end).toList(),
      );
      rows.add(r);

      if (end == numberKeys.length) {
        // break at end of list
        break;
      }

      start += 3;
      end += 3;
    }

    return Column(
      children: rows,
    );
  }

  void preventDuplicateDots() {
    // prevent duplicate '.'
    // e.g. 4.5.1

    // get the last index of an operator in the string
    String lastIndexRegex =
        r"([+]|[-]|x|[divider])".replaceAll(RegExp('divider'), dividerUnicode);

    int index = widget.inputValueController.text.lastIndexOf(RegExp(lastIndexRegex));

    // split string from last index to the end
    // if last index character isn't an operator
    if (index < widget.inputValueController.text.length) {
      String lastNum = widget.inputValueController.text.substring(index + 1);

      // if '.' is not in lastNum
      // set preventDuplicates variable of '. key to false
      // to allow '.' to be inputted
      if (!(lastNum.contains(RegExp(r"[.]")))) {
        numberKeys[dotIndex].preventDuplicates = false;
      } else {
        numberKeys[dotIndex].preventDuplicates = true;
      }
    }
  }
}
