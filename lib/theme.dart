import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.green,
  primaryColor: Colors.green[400],
  hintColor: Colors.green[300],
  scaffoldBackgroundColor: Colors.green[100],
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.green[400],
      titleTextStyle: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      )),
  elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
    foregroundColor: WidgetStatePropertyAll(Colors.white),
  )),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.green),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.green[100],
    selectedItemColor: Colors.green[400],
    unselectedItemColor: Colors.green[300],
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.brown[400],
    elevation: 10,
  ),
);
