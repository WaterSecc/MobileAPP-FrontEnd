import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    secondaryHeaderColor: black,
    primaryColor: black,
    colorScheme: ColorScheme.light(
      background: Colors.white, // Set your background color here
      primary: black, // Set your primary color here
      onPrimary: Colors.white, // Text/icon color on primary
      secondary: black, // Accent color
      error: red,
      tertiaryFixed: blue
      //surface: blue, // Card color or surface
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      background: Colors.black, // Set your background color here for dark theme
      primary: white,
      onPrimary: black,
      secondary: white,
      error: red,
      tertiaryFixed: darkBlue
      // surface: darkBlue,
    ),
  );
}
