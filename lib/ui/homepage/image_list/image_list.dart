import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'dart:math';

class ImageList extends StatefulWidget {
  final List<Uint8List> imagesList;
  final List<html.File> images;
  final bool isUploading;

  ImageList({this.images, this.imagesList, this.isUploading});
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  String name = '';
  String error;
  double height;
  double width;
  double diagonalRatio;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    diagonalRatio = sqrt((width * width) + (height * height));
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Wrap(
        children: <Widget>[
          ...getImagesList(),
          if (widget.imagesList.length < 3)
            Padding(
              padding: EdgeInsets.only(left: 5, top: 10),
              child: InkWell(
                onTap: getImage,
                child: Container(
                  height: diagonalRatio * 0.1,
                  width: diagonalRatio * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: kPrimaryColor, width: 2),
                  ),
                  child: Icon(
                    Icons.add,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future getImage() async {
    if (kIsWeb) {
      final html.InputElement input = html.document.createElement('input');
      input
        ..type = 'file'
        ..accept = 'image/*';

      input.onChange.listen((e) {
        if (input.files.isEmpty) return;
        final reader = html.FileReader();
        reader.readAsDataUrl(input.files[0]);
        reader.onError.listen((err) => setState(() {
              error = err.toString();
            }));
        reader.onLoad.first.then((res) {
          final encoded = reader.result as String;
          final stripped =
              encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

          setState(() {
            widget.images.add(input.files[0]);
            name = input.files[0].name;
            widget.imagesList.add(base64.decode(stripped));
            error = null;
          });
        });
      });
      input.click();
    } else {
      await ImagePicker.pickImage(source: ImageSource.camera)
          .then((image) async {
        if (image != null) {
          setState(() {
            widget.imagesList.add(image.readAsBytesSync());
          });
        }
      });
    }
  }

  List<Widget> getImagesList() {
    List<Widget> serviceImageList = [];
    widget.imagesList.forEach((imageFile) {
      serviceImageList.add(Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, right: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: diagonalRatio * 0.1,
                    width: diagonalRatio * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: MemoryImage(imageFile), fit: BoxFit.fill),
                    ),
                  ),
                  if (widget.isUploading)
                    Container(
                      height: diagonalRatio * 0.1,
                      width: diagonalRatio * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      child: Center(
                        child: SizedBox(
                          height: diagonalRatio * 0.02,
                          width: diagonalRatio * 0.02,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    int index = widget.imagesList.indexOf(imageFile);
                    widget.images.removeAt(index);
                    widget.imagesList.remove(imageFile);
                  });
                },
                child: Icon(
                  Icons.cancel,
                  color: kBittersweet,
                  size: diagonalRatio * 0.03,
                ),
              ),
            )
          ],
        ),
      ));
    });
    return serviceImageList;
  }
}
