import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/error_page/error_page.dart';
import 'package:ifrauser/ui/sighting_details_page/sighting_details_page.dart';
import 'package:ifrauser/ui/info_page/info_page_desktop/info_page_desktop.dart';
import 'package:ifrauser/ui/info_page/info_page_mobile/info_page_mobile.dart';
import 'package:ifrauser/ui/widgets/custom_fab.dart';
import 'package:ifrauser/ui/widgets/title.dart';
import 'package:ifrauser/utility/screen_utility.dart';

class InfoPage extends StatefulWidget {
  final int issueNumber;
  final MissingPerson missingPerson;
  InfoPage({this.issueNumber, this.missingPerson});
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool _isFetching = true;
  double height;
  double width;
  double diagonalRatio;
  MissingPerson _missingPerson;

  _fetchMissingPersonDetails() async {
    print("Issue number is ${widget.issueNumber}");
    if (widget.missingPerson != null) {
      _missingPerson = widget.missingPerson;
      setState(() {
        _isFetching = false;
      });
    } else {
      await MissingPersonService.fetchMissingPersonDetails(widget.issueNumber)
          .then((missingPerson) {
        _missingPerson = missingPerson;
        setState(() {
          _isFetching = false;
        });
      });
    }
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
      floatingActionButton:
          (ScreenUtility.isDesktop(context) || (_missingPerson == null))
              ? null
              : CustomFAB(
                  backgroundColor: Colors.black,
                  textColor: kPrimaryColor,
                  buttonTitle: 'REPORT SIGHTING',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsPage()),
                    );
                  },
                  borderRadius: BorderRadius.zero,
                ),
      body: _isFetching
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kPrimaryColor),
              ),
            )
          : (_missingPerson == null)
              ? ErrorPage()
              : Column(
                  children: <Widget>[
                    HomeTitle(height: height),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ScreenUtility.isDesktop(context)
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
