import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:intl/intl.dart';

class InfoPageMobile extends StatelessWidget {
  const InfoPageMobile({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Container(
                color: kPrimaryColor,
                height: height * 0.2,
              ),
            ),
            Container(
              height: height * 0.25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kPrimaryColor, width: 5),
                          image: (_missingPerson?.imageUrl != null)
                              ? DecorationImage(
                                  image: NetworkImage(_missingPerson.imageUrl),
                                  fit: BoxFit.cover)
                              : null),
                      child: (_missingPerson?.imageUrl == null)
                          ? Text(
                              "Image Not Available",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.03),
                            child: Text(
                              _missingPerson?.name?.toUpperCase() ??
                                  'Undefined',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Consolas",
                              ),
                            ),
                          ),
                          Text(
                            'IFRA ALERT',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Consolas",
                            ),
                          ),
                          Text(
                            'ISSUE NO. ${_missingPerson?.issueNumber ?? 'Undefined'}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Consolas",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: height * 0.05,
        ),
        ..._dataMap.entries.map((entry) {
          _isFaded = !_isFaded;
          return buildInfoTile(
              title: entry.key,
              data: entry.value.toString(),
              isFadedBackground: _isFaded);
        }).toList()
      ],
    );
  }

  Container buildInfoTile({String title, String data, bool isFadedBackground}) {
    return Container(
      color: isFadedBackground ? Color(0xFF262626) : Color(0xFF222222),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Consolas',
                height: 2),
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
