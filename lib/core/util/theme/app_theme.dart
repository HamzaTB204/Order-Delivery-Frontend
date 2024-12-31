import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const flexTheme = FlexColorScheme(
    brightness: Brightness.dark,
    colorScheme:
        ColorScheme.dark(brightness: Brightness.dark, primary: Colors.black),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
      displayMedium: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          fontFamily: "PlayfairDisplay",
          letterSpacing: 2),
      displaySmall: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 25,
          letterSpacing: 2,
          fontWeight: FontWeight.w800,
          fontFamily: "PlayfairDisplay",
          color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: "PlayfairDisplay",
          color: Colors.white,
          letterSpacing: 2),
      bodySmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: "PlayfairDisplay",
          color: Colors.white),
      labelSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: "PlayfairDisplay",
          color: Colors.white70),
    ));
