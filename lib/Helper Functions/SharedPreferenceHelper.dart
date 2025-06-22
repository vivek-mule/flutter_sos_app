// This file contains all the functions required for the shared preferences access


import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static SharedPreferences? _prefs;

  // Initialize the SharedPreferences instance
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter for the prefs instance; throw an error if not initialized
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized!");
    }
    return _prefs!;
  }

  static String? getString(String key) => prefs.getString(key);
  static Future<bool> setString(String key, String value) => prefs.setString(key, value);

  static int? getInt(String key) => prefs.getInt(key);
  static Future<bool> setInt(String key, int value) => prefs.setInt(key, value);

  static bool? getBool(String key) => prefs.getBool(key);
  static Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);
}
