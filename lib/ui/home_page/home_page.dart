import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/location_service.dart';
import 'package:ifrauser/services/missing_person_service.dart';
import 'package:ifrauser/ui/home_page/missing_persons/missing_person_list.dart';
import 'package:ifrauser/ui/home_page/missing_persons/no_missing_persons.dart';
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
  List<MissingPerson> _missingPersonList = [];
  List<MissingPerson> _filteredMissingPersonList = [];
  int _popupMenuValue = 0;
  String _userDistrict;

  _fetchAllMissingPersonDetails() async {
    await MissingPersonService.fetchAllMissingPersonDetails()
        .then((missingPersonList) {
      // TODO: Use builder for desktop
//      for (int i = 0; i < 200; i++) {
//        _filteredMissingPersonList.add(missingPersonList[0]);
//        _missingPersonList.add(missingPersonList[0]);
//      }
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
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.15),
        child: HomeTitle(height: height),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FilterList(
              onSelected: (selectedValue) {
                setState(() {
                  _popupMenuValue = selectedValue;
                  _fetchFilteredData(selectedValue);
                });
              },
              menuValue: _popupMenuValue,
              userDistrict: _userDistrict,
            ),
            _isFetching
                ? LoadingBuilder(height: height)
                : (_filteredMissingPersonList.isEmpty)
                    ? NoMissingPersons(height: height)
                    : Flexible(
                        child: MissingPersonsList(
                            height: height,
                            width: width,
                            filteredMissingPersonList:
                                _filteredMissingPersonList,
                            diagonalRatio: diagonalRatio),
                      )
          ],
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

class FilterList extends StatefulWidget {
  const FilterList({
    Key key,
    @required this.menuValue,
    @required this.userDistrict,
    @required this.onSelected,
  }) : super(key: key);

  final int menuValue;
  final String userDistrict;
  final Function onSelected;

  @override
  _FilterListState createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  bool _isOptionsVisible = false;
  @override
  Widget build(BuildContext context) {
    return ScreenUtility.isDesktop(context)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                (widget.menuValue == 0)
                    ? "All"
                    : (widget.menuValue == 1)
                        ? "Past 7 days"
                        : "${widget.userDistrict ?? ''}",
                style: TextStyle(color: Colors.white),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                initialValue: widget.menuValue,
                onSelected: widget.onSelected,
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
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isOptionsVisible = !_isOptionsVisible;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        (widget.menuValue == 0)
                            ? "All"
                            : (widget.menuValue == 1) ? "Recent" : "Nearby",
                        style: TextStyle(
                            color: kPrimaryColor, fontFamily: "Consolas"),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: kPrimaryColor,
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isOptionsVisible,
                child: Container(
                  color: Color(0xFF262626),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: <Widget>[
                        buildMenuOptions(
                            context: context, title: 'All', index: 0),
                        buildMenuOptions(
                            context: context, title: 'Recent', index: 1),
                        buildMenuOptions(
                            context: context, title: 'Nearby', index: 2),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: (widget.menuValue == 1) || (widget.menuValue == 2),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, left: 16),
                  child: Text(
                    (widget.menuValue == 1)
                        ? "Past 7 days"
                        : "${widget.userDistrict ?? ''}",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          );
  }

  GestureDetector buildMenuOptions(
      {BuildContext context, String title, int index}) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(index);
        setState(() {
          _isOptionsVisible = !_isOptionsVisible;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color:
                (widget.menuValue == index) ? Colors.white : Color(0xFF4A4A4A),
          ),
        ),
      ),
    );
  }
}
