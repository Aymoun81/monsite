import 'package:flutter/material.dart';

/// Thème générique v1. À remplacer par la charte graphique réelle
/// une fois le cahier des charges disponible (couleurs, typographie, logo).
class AppTheme {
  AppTheme._();

  static const Color seed = Color(0xFF2E7D32);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );
}
