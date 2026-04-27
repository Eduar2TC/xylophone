import 'package:flutter/material.dart';
import 'package:xylophone/core/constants/app_themes.dart';
import 'package:xylophone/core/helpers/prefs_helper.dart';

enum AppTheme { defaultTheme, light, dark, system, ocean }

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.defaultTheme;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final theme = (await PrefsHelper.prefs).getString('app_theme');
    if (theme != null) {
      _currentTheme = AppTheme.values.firstWhere(
        (e) => e.toString().split('.').last == theme,
        orElse: () => AppTheme.defaultTheme,
      );
    }
    notifyListeners();
  }

  AppTheme get currentTheme => _currentTheme;

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    (await PrefsHelper.prefs).setString('app_theme', theme.toString().split('.').last);
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
      case AppTheme.defaultTheme:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.defaultTheme:
        return AppThemes.defaultTheme;
      case AppTheme.light:
        return ThemeData.light();
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.ocean:
        return AppThemes.ocean;
      case AppTheme.system:
      default:
        return AppThemes.defaultTheme;
    }
  }
}
