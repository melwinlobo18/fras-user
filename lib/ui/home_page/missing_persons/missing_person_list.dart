import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/ui/info_page/info_page.dart';
import 'package:ifrauser/utility/screen_utility.dart';

class MissingPersonsList extends StatelessWidget {
  const MissingPersonsList({
    Key key,
    @required this.height,
    @required this.width,
    @required List<MissingPerson> filteredMissingPersonList,
    @required this.diagonalRatio,
  })  : _filteredMissingPersonList = filteredMissingPersonList,
        super(key: key);

  final double height;
  final double width;
  final List<MissingPerson> _filteredMissingPersonList;
  final double diagonalRatio;

  @override
  Widget build(BuildContext context) {
    return ScreenUtility.isDesktop(context)
        ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: height * 0.04,
                spacing: width * 0.02,
                children: _filteredMissingPersonList.map((missingPerson) {
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
                                  image: NetworkImage(missingPerson.imageUrl),
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
                          missingPerson.missingFrom.split(',')[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList()),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _filteredMissingPersonList.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoPage(
                        missingPerson: _filteredMissingPersonList[index],
                      ),
                    ),
                  );
                },
                leading: Image(
                  image:
                      NetworkImage(_filteredMissingPersonList[index].imageUrl),
                ),
                title: Text(
                  _filteredMissingPersonList[index]?.name?.toUpperCase() ?? '',
                  style: TextStyle(color: kPrimaryColor, fontSize: 16),
                ),
                subtitle: Text(
                  _filteredMissingPersonList[index]
                          ?.missingFrom
                          ?.split(',')[0] ??
                      '',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: kPrimaryColor,
                  size: 16,
                ),
              );
            },
          );
  }
}
