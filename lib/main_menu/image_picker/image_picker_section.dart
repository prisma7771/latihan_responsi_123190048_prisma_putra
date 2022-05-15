import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latihan_responsi_123190048/helper/hive_database.dart';
import 'package:latihan_responsi_123190048/helper/shared_preference.dart';
import '../../common_submit_button.dart';
import 'image_picker_helper.dart';

class ImagePickerSection extends StatefulWidget {
  final String username;
  final String image;
  final String password;
  final String history;
  const ImagePickerSection(
      {Key? key,
      required this.username,
      required this.image,
      required this.password,
      required this.history})
      : super(key: key);

  @override
  _ImagePickerSectionState createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  late final HiveDatabase _hive = HiveDatabase();
  String imagePath = "";

  @override
  initState() {
    super.initState();
    setState(() {
      widget.image.isEmpty ? imagePath = "" : imagePath = widget.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 90.0),
          child: _imageSection(),
        ),
        _buttonSectionGallery(),
        _buttonSectionCamera(),
      ],
    );
  }

  Widget _buttonSectionCamera() {
    return CommonSubmitButton(
        labelButton: "Import Dari Camera",
        submitCallback: (value) {
          imagePath = '';
          ImagePickerHelper()
              .getImageFromCamera((value) => _processImage(value));
        });
  }

  Widget _buttonSectionGallery() {
    return CommonSubmitButton(
        labelButton: "Import Dari Gallery",
        submitCallback: (value) {
          imagePath = '';
          ImagePickerHelper()
              .getImageFromGallery((value) => _processImage(value));
        });
  }

  Widget _imageSection() {
    if (imagePath.isEmpty) {
      return const CircleAvatar(
        radius: 100.0,
        child: Center(child: Text("NO PHOTO")),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 100,
      child: CircleAvatar(
        radius: 95,
        backgroundImage: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ).image,
      ),
    );
  }

  void _processImage(String? value) async {
    String saved = await SharedPreference.getImage();
    if (value != null) {
      setState(() {
        if (imagePath == "") {
          imagePath = value;
        }
        debugPrint(imagePath);
        SharedPreference().setImage(imagePath);
        _hive.updateImage(
            widget.username, widget.password, widget.history, imagePath);
      });
    } else {
      setState(() {
        imagePath = saved;
      });
    }
  }
}
