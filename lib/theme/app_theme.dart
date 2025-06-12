import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1E1E1E), // VSCode background
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF007ACC), // VSCode blue
        secondary: Color(0xFF4FC3F7),
        surface: Color(0xFF252526),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFFCCCCCC),
      ),
      useMaterial3: true,
      fontFamily: 'Segoe UI',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
        bodyLarge: TextStyle(color: Color(0xFFCCCCCC)),
        titleMedium: TextStyle(color: Color(0xFFCCCCCC), fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(color: Color(0xFFCCCCCC), fontWeight: FontWeight.w600),
      ),
      cardTheme: const CardTheme(color: Color(0xFF252526), elevation: 0, margin: EdgeInsets.zero),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF3C3C3C),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF007ACC), width: 1)),
      ),
    );
  }

  // Color constants
  static const Color background = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFF252526);
  static const Color header = Color(0xFF2D2D30);
  static const Color primary = Color(0xFF007ACC);
  static const Color text = Color(0xFFCCCCCC);
  static const Color textSecondary = Color(0xFF858585);
  static const Color divider = Color(0xFF3C3C3C);

  // Algorithm state colors
  static const Color normal = Color(0xFF569CD6);
  static const Color comparing = Color(0xFFDCDCAA);
  static const Color swapping = Color(0xFFF44747);
  static const Color sorted = Color(0xFF4EC9B0);
}
