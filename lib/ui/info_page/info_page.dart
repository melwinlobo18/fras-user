import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/homepage/homepage.dart';
import 'package:ifrauser/ui/info_page/info_page_desktop/info_page_desktop.dart';
import 'package:ifrauser/ui/info_page/info_page_mobile/info_page_mobile.dart';
import 'package:ifrauser/ui/widgets/custom_fab.dart';
import 'package:ifrauser/ui/widgets/title.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:intl/intl.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool _isFetching = true;
  double height;
  double width;
  double diagonalRatio;
  MissingPerson _missingPerson;

  int _fetchIssueNumber() {
    /// Get the issue number from [queryParameters]
    int issueNumber;
    var uri = Uri.tryParse(js.context['location']['href']);
    if (uri?.queryParameters['issueNumber'] != null)
      issueNumber = int.parse(uri.queryParameters['issueNumber']);
    return issueNumber;
  }

  _fetchMissingPersonDetails() async {
    final int issueNumber = _fetchIssueNumber();
    await MissingPersonService.fetchMissingPersonDetails(issueNumber)
        .then((missingPerson) {
      _missingPerson = missingPerson;
      setState(() {
        _isFetching = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMissingPersonDetails();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    diagonalRatio = sqrt((width * width) + (height * height));
    bool _isDesktop = (width > 450) ? true : false;
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isDesktop
          ? null
          : CustomFAB(
              backgroundColor: Colors.black,
              textColor: kPrimaryColor,
              buttonTitle: 'REPORT SIGHTING',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              borderRadius: BorderRadius.zero,
            ),
      body: Column(
        children: <Widget>[
          HomeTitle(height: height),
          Expanded(
            child: Container(
              color: Colors.white,
              child: _isFetching
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                      ),
                    )
                  : _isDesktop
                      ? InfoPageDesktop(
                          diagonalRatio: diagonalRatio,
                          missingPerson: _missingPerson,
                          width: width,
                          height: height)
                      : InfoPageMobile(
                          diagonalRatio: diagonalRatio,
                          missingPerson: _missingPerson,
                          width: width,
                          height: height),
            ),
          )
        ],
      ),
    );
  }
}
