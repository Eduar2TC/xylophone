import 'package:flutter/material.dart';
import 'package:xylophone/core/constants/app_themes.dart';

enum AppTheme { light, dark, system, ocean }

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.system;

  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.light:
        return ThemeData.light();
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.ocean:
        return AppThemes.ocean;
      case AppTheme.system:
      default:
        return ThemeData.fallback();
    }
  }
}
