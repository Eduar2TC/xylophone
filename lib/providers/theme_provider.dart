import 'package:flutter/material.dart';
import 'package:xylophone/core/constants/app_themes.dart';
import 'package:xylophone/core/helpers/prefs_helper.dart';

enum AppTheme { charcoal, light, dark, system, ocean }

extension AppThemeExtension on AppTheme {
  String get storageKey => toString().split('.').last;

  static AppTheme fromStorageKey(String key) =>
      AppTheme.values.firstWhere(
        (e) => e.storageKey == key,
        orElse: () => AppTheme.charcoal,
      );
}

class ThemeProvider extends ChangeNotifier {
  static final Map<AppTheme, ThemeData> _themeMap = {
    AppTheme.charcoal: AppThemes.charcoal,
    AppTheme.light: AppThemes.lightTheme,
    AppTheme.dark: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF1a1a1a),
      primaryColor: const Color(0xFF1a1a1a),
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: Color(0xFF1a1a1a),
        surface: Color(0xFF2a2a2a),
        surfaceContainer: Color(0xFF2a2a2a),
        secondary: Color(0xFF2a2a2a),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F0F0F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(const Color(0xff8f8c93)),
        trackColor: WidgetStateProperty.all<Color>(const Color(0xff4b4b4b)),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
      ),
    ),
    AppTheme.ocean: AppThemes.ocean,
  };

  static final Map<AppTheme, ThemeMode> _themeModeMap = {
    AppTheme.light: ThemeMode.light,
    AppTheme.dark: ThemeMode.dark,
    AppTheme.system: ThemeMode.system,
    AppTheme.charcoal: ThemeMode.dark,
    AppTheme.ocean: ThemeMode.dark,
  };

  AppTheme _currentTheme = AppTheme.charcoal;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final themeKey = (await PrefsHelper.prefs).getString('app_theme');
    if (themeKey != null) {
      _currentTheme = AppThemeExtension.fromStorageKey(themeKey);
    }
    notifyListeners();
  }

  AppTheme get currentTheme => _currentTheme;

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    (await PrefsHelper.prefs).setString('app_theme', theme.storageKey);
    notifyListeners();
  }

  ThemeMode get themeMode => _themeModeMap[_currentTheme] ?? ThemeMode.system;

  ThemeData get themeData {
    if (_currentTheme == AppTheme.system) {
      final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (platformBrightness == Brightness.dark) {
        return ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1a1a1a),
          primaryColor: const Color(0xFF1a1a1a),
          colorScheme: const ColorScheme.dark(
            brightness: Brightness.dark,
            primary: Color(0xFF1a1a1a),
            surface: Color(0xFF2a2a2a),
            surfaceContainer: Color(0xFF2a2a2a),
            secondary: Color(0xFF2a2a2a),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F0F0F),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.all<Color>(const Color(0xff8f8c93)),
            trackColor: WidgetStateProperty.all<Color>(const Color(0xff4b4b4b)),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            displayLarge: TextStyle(color: Colors.white),
            displayMedium: TextStyle(color: Colors.white),
            displaySmall: TextStyle(color: Colors.white),
            headlineLarge: TextStyle(color: Colors.white),
            headlineMedium: TextStyle(color: Colors.white),
            headlineSmall: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white),
          ),
        );
      } else {
        return AppThemes.lightTheme;
      }
    }
    
    return _themeMap[_currentTheme] ?? AppThemes.charcoal;
  }
}
