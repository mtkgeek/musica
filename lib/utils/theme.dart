import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor:  Colors.lightBlueAccent,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
 cardTheme: CardTheme(color: Colors.white),

 
);

final lightTheme = ThemeData(
  primaryColor: Colors.lightBlueAccent,
);