import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/location_service.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/home_page/missing_persons/missing_person_list.dart';
import 'package:ifrauser/ui/home_page/missing_persons/no_missing_persons.dart';
import 'package:ifrauser/ui/widgets/title.dart';

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
  List<MissingPerson> _filteredMissingPersonList;
  int _popupMenuValue = 0;
  String _userDistrict;

  _fetchAllMissingPersonDetails() async {
    await MissingPersonService.fetchAllMissingPersonDetails()
        .then((missingPersonList) {
      _missingPersonList = missingPersonList;
      _filteredMissingPersonList = missingPersonList;
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HomeTitle(height: height),
              FilterList(
                onSelected: (selectedValue) {
                  setState(() {
                    _popupMenuValue = selectedValue;
                    _fetchFilteredData(selectedValue);
                  });
                },
                popupMenuValue: _popupMenuValue,
                userDistrict: _userDistrict,
              ),
              _isFetching
                  ? LoadingBuilder(height: height)
                  : (_filteredMissingPersonList.isEmpty)
                      ? NoMissingPersons(height: height)
                      : MissingPersonsList(
                          height: height,
                          width: width,
                          filteredMissingPersonList: _filteredMissingPersonList,
                          diagonalRatio: diagonalRatio)
            ],
          ),
        ),
      ),
    );
  }

  _fetchFilteredData(int selectedValue) {
    switch (selectedValue) {
      case 0:
        setState(() {
          _filteredMissingPersonList = _missingPersonList;
        });
        break;
      case 1:
        setState(() {
          _filteredMissingPersonList = _missingPersonList
              .where((missingPerson) =>
                  DateTime.now().difference(missingPerson.missingDate).inDays <=
                  7)
              .toList();
        });
        break;
      case 2:
        setState(() {
          _isFetching = true;
        });
        LocationService.fetchLocationFromGps().then((district) {
          setState(() {
            _userDistrict = district ?? "All";
            print(_userDistrict);
            _filteredMissingPersonList = _missingPersonList
                .where(
                    (missingPerson) => missingPerson.district == district ?? "")
                .toList();
            _isFetching = false;
          });
        });
        break;
    }
  }
}

class LoadingBuilder extends StatelessWidget {
  const LoadingBuilder({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.6,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(kPrimaryColor),
        ),
      ),
    );
  }
}

class FilterList extends StatelessWidget {
  const FilterList({
    Key key,
    @required this.popupMenuValue,
    @required this.userDistrict,
    @required this.onSelected,
  }) : super(key: key);

  final int popupMenuValue;
  final String userDistrict;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          (popupMenuValue == 0)
              ? "All"
              : (popupMenuValue == 1) ? "Past 7 days" : "${userDistrict ?? ''}",
          style: TextStyle(color: Colors.white),
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.filter_list,
            color: Colors.white,
          ),
          initialValue: popupMenuValue,
          onSelected: onSelected,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('All'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('Recent'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Nearby'),
                value: 2,
              )
            ];
          },
        )
      ],
    );
  }
}
