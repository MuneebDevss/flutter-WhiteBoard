import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage()
async {
  final ImagePicker picker=ImagePicker();
  XFile? file=await picker.pickImage(source: ImageSource.gallery);
  if(file==null) {
    return null;
  }
  File files=File(file.path);
  return files;
}