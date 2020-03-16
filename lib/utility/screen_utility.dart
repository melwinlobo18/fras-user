import 'package:flutter/material.dart';

class ScreenUtility {
  static bool isDesktop(BuildContext context) {
    return (MediaQuery.of(context).size.width > 450);
  }

  static bool isMobile(BuildContext context) {
    return (MediaQuery.of(context).size.width < 450);
  }
}
