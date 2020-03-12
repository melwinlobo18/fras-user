import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/ui/homepage/homepage.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: diagonalRatio * 0.2,
          color: kPrimaryColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.03),
                        child: Text(
                          _missingPerson?.name ?? 'Undefined',
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
        ),
        SizedBox(
          height: height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MISSING DATE\nMISSING FROM\nAGE:\nSEX:\nRACE:\nHAIR COLOR:\nEYE COLOR:\nHEIGHT:\nWEIGHT:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Consolas'),
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
    );
  }
}
