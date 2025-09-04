  import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadProfileData({
  required void Function(String) onName,
  required void Function(File?) onImageFile,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final savedName = prefs.getString('name') ?? "Guest";
  onName(savedName);

  final path = prefs.getString('saved_profile_image_path');
  if (path != null) {
    final f = File(path);
    if (f.existsSync()) {
      onImageFile(f);
    }
  }
}

Future<void> loadName({
  required void Function(String) onName,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final storedName = prefs.getString('name');
  if (storedName != null) {
    onName(storedName);
  }
}
