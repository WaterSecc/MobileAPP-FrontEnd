import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      secondaryHeaderColor: black,
      primaryColor: black,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.light,
        backgroundColor: white,
        accentColor: black,
        cardColor: blue,
        errorColor: red,

        // tertiary: gray, seedColor: blue,
      ));
  static final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        backgroundColor: black,
        accentColor: white,
        cardColor: darkBlue,
        errorColor: red,
        //tertiary: gray, seedColor: blue,
      ));
}
