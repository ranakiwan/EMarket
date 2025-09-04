import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/editProfile.dart';

Widget buildProfileBody({
  required BuildContext context,
  required File? imageFile,
  required String name,
}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue[100],
            backgroundImage: imageFile != null ? FileImage(imageFile) : null,
            child: imageFile == null
                ? const Icon(Icons.person, size: 60, color: Colors.blue)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 32),

        
        buildProfileTile(
          context,
          icon: Icons.person,
          title: 'My Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        
        buildProfileTile(
          context,
          icon: Icons.location_on,
          title: 'My Address',
          onTap: () {},
        ),
        const SizedBox(height: 16),

        
        buildProfileTile(
          context,
          icon: Icons.credit_card,
          title: 'My Card',
          onTap: () {},
        ),
        const SizedBox(height: 16),

        
        buildProfileTile(
          context,
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {},
        ),
        const Spacer(),

        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black26),
              ),
            ),
            onPressed: () {
              
            },
            child: const Text('Logout'),
          ),
        ),
      ],
    ),
  );
}

Widget buildProfileTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    ),
  );
}
