import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function validator;
  final TextInputType textInputType;
  CustomTextField(
      {this.controller, this.hintText, this.validator, this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: textInputType,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Consolas",
      ),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: "Consolas",
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.grey,
          ),
          onPressed: () => controller.clear(),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kBittersweet),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kBittersweet),
        ),
      ),
    );
  }
}
