import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';

class RadioButton extends StatelessWidget {
  final String radioText;
  final int radioValue;
  final int selectedRadioValue;
  final Function handleRadioValueChange;
  final Color activeTextColor;

  RadioButton(
      {this.radioText,
      this.selectedRadioValue,
      this.radioValue,
      this.handleRadioValueChange,
      this.activeTextColor});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        iconColor: Colors.grey,
        child: Theme(
          data: ThemeData.dark(),
          child: RadioListTile(
            dense: true,
            title: Text(
              radioText,
              style: TextStyle(
                color: activeTextColor,
                fontSize: 16,
                fontFamily: "Consolas",
              ),
            ),
            value: radioValue,
            groupValue: selectedRadioValue,
            onChanged: handleRadioValueChange,
            activeColor: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
