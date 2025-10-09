import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData _themeApp = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.seedColor,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
  );

  ThemeData get themeApp => _themeApp;

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const titleHighlightStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const titleSmallStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const titleSmallHighlightStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}

class AppColors {
  static const seedColor = Colors.indigo;
  static const primary = Colors.indigoAccent;
  static const secondary = Colors.blueGrey;
  static const tertiary = Colors.teal;
  static const surface = Colors.white;
  static const error = Colors.red;
}
