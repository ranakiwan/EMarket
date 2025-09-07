import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';

const _imagePathKey = 'saved_profile_image_path';

Future<void> loadSavedProfileData({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required void Function(String?) onGenderLoaded,
  required void Function(DateTime?) onBirthdayLoaded,
  required void Function(File?) onImageLoaded,
}) async {
  final prefs = await SharedPreferences.getInstance();
  nameController.text = prefs.getString('name') ?? '';
  emailController.text = prefs.getString('email') ?? '';
  phoneController.text = prefs.getString('phone') ?? '';
  addressController.text = prefs.getString('address') ?? '';
  onGenderLoaded(prefs.getString('gender'));
  final birthdayString = prefs.getString('birthday');
  if (birthdayString != null) onBirthdayLoaded(DateTime.tryParse(birthdayString));
  final imagePath = prefs.getString(_imagePathKey);
  if (imagePath != null && await File(imagePath).exists()) onImageLoaded(File(imagePath));
}

Future<DateTime?> pickBirthday(BuildContext context, DateTime initialDate) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
}

Future<void> showImageSourceActionSheet(
  BuildContext context, {
  required File? imageFile,
  required void Function(File?) onImageChanged,
}) async {
  final picker = ImagePicker();

  void pickImage(ImageSource source) async {
    try {
      
      if (source == ImageSource.camera &&
          !await Permission.camera.request().isGranted) return;
      if (source == ImageSource.gallery &&
          !await Permission.photos.request().isGranted) return;

      final XFile? picked = await picker.pickImage(source: source);
      if (picked != null) {
        final cropped = await ImageCropper().cropImage(
          sourcePath: picked.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: 'Crop Image',
              aspectRatioLockEnabled: false,
            ),
          ],
        );

        if (cropped != null) onImageChanged(File(cropped.path));
      }
    } catch (e) {
      print('Image picking/cropping failed: $e');
    }
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
          if (imageFile != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                if (await imageFile.exists()) await imageFile.delete();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove(_imagePathKey);
                onImageChanged(null);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile image removed')));
              },
            ),
        ],
      ),
    ),
  );
}

Widget buildBottomButtons({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required String? gender,
  required DateTime? birthday,
  required File? imageFile,
  required void Function(File?) onImageChanged,
  required void Function(String?) onGenderChanged,
  required void Function(DateTime?) onBirthdayChanged,
}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              await saveProfile(
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
                addressController: addressController,
                gender: gender,
                birthday: birthday,
                imageFile: imageFile,
                onImageChanged: onImageChanged,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved!')),
              );
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              await deleteProfile(
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
                addressController: addressController,
                onGenderChanged: onGenderChanged,
                onBirthdayChanged: onBirthdayChanged,
                onImageChanged: onImageChanged,
                imageFile: imageFile,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile deleted!')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );
}

Future<void> deleteProfile({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required void Function(String?) onGenderChanged,
  required void Function(DateTime?) onBirthdayChanged,
  required void Function(File?) onImageChanged,
  required File? imageFile,
}) async {
  if (imageFile != null && await imageFile.exists()) await imageFile.delete();

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('name');
  await prefs.remove('email');
  await prefs.remove('phone');
  await prefs.remove('address');
  await prefs.remove('gender');
  await prefs.remove('birthday');
  await prefs.remove(_imagePathKey);

  nameController.clear();
  emailController.clear();
  phoneController.clear();
  addressController.clear();
  onGenderChanged(null);
  onBirthdayChanged(null);
  onImageChanged(null);
}

Future<void> saveProfile({
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required String? gender,
  required DateTime? birthday,
  required File? imageFile,
  required void Function(File?) onImageChanged,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', nameController.text.trim());
  await prefs.setString('email', emailController.text.trim());
  await prefs.setString('phone', phoneController.text.trim());
  await prefs.setString('address', addressController.text.trim());
  if (gender != null) await prefs.setString('gender', gender);
  if (birthday != null) await prefs.setString('birthday', birthday.toIso8601String());
  if (imageFile != null && await imageFile.exists()) {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    final localImage = await imageFile.copy('${dir.path}/$fileName');
    await prefs.setString(_imagePathKey, localImage.path);
    onImageChanged(localImage);
  }
}
