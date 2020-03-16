import 'package:flutter/material.dart';
import 'package:ifrauser/ui/home_page/home_page.dart';
import 'package:ifrauser/ui/info_page/info_page.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:ifrauser/ui/widgets/title.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => _navigationRoute());
  }

  int _fetchIssueNumber() {
    /// Get the issue number from [queryParameters]
    int issueNumber;
    var uri = Uri.tryParse(js.context['location']['href']);
    if (uri?.queryParameters['issueNumber'] != null)
      issueNumber = int.parse(uri.queryParameters['issueNumber']);
    return issueNumber;
  }

  _navigationRoute() {
    final int issueNumber = _fetchIssueNumber();
    if (issueNumber == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoPage(
                  issueNumber: issueNumber,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: Center(
        child: HomeTitle(
          height: height,
        ),
      ),
    );
  }
}
