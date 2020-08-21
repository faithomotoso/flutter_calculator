import 'dart:math';

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
      // search if string contains a number and an operator
      // e.g 5+, 2*
      // if false, answerController should be blank
      // if true, solve equation

      // [+-]? allows negatives
      // \d* finds digits, * allows more than one digit, \.?\d+ allows decimals
      // ([+]|x|[divider]|[-]) finds either of the operators
      // [^\0] finds a non-null character, a digit in this case so
      // 44+33 returns true, 44+ returns false
      String regSearchString = r"^[+-]?\d*\.?\d+([+]|x|[divider]|[-])[^\0]"
          .replaceAll(RegExp('divider'), dividerUnicode);

      String input = inputController.text;

      bool canEval = input.startsWith(RegExp(regSearchString));

      if (canEval) {
        try {
          input = replaceSymbols(text: input);
          expression = parser.parse(input);
        } catch (e) {
          debugPrint("An error occurred while parsing: $e");
        }
      } else {
        expression = null;
//        throw "Can't evaluate";
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

  static num solve({@required TextEditingController inputController}) {
    parseEquation(inputController: inputController);
    num result = expression?.evaluate(EvaluationType.REAL, contextModel);
//    print("result: $result, expression: $expression");
    if (result != null) result = formatResult(result: result);
    return result;
  }

  static num formatResult({@required num result}) {
    // result comes with .0 regardless
    // e,g 2 * 3 would give 6.0
    // this function removes unnecessary '.0' and

    num r = result;

    // split on '.'
    List<String> splitR = r.toString().split('.');
    String wholeNumber = splitR.first;
    String decimal = splitR.last;

    int decimalInt = int.parse(decimal);
    if (decimal.length > 6) {
      r = double.parse(result.toStringAsFixed(decimal.length -2));
    } else if (decimalInt == 0) {
      // for results like 6.0
      r = int.parse(wholeNumber);
    }

    return r;
  }
}
