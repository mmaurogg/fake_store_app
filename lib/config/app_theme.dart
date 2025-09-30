import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData _themeApp = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo[50]!,
      primary: Colors.indigoAccent,
      secondary: Colors.blueGrey,
      tertiary: Colors.teal,
      surface: Colors.white,
      error: Colors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
  );

  ThemeData get themeApp => _themeApp;

  TextStyle get titleStyle =>
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  TextStyle get titleSmallStyle =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
}
