import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber),
          visualDensity: VisualDensity.comfortable,
          padding: MaterialStateProperty.all(
              const EdgeInsets.only(left: 80, right: 80)),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
          textStyle:
              MaterialStateProperty.all(const TextStyle(color: Colors.black87)),
          elevation: MaterialStateProperty.all(6))),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
    focusColor: Colors.amber,
    border: OutlineInputBorder(
      borderSide: BorderSide(),
    ),
    prefixIconColor: Colors.amber,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.dark),
  ),
);
