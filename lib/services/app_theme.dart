import 'package:flutter/material.dart';

// Define your app theme
final ThemeData appTheme = ThemeData(
  // Define your app colors
  primaryColor: Colors.deepPurple,
  // accentColor: Colors.orange,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.deepPurple,
    // accentColor: Colors.orange,
  ),
  // Define your text theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
  // Define your app bar theme
  appBarTheme: const AppBarTheme(
    color: Colors.deepPurple,
  ),
  // Define your button theme
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.deepPurple,
  ),
  // Define your icon theme
  iconTheme: const IconThemeData(
    color: Colors.deepPurple,
  ),
);
