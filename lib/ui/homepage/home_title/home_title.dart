import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.05),
        child: RichText(
          text: TextSpan(
            text: 'm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: "Consolas",
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'i',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 28,
                  fontFamily: "Consolas",
                ),
              ),
              TextSpan(
                text: 'ss',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: "Consolas",
                ),
              ),
              TextSpan(
                text: 'i',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 28,
                  fontFamily: "Consolas",
                ),
              ),
              TextSpan(
                text: 'ng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: "Consolas",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
