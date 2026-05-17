import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';

  bool _isDark = true;

  // Getter
  bool get isDark => _isDark;

  ThemeMode get themeMode =>
      _isDark ? ThemeMode.dark : ThemeMode.light;

  // Constructor
  ThemeProvider() {
    loadTheme();
  }

  // =========================
  // LOAD THEME
  // =========================

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDark = prefs.getBool(_themeKey) ?? true;

    notifyListeners();
  }

  // =========================
  // TOGGLE THEME
  // =========================

  Future<void> toggleTheme() async {
    _isDark = !_isDark;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_themeKey, _isDark);

    notifyListeners();
  }

  // =========================
  // SET DARK MODE
  // =========================

  Future<void> setDarkMode(bool value) async {
    _isDark = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_themeKey, _isDark);

    notifyListeners();
  }
}