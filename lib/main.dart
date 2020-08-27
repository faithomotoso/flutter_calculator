import 'package:flutter/material.dart';
import 'package:flutter_calculator/storage/shared_prefs.dart';
import 'package:flutter_calculator/ui/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPreferences.init();
  appTheme.value = (AppSharedPreferences.preferences
          .getBool(AppSharedPreferences.themeKey) ?? false)
      ? Brightness.dark
      : Brightness.light;
  runApp(MyApp());
}

// global variable for changing app theme
ValueNotifier<Brightness> appTheme =
    ValueNotifier<Brightness>(Brightness.light);

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
              brightness: appTheme),
          home: Home(),
        );
      },
    );
  }
}
