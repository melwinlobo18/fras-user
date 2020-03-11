import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final Color backgroundColor;
  final String buttonTitle;
  final Function onPressed;

  CustomFAB({this.backgroundColor, this.buttonTitle, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: backgroundColor,
      label: Text(
        buttonTitle,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "Consolas",
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      isExtended: true,
      onPressed: onPressed,
    );
  }
}
