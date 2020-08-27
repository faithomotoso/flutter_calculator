import 'package:shared_preferences/shared_preferences.dart';

/// creates shared preferences instanc

class AppSharedPreferences {
  static SharedPreferences _preferences;
  // shared preferences key for app theme
  static String themeKey = "app_theme";

  static SharedPreferences get preferences {
    if (_preferences == null) {
      // get instance
      init();
    }
    return _preferences;
  }

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

}