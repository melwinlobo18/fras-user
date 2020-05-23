import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "404",
                style: TextStyle(
                    fontFamily: "Consolas",
                    fontSize: 64,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(3.0, 3.0),
                        color: kPrimaryColor,
                      )
                    ]),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Looks like this page is ',
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.05),
                child: Text(
                  "Don't worry, we have our best man on the case.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: "Consolas", color: kPrimaryColor),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: AssetImage('assets/images/detective.png'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
