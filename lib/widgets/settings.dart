import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/theme_provider.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';


class SettingsScreen extends StatefulWidget {
// final bool switchValue;
// final ValueChanged valueChanged;

// SettingsScreen({this.switchValue, this.valueChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var themeNotifier;
   
  @override
  Widget build(BuildContext context) {
    
    themeNotifier = Provider.of<ThemeNotifier>(context);
    
   
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Dark Mode',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            Switch.adaptive(
              activeColor: Colors.lightBlueAccent,
              inactiveTrackColor: Colors.grey,
              value: themeNotifier.darkOn,
  onChanged: (bool newValue) {
    
    setState(() {
      themeNotifier.darkOn = newValue;
    });
    themeNotifier.darkOn ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
  },
            ),
          ],
        ),
      ),
    );
  }
}
