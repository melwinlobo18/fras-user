import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ifrauser/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function validator;
  final TextInputType textInputType;
  final InputBorder inputBorder;
  final int maxLines;
  CustomTextField(
      {this.controller,
      this.hintText,
      this.validator,
      this.textInputType,
      this.inputBorder,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Consolas",
      ),
      validator: validator,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: "Consolas",
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              controller.clear();
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Icon(Icons.cancel, color: Colors.grey, size: 18.0),
          ),
        ),
        errorStyle: TextStyle(
          color: kBittersweet,
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: kBittersweet),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: kBittersweet),
        ),
      ),
    );
  }
}
