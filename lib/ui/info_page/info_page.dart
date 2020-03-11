import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/homepage/homepage.dart';
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
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFAB(
        backgroundColor: kPrimaryColor,
        buttonTitle: 'REPORT SIGHTING',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      body: Column(
        children: <Widget>[
          HomeTitle(height: height),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: _isFetching
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: diagonalRatio * 0.05,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: diagonalRatio * 0.1,
                                width: diagonalRatio * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                    image: (_missingPerson?.imageUrl != null)
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                _missingPerson.imageUrl))
                                        : null),
                                child: (_missingPerson?.imageUrl == null)
                                    ? FlutterLogo()
                                    : null,
                              ),
                              SizedBox(
                                width: width * 0.05,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _missingPerson?.name ?? 'Undefined',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Consolas",
                                    ),
                                  ),
                                  Text(
                                    'IFRA ALERT',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontFamily: "Consolas",
                                    ),
                                  ),
                                  Text(
                                    'ISSUE NO. ${_missingPerson?.issueNumber ?? 'Undefined'}',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontFamily: "Consolas",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'MISSING DATE\nMISSING FROM\nAGE:\nSEX:\nRACE:\nHAIR COLOR:\nEYE COLOR:\nHEIGHT:\nWEIGHT:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Consolas'),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            Text(
                              "${DateFormat.yMMMd().format(_missingPerson?.missingDate)}\n${_missingPerson?.missingFrom ?? 'Undefined'}\n${_missingPerson?.age ?? 'Undefined'}\n${_missingPerson?.sex ?? 'Undefined'}\n${_missingPerson?.race ?? 'Undefined'}\n${_missingPerson?.hairColor ?? 'Undefined'}\n${_missingPerson?.eyeColor ?? 'Undefined'}\n${_missingPerson?.height ?? 'Undefined'}\n${_missingPerson?.weight ?? 'Undefined'}lbs",
                              style: TextStyle(fontFamily: 'Consolas'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
