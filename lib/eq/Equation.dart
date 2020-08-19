import 'package:flutter/cupertino.dart';
import 'package:flutter_calculator/ui/components/utils.dart';
import 'package:math_expressions/math_expressions.dart';

class Equation {
  static Parser parser = Parser();
  static Expression expression;
  static ContextModel contextModel = ContextModel();

  static void parseEquation({@required TextEditingController inputController}) {
    // get text from controller and parse
    // parse only when controller has text
    if (inputController.text.length > 0) {
      try {
        String input = inputController.text;
        input = replaceSymbols(text: input);
        expression = parser.parse(input);
      } catch (e) {
        debugPrint("An error occurred while parsing: $e");
      }
    }
  }

  static String replaceSymbols({@required String text}) {
    // replace x with *
    // and divider symbol with /

    text = text
        .replaceAll(RegExp('x'), '*')
        .replaceAll(RegExp(dividerUnicode), "/");

    return text;
  }

  static double solve({@required TextEditingController inputController}) {
    parseEquation(inputController: inputController);
    double result = expression.evaluate(EvaluationType.REAL, contextModel);
    return result;
  }
}
