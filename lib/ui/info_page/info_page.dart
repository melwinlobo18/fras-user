import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/not_found_page/not_found_page.dart';
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
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.15),
        child: HomeTitle(height: height),
      ),
      floatingActionButtonLocation: ScreenUtility.isDesktop(context)
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          (_missingPerson == null || _missingPerson.childFound)
              ? null
              : Padding(
                  padding: ScreenUtility.isDesktop(context)
                      ? EdgeInsets.only(right: 20, bottom: 50)
                      : EdgeInsets.zero,
                  child: CustomFAB(
                    backgroundColor: Color(0xFF222222),
                    textColor: kPrimaryColor,
                    buttonTitle: 'REPORT SIGHTING',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SightingDetailsPage(
                            missingPerson: _missingPerson,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.zero,
                  ),
                ),
      body: _isFetching
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kPrimaryColor),
              ),
            )
          : (_missingPerson == null || _missingPerson.childFound)
              ? NotFoundPage()
              : Column(
                  children: <Widget>[
                    Expanded(
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
                    )
                  ],
                ),
    );
  }
}
