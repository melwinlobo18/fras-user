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
    return Row(
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
                      _missingPerson?.name ?? 'Undefined',
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
                      left: height * 0.03,
                      top: height * 0.05,
                      bottom: height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'MISSING DATE\nMISSING FROM\nAGE:\nSEX:\nRACE:\nHAIR COLOR:\nEYE COLOR:\nHEIGHT:\nWEIGHT:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Consolas',
                                height: 2),
                          ),
                          SizedBox(
                            width: width * 0.1,
                          ),
                          Text(
                            "${DateFormat.yMMMd().format(_missingPerson?.missingDate)}\n${_missingPerson?.missingFrom ?? 'Undefined'}\n${_missingPerson?.age ?? 'Undefined'}\n${_missingPerson?.sex ?? 'Undefined'}\n${_missingPerson?.race ?? 'Undefined'}\n${_missingPerson?.hairColor ?? 'Undefined'}\n${_missingPerson?.eyeColor ?? 'Undefined'}\n${_missingPerson?.height ?? 'Undefined'}\n${_missingPerson?.weight ?? 'Undefined'}lbs",
                            style: TextStyle(fontFamily: 'Consolas', height: 2),
                          ),
                        ],
                      ),
                      FlatButton(
                        child: Text(
                          "REPORT SIGHTING",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Consolas",
                          ),
                        ),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
