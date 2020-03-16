import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "404",
                style: TextStyle(
                    fontFamily: "Consolas", fontSize: 64, color: Colors.white),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'The page you are looking for is ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Consolas",
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Consolas",
                      ),
                    ),
                    TextSpan(
                      text: 'i',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontFamily: "Consolas",
                      ),
                    ),
                    TextSpan(
                      text: 'ss',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Consolas",
                      ),
                    ),
                    TextSpan(
                      text: 'i',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontFamily: "Consolas",
                      ),
                    ),
                    TextSpan(
                      text: 'ng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Consolas",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
