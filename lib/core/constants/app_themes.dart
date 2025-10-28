import 'package:flutter/material.dart';

class AppThemes {
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
  );
}
