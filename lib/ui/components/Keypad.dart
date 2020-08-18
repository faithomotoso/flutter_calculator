import 'package:flutter/material.dart';

import 'button_tile.dart';

class Keypad extends StatefulWidget {
  final TextEditingController inputValueController;

  Keypad({@required this.inputValueController})
      : assert(inputValueController != null, "Pass in text controller");

  @override
  State<StatefulWidget> createState() {
    return _KeypadState();
  }
}

class _KeypadState extends State<Keypad> {
  TextEditingController inputValueController;
  List<NumberKey> numberKeys;
  int tilesPerRow = 3;
  BoxConstraints boxConstraints; // boxConstraints used to assign dimensions to tiles

  @override
  void initState() {
    super.initState();
    inputValueController = widget.inputValueController;
    initNumberKeys();
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
        preventDuplicates: true, // todo change implementation, to be based on equation entries
      ),
      NumberKey(
        tileString: "0",
        inputValue: inputValueController,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        boxConstraints = constraints;
//        assignDimensionsToKeys(constraints: constraints);

//        return Container(
//            height: constraints.maxHeight,
//            width: constraints.maxWidth,
//            child: buildKeys());

        // using FutureBuilder for size change in foldables
        // app was tested on android emulator foldable api

      return FutureBuilder(
        future: assignDimensionsToKeys(constraints: constraints),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) return SizedBox();

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

    int rows =
        (numberKeys.length / tilesPerRow).round(); // find the number of rows being used

    double keyHeight = constraints.maxHeight / rows;
    numberKeys.forEach((key) {
      key
        ..width = keyWidth
        ..height = keyHeight;
    });
  }

  Widget buildKeys() {
    print("buildKeys called ${numberKeys[0].width}");

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
}
