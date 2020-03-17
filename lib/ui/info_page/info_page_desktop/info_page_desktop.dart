import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/ui/sighting_details_page/sighting_details_page.dart';
import 'package:intl/intl.dart';

class InfoPageDesktop extends StatelessWidget {
  const InfoPageDesktop({
    Key key,
    @required this.diagonalRatio,
    @required MissingPerson missingPerson,
    @required this.width,
    @required this.height,
  })  : _missingPerson = missingPerson,
        super(key: key);

  final double diagonalRatio;
  final MissingPerson _missingPerson;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _dataMap = {
      'MISSING DATE:': DateFormat.yMMMd().format(_missingPerson?.missingDate),
      'MISSING FROM:': _missingPerson?.missingFrom ?? 'Undefined',
      'AGE:': _missingPerson?.age ?? 'Undefined',
      'SEX:': _missingPerson?.sex ?? 'Undefined',
      'RACE:': _missingPerson?.race ?? 'Undefined',
      'HAIR COLOR:': _missingPerson?.hairColor ?? 'Undefined',
      'EYE COLOR:': _missingPerson?.eyeColor ?? 'Undefined',
      'HEIGHT:': _missingPerson?.height ?? 'Undefined',
      'WEIGHT:': _missingPerson?.weight ?? 'Undefined' + 'lbs'
    };
    bool _isFaded = false;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(40),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kPrimaryColor, width: 2),
                image: (_missingPerson?.imageUrl != null)
                    ? DecorationImage(
                        image: NetworkImage(_missingPerson.imageUrl),
                        fit: BoxFit.cover)
                    : null),
            child: (_missingPerson?.imageUrl == null)
                ? Text(
                    "Image Not Available",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  )
                : null,
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(height * 0.03),
                color: kPrimaryColor,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _missingPerson?.name?.toUpperCase() ?? 'Undefined',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Consolas",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      'IFRA ALERT ISSUE NO. ${_missingPerson?.issueNumber ?? 'Undefined'}',
                      style: TextStyle(
                        fontFamily: "Consolas",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.03, bottom: height * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ..._dataMap.entries.map((entry) {
                          _isFaded = !_isFaded;
                          return buildInfoTile(
                              title: entry.key,
                              data: entry.value.toString(),
                              isFadedBackground: _isFaded);
                        }).toList()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildInfoTile({String title, String data, bool isFadedBackground}) {
    return Container(
      color: isFadedBackground ? Color(0xFF262626) : Color(0xFF222222),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 150,
            child: Text(
              title,
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Consolas',
                  height: 2),
            ),
          ),
          Text(
            data.toUpperCase(),
            style: TextStyle(
                fontFamily: 'Consolas', height: 2, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
