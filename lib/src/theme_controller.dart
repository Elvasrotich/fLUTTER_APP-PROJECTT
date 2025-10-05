import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _prefKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefKey);
    if (stored == 'light') {
      _mode = ThemeMode.light;
    } else if (stored == 'dark') {
      _mode = ThemeMode.dark;
    } else {
      _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await prefs.setString(_prefKey, value);
  }
}
