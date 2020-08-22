import 'package:flutter/material.dart';
import 'package:flutter_calculator/ui/home.dart';

void main() {
  runApp(MyApp());
}

// global variable for changing app theme
ValueNotifier<Brightness> appTheme = ValueNotifier<Brightness>(Brightness.light);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appTheme,
      builder: (context, appTheme, child) {
        return MaterialApp(
          title: 'Flutter Calculator',
          theme: ThemeData(
              primarySwatch: Colors.lime,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: appTheme
          ),
          home: Home(),
        );
      },
    );
  }
}
