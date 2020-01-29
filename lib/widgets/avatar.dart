import 'dart:io';
import 'package:flutter/material.dart';

Widget avatar(String title, MaterialColor color, Icon icon) {
  return Material(
    borderRadius: BorderRadius.circular(20.0),
    elevation: 3.0,
    child: CircleAvatar(
            child: icon,
            backgroundColor: color,
          ),
  );
}