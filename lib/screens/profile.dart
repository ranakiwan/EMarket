import 'dart:io';
import 'package:flutter/material.dart';
import 'editProfile.dart';

import '../functions/profileFunctions.dart' as pf;
import '../widgets/profileWidgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String name = "Guest";

  @override
  void initState() {
    super.initState();
    _loadProfileData(); 
  }

  
  Future<void> _loadProfileData() async {
    await pf.loadProfileData(
      onName: (newName) => setState(() => name = newName),
      onImageFile: (file) => setState(() => _imageFile = file),
    );
  }

  
  Future<void> loadName() async {
    await pf.loadName(
      onName: (newName) => setState(() => name = newName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildProfileBody(
        context: context,
        imageFile: _imageFile,
        name: name,
      ),
    );
  }
}
