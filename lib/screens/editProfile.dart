import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/editProfileWidgets.dart';
import '../functions/editProfileFunctions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  DateTime? _birthday;
  File? _imageFile;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedProfileData(
      nameController: _nameController,
      emailController: _emailController,
      phoneController: _phoneController,
      addressController: _addressController,
      onGenderLoaded: (g) => setState(() => _gender = g),
      onBirthdayLoaded: (b) => setState(() => _birthday = b),
      onImageLoaded: (img) => setState(() => _imageFile = img),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return buildEditProfileBody(
            context: ctx,
            formKey: _formKey,
            nameController: _nameController,
            emailController: _emailController,
            phoneController: _phoneController,
            addressController: _addressController,
            gender: _gender,
            birthday: _birthday,
            imageFile: _imageFile,
            onGenderChanged: (g) => setState(() => _gender = g),
            onBirthdayChanged: (b) => setState(() => _birthday = b),
            onImageChanged: (img) => setState(() => _imageFile = img),
          );
        },
      ),
    );
  }
}
