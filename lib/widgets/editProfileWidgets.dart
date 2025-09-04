import 'dart:io';
import 'package:flutter/material.dart';
import '../functions/editProfileFunctions.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    readOnly: readOnly,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}

Widget buildDropdown({
  required String? value,
  required List<String> items,
  required void Function(String?) onChanged,
  String label = 'Gender',
}) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    value: value,
    items: items.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
    onChanged: onChanged,
  );
}

Widget buildProfileAvatar({
  required File? image,
  required VoidCallback onEditTap,
}) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue[100],
        backgroundImage: image != null ? FileImage(image) : null,
        child: image == null ? const Icon(Icons.person, size: 60, color: Colors.blue) : null,
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: onEditTap,
          child: const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.orange,
            child: Icon(Icons.edit, size: 16, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

Widget buildEditProfileBody({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required String? gender,
  required DateTime? birthday,
  required File? imageFile,
  required void Function(String?) onGenderChanged,
  required void Function(DateTime?) onBirthdayChanged,
  required void Function(File?) onImageChanged,
}) {
  return Scaffold(
    resizeToAvoidBottomInset: true, 
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 16),
          buildProfileAvatar(
            image: imageFile,
            onEditTap: () => showImageSourceActionSheet(
              context,
              imageFile: imageFile,
              onImageChanged: onImageChanged,
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: formKey,
            child: Column(
              children: [
                buildTextField(controller: nameController, label: 'Name', keyboardType: TextInputType.name),
                const SizedBox(height: 16),
                buildTextField(controller: emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                buildTextField(controller: phoneController, label: 'Phone number', keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                buildTextField(controller: addressController, label: 'Address', keyboardType: TextInputType.streetAddress),
                const SizedBox(height: 16),
                buildDropdown(value: gender, items: const ['Male', 'Female', 'Other'], onChanged: onGenderChanged),
                const SizedBox(height: 16),
                buildTextField(
                  controller: TextEditingController(
                    text: birthday == null
                        ? ''
                        : "${birthday.year}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
                  ),
                  label: 'Birthday',
                  readOnly: true,
                  onTap: () async {
                    DateTime? picked = await pickBirthday(context, birthday ?? DateTime(2000));
                    onBirthdayChanged(picked);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    
    bottomNavigationBar: buildBottomButtons(
      context: context,
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      addressController: addressController,
      gender: gender,
      birthday: birthday,
      imageFile: imageFile,
      onImageChanged: onImageChanged,
      onGenderChanged: onGenderChanged,
      onBirthdayChanged: onBirthdayChanged,
    ),
  );
}
