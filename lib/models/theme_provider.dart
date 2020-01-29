import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musica/utils/theme.dart';

class ThemeNotifier with ChangeNotifier {
  var _themeBox = Hive.box('theme');
  bool _darkOn;
  ThemeData _themeData;

  ThemeNotifier();

  ThemeData get theme => darkOn ? _themeData = darkTheme : _themeData = lightTheme;
  Box get themeBox => _themeBox;
  bool get darkOn => _darkOn = themeBox.get('darkON') ?? false;

  set darkOn(bool value) {
    _darkOn = value;
    _themeBox.put('darkON', _darkOn);
    notifyListeners();
  }

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    
    notifyListeners();
  }
}