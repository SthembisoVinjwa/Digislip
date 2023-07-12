import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Map<String, dynamic>> pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    String path = _file.path;
    List<String> parts = path.split('/');
    String secondLast = parts[parts.length - 2];
    String last = parts[parts.length - 1];
    Uint8List imageBytes = await _file.readAsBytes();
    return {'filename': '$secondLast/$last', 'image': imageBytes};
  } else {
    return {};
  }
}