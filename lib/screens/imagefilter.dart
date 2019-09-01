import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class PhotoFather extends StatefulWidget {
  final File abc;
  PhotoFather({this.abc});
  @override
  _PhotoFatherState createState() => new _PhotoFatherState();
}

class _PhotoFatherState extends State<PhotoFather> {
  imageLib.Image _image;
  String fileName;

  List<Filter> filters = [
    NoFilter(),
    AdenFilter(),
    CharmesFilter(),
    LoFiFilter(),
    F1977Filter(),
    AddictiveBlueFilter(),
    AdenFilter(),
    AmaroFilter(),
    AshbyFilter(),
    BrannanFilter()
  ];

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future getImage() async {
    // var imageFile = await ImagePicker.pickImage(source: ImageSource.camera,);
    fileName = basename(widget.abc.path);
    var image = imageLib.decodeImage(widget.abc.readAsBytesSync());
    image = imageLib.copyResize(image, height: 150, width: 300);
    // image = imageLib.copyResize(image, 600);
    setState(() {
      _image = image;
    });
  }

  Future getImageFlot() async {
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, height: 150, width: 300);
    // image = imageLib.copyResize(image, 600);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        alignment: Alignment(0.0, 0.0),
        child: _image == null
            ? new Text('No image selected.')
            : new PhotoFilterSelector(
                filters: filters,
                // title: Text("Enjoy with filter"),
                fit: BoxFit.fill,
                image: _image,

                filename: fileName,
                loader: Center(child: CircularProgressIndicator()),
              ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImageFlot,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}
