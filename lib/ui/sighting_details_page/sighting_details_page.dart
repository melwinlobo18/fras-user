import 'package:bot_toast/bot_toast.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:ifrauser/models/missing_person/missing_person.dart';
import 'package:ifrauser/services/image_service.dart';
import 'package:ifrauser/services/location_service.dart';
import 'package:ifrauser/ui/widgets/custom_fab.dart';
import 'package:ifrauser/ui/widgets/title.dart';
import 'package:ifrauser/ui/sighting_details_page/image_list/image_list.dart';
import 'package:ifrauser/ui/widgets/alert.dart';
import 'package:ifrauser/ui/widgets/custom_text_field.dart';
import 'package:ifrauser/ui/widgets/radio_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:typed_data';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SightingDetailsPage extends StatefulWidget {
  final MissingPerson missingPerson;
  SightingDetailsPage({this.missingPerson});
  @override
  _SightingDetailsPageState createState() => _SightingDetailsPageState();
}

class _SightingDetailsPageState extends State<SightingDetailsPage> {
  String name = '';
  String error;
  List<Uint8List> _imagesList = [];
  List<html.File> _images = [];
  List<String> _downloadUrlList = [];
  int _selectedRadioValue = 2;
  double height;
  double width;
  double diagonalRatio;
  int i = 0;
  final List<String> _radioValueText = ['Yes', 'No', 'Not Sure'];
  bool _isUploading = false;
  bool _isSubmitPressed = false;
  bool _isPersonDescriptionVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _personDescriptionController =
      TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _personDescriptionFocusNode = FocusNode();
  fb.RemoteConfig rc;

  final CollectionReference ref = fb.firestore().collection('sightings');

  @override
  void initState() {
    super.initState();
    initFirebaseConfig();
    LocationService.fetchLocationFromGps(
        locationController: _locationController);
  }

  initFirebaseConfig() {
    try {
      rc = fb.remoteConfig();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _personDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    diagonalRatio = sqrt((width * width) + (height * height));
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: AbsorbPointer(
        absorbing: _isUploading,
        child: Scaffold(
          backgroundColor: Color(0xFF222222),
          appBar: PreferredSize(
            preferredSize: Size(width, height * 0.15),
            child: HomeTitle(height: height),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CustomFAB(
              backgroundColor: _isUploading ? Color(0xFF9DFFD2) : kPrimaryColor,
              buttonTitle: _isUploading ? 'Reporting...' : 'REPORT SIGHTING',
              onPressed: _validate,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Add Images',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Consolas",
                        ),
                      ),
                    ),
                    if (_isSubmitPressed && _imagesList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Please select atleast one image',
                          style: TextStyle(
                            color: kBittersweet,
                            fontSize: 12,
                            fontFamily: "Consolas",
                          ),
                        ),
                      ),
                    ImageList(
                      images: _images,
                      imagesList: _imagesList,
                      isUploading: _isUploading,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Text(
                      'Where did you see him/her?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Consolas",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Please provide the precise location of the sighting.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: "Consolas",
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CustomTextField(
                            textInputType: TextInputType.multiline,
                            inputBorder: OutlineInputBorder(),
                            maxLines: 2,
                            validator: (address) {
                              if (address.isEmpty)
                                return 'Please enter an address';
                              else
                                return null;
                            },
                            hintText: 'Eg. Mangalore, Karnataka',
                            controller: _locationController,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: kPrimaryColor,
                          ),
                          onPressed: () => LocationService.fetchLocationFromGps(
                              locationController: _locationController),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Text(
                      'Was He/She Alone?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Consolas",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RadioButton(
                          radioText: 'Yes',
                          radioValue: 0,
                          selectedRadioValue: _selectedRadioValue,
                          handleRadioValueChange: _handleRadioValueChange,
                          activeTextColor: (_selectedRadioValue == 0)
                              ? Colors.white
                              : Colors.grey,
                        ),
                        RadioButton(
                          radioText: 'No',
                          radioValue: 1,
                          selectedRadioValue: _selectedRadioValue,
                          handleRadioValueChange: _handleRadioValueChange,
                          activeTextColor: (_selectedRadioValue == 1)
                              ? Colors.white
                              : Colors.grey,
                        ),
                        RadioButton(
                          radioText: 'Not Sure',
                          radioValue: 2,
                          selectedRadioValue: _selectedRadioValue,
                          handleRadioValueChange: _handleRadioValueChange,
                          activeTextColor: (_selectedRadioValue == 2)
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _isPersonDescriptionVisible,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Please provide more details on the accompanying person.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Consolas",
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              textInputType: TextInputType.multiline,
                              inputBorder: OutlineInputBorder(),
                              maxLines: 3,
                              hintText: 'Eg. Height, Skin Tone etc',
                              controller: _personDescriptionController,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'For further info, how should we contact you? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Consolas",
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '(Optional)',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontFamily: "Consolas",
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomTextField(
                      textInputType: TextInputType.text,
                      inputBorder: UnderlineInputBorder(),
                      hintText: 'Eg. 1234567890',
                      controller: _contactController,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validate() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isSubmitPressed = true;
      });
      if (_imagesList.isNotEmpty) {
        setState(() {
          _isUploading = true;
        });
        final currentFocus = FocusScope.of(context);
        if (currentFocus != null) currentFocus.unfocus();
        Future.wait(
          _images.map((image) {
            return ImageService.uploadMultipleImageFile(image, _downloadUrlList,
                imageName: image.name);
          }),
        ).then((_) async {
          LocationService.fetchLocationFromAddress(
                  locationController: _locationController)
              .then((location) async {
            try {
              var map = {
                'images': _downloadUrlList,
                'location': _locationController.text,
                'latitude': location.lat,
                'longitude': location.lng,
                'wasAlone': _radioValueText[_selectedRadioValue],
                'contactDetails': _contactController.text,
                'issueNumber': widget.missingPerson.docId,
                'additionalPersonDescription':
                    _personDescriptionController.text,
                'sightedAt': DateTime.now().toIso8601String()
              };

              Map<String, String> headers = {
                'Content-Type': 'application/json'
              };
              final data = jsonEncode(map);

              rc.ensureInitialized().then((_) {
                rc.fetchAndActivate().then((_) {
                  http
                      .post(
                        rc.getString('face_recognition_server'),
                        headers: headers,
                        body: data,
                      )
                      .then((value) => print(value.body));
                });
              });

              await ref.add(map).then((value) {
                setState(() {
                  _isUploading = false;
                  _images.clear();
                  _imagesList.clear();
                  _downloadUrlList.clear();
                  _locationController.clear();
                  _personDescriptionController.clear();
                  _selectedRadioValue = 2;
                  _contactController.clear();
                  _isSubmitPressed = false;
                  LocationService.fetchLocationFromGps(
                      locationController: _locationController);
                });
                StatusAlert.showStatusAlert(
                    context: context,
                    alertType: AlertType.success,
                    title: "Reported Successfully!",
                    description: "The sighting has been reported.");
              });
            } catch (e) {
              print(e);
              setState(() {
                _isUploading = false;
              });
              StatusAlert.showStatusAlert(
                  context: context,
                  alertType: AlertType.error,
                  title: "Failed!",
                  description:
                      "Unable to report the sighting. Please try again");
            }
          });
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _handleRadioValueChange(int selectedValue) {
    setState(() {
      _selectedRadioValue = selectedValue;
      (selectedValue == 1)
          ? _isPersonDescriptionVisible = true
          : _isPersonDescriptionVisible = false;
    });
  }
}
