import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get themeApp => ThemeData(
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
}
