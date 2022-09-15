import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BankTransferService with ChangeNotifier {
  var pickedImage;
  final ImagePicker _picker = ImagePicker();
  Future pickImage(BuildContext context) async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }
}
