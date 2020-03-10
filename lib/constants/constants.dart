import 'package:flutter/material.dart';

const String googleMapsAPIKey = "AIzaSyCTEPXrAIOzVAEgr5XJ1MZm-DN04OX-Ntk";

Color kPrimaryColor = Color(0xFF34E795);
Color kSecondaryColor = Color(0xFFFEA700);
Color kBittersweet = Color(0xFFF56C57);
Color kForestGreen = Color(0xFF109321);
Color kMayaBlue = Color(0xFF6DC9FF);
Color kGreyChateau = Color(0xFF95989A);
Color kHavelockBlue = Color(0xFF4D8BD0);
Color kGoldenTainoi = Color(0xFFFFC95E);

double getTextScaleFactor(BuildContext context) {
  if ((MediaQuery.of(context).size.height > 600))
    return MediaQuery.textScaleFactorOf(context);
  else
    return 0.8;
}
