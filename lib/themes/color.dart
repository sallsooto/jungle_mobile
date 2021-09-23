import 'package:flutter/material.dart';
const PrimaryColor = const Color(0xFF2e4053);
const PrimaryColorLight = const Color(0xFF596b7f);
const PrimaryColorDark = const Color(0xFF051a2a);
const SecondaryColor = const Color(0xFFfa8231);
const SecondaryColorLight = const Color(0xFFffb360);
const SecondaryColorDark = const Color(0xFFc15300);
const Background = const Color(0xFFfffdf7);
const TextColor = const Color(0xFFffffff);
class MyTheme {
  static final ThemeData defaultTheme = _buildMyTheme();
  static ThemeData _buildMyTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      accentColor: SecondaryColor,
      accentColorBrightness: Brightness.dark,
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      primaryColorBrightness: Brightness.dark,
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: SecondaryColor,
        focusColor: SecondaryColorDark
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(SecondaryColor),
          textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(10)),
          minimumSize: MaterialStateProperty.all<Size>(Size(100, 50)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: SecondaryColor)
          )),
        )
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(SecondaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red)
          )),
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      scaffoldBackgroundColor: Background,
      cardColor: Background,
      textSelectionTheme:TextSelectionThemeData(
        selectionColor: PrimaryColorLight,
      ),
        backgroundColor: Background,);
  }
}