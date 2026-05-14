import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData charcoal = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF23242a),
    scaffoldBackgroundColor: const Color(0xFF23242a),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF0F0F0F),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F0F0F),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white24,
    // Botón circular y otros colores personalizados
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff8f8c93),
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF282828),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.white70, fontSize: 16),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all<Color>(const Color(0xff8f8c93)),
      trackColor: WidgetStateProperty.all<Color>(const Color(0xff4b4b4b)),
    ),
    // Puedes agregar más propiedades si usas ElevatedButton, TextButton, etc.
  );

  static final ThemeData ocean = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xff0a3d62),
    scaffoldBackgroundColor: const Color(0xff0a3d62),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xff3c6382),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff0a3d62),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white24,
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xff3c6382),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.white70, fontSize: 16),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all<Color>(const Color(0xff82ccdd)),
      trackColor: WidgetStateProperty.all<Color>(const Color(0xff3c6382)),
    ),
  );
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.grey[200],
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );
}
