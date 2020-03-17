import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';

class CustomFAB extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String buttonTitle;
  final Function onPressed;
  final BorderRadius borderRadius;

  CustomFAB(
      {this.backgroundColor,
      this.buttonTitle,
      this.onPressed,
      this.borderRadius,
      this.textColor});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: backgroundColor,
      label: Text(
        buttonTitle,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "Consolas",
        ),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: kPrimaryColor),
          borderRadius: borderRadius ?? BorderRadius.circular(20)),
      isExtended: true,
      onPressed: onPressed,
    );
  }
}
