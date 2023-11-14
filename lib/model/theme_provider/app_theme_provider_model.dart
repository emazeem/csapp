import 'package:flutter/material.dart';

class AppThemeProvider with ChangeNotifier {
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  AppThemeProvider({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  bool isDarkMode() {
    return _mode == ThemeMode.dark;
  }

  bool isLightMode() {
    return _mode != ThemeMode.dark;
  }
}
