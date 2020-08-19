import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatNumber({@required String num}) {
  NumberFormat numberFormat = NumberFormat();
  return numberFormat.format(num);
}

TextStyle tileTextStyle = TextStyle(fontSize: 22);

String dividerUnicode = "\u00f7";
