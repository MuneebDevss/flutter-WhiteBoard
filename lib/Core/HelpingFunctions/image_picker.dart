import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: ImageSource.gallery);
  if (file == null) {
    return null;
  }
  File files = File(file.path);
  return files;
}

// String pickWebImage() {
//   // Create a file input element that allows the user to pick an image
//   html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//   uploadInput.accept = 'image/*'; // Restrict file types to images
//   uploadInput.click(); // Trigger the file picker dialog
//   String imageData='https://miro.medium.com/v2/resize:fit:584/1*T3wJpyMr8mc_cTal7PPBRw.png';
//   // Listen for when the user selects a file
//   uploadInput.onChange.listen((e) {
//     final files = uploadInput.files; // Get the list of selected files
//     if (files != null && files.isNotEmpty) {
//       final file = files[
//           0]; // Select the first file (assuming only one file is selected)
//       final reader =
//           html.FileReader(); // Create a FileReader to read the file content
//       reader
//           .readAsDataUrl(file); // Read the file as a Data URL (base64 encoded)

//       // When the file has been fully read
//       reader.onLoadEnd.listen((e) {
//         // Use the file content (data URL) here
//         imageData = reader.result
//             as String; // The image data as a base64 encoded string
//       });
//     }
//   });
//   return imageData;
// }
Future<String?> pickWebImage() async {
  String? image;
  // Create a file input element
  html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';

  // Trigger the file picker dialog
  uploadInput.click();

  // Await the file selection process
  await uploadInput.onChange.first;

  final files = uploadInput.files;
  if (files != null && files.isNotEmpty) {
    final file = files[0];
    final reader = html.FileReader();

    // Read the file as a data URL asynchronously
    reader.readAsDataUrl(file);
    await reader.onLoadEnd.first;

    image = reader.result as String;
  } else {
    
  }
  return image;
}
