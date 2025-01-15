import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final flexTheme = FlexColorScheme(
    brightness: Brightness.dark,
    fontFamily: "Roboto",
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Colors.black,
      surface: Colors.grey.shade800,
      secondary: Colors.white,
      tertiary: Colors.green,
      onTertiary: Colors.green.shade600,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
      displayMedium: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          fontFamily: "Roboto",
          letterSpacing: 2),
      displaySmall: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 25,
          letterSpacing: 2,
          fontWeight: FontWeight.w800,
          fontFamily: "Roboto",
          color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: "Roboto",
          color: Colors.white,
          letterSpacing: 2),
      bodySmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          color: Colors.white),
      labelSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          color: Colors.white70),
      titleMedium: TextStyle(
          fontSize: 25,
          letterSpacing: 2,
          fontWeight: FontWeight.w800,
          fontFamily: "Roboto",
          color: Colors.greenAccent),
      titleSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          color: Colors.green),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          fontFamily: "Roboto",
          letterSpacing: 2,
          color: Colors.black),
    ));
