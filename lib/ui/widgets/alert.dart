import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StatusAlert {
  static Future<bool> showStatusAlert(
      {BuildContext context,
      String title,
      String description,
      AlertType alertType}) {
    return Alert(
            style: AlertStyle(
              isCloseButton: false,
              animationType: AnimationType.fromTop,
              animationDuration: Duration(milliseconds: 400),
            ),
            context: context,
            type: alertType,
            buttons: [
              DialogButton(
                color: kPrimaryColor,
                child: Text(
                  "OKAY",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
            title: title,
            desc: description)
        .show();
  }
}
