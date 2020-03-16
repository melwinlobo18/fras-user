import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/info_page/info_page.dart';
import 'package:ifrauser/ui/widgets/title.dart';
import 'package:ifrauser/utility/screen_utility.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height;
  double width;
  double diagonalRatio;
  bool _isFetching = true;
  List<MissingPerson> _missingPersonList;

  _fetchAllMissingPersonDetails() async {
    await MissingPersonService.fetchAllMissingPersonDetails()
        .then((missingPersonList) {
      _missingPersonList = missingPersonList;
      setState(() {
        _isFetching = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllMissingPersonDetails();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    diagonalRatio = sqrt((width * width) + (height * height));
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HomeTitle(height: height),
            _isFetching
                ? Container(
                    height: height,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: height * 0.04,
                      spacing: width * 0.02,
                      children: _missingPersonList.map((missingPerson) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoPage(
                                  missingPerson: missingPerson,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: ScreenUtility.isMobile(context)
                                    ? diagonalRatio * 0.1
                                    : diagonalRatio * 0.07,
                                width: ScreenUtility.isMobile(context)
                                    ? diagonalRatio * 0.1
                                    : diagonalRatio * 0.07,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            missingPerson.imageUrl),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                missingPerson.name,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                missingPerson.missingFrom,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
