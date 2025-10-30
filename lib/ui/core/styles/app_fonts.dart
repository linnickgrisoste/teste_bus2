import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  static const String robotFamily = 'Roboto';

  static TextStyle bold(double size, [Color? color]) {
    return TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w700, fontFamily: robotFamily);
  }

  static TextStyle regular(double size, [Color? color]) {
    return TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w400, fontFamily: robotFamily);
  }

  static TextStyle medium(double size, [Color? color]) {
    return TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w500, fontFamily: robotFamily);
  }
}
