import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<void> loadData(Function setState, Function(String, String, File?) update) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedName = prefs.getString('name');
  String? storedMail = prefs.getString('email');
  String? imagePath = prefs.getString('saved_profile_image_path');

  setState(() {
    update(
      storedName ?? "Guest",
      storedMail ?? "",
      (imagePath != null && File(imagePath).existsSync()) ? File(imagePath) : null,
    );
  });
}

Future<void> fetch(Function setState, Function(List<dynamic>) update) async {
  final dio = Dio();
  try {
    final response = await dio.get("https://dummyjson.com/products");
    setState(() {
      update(response.data['products']);
    });
  } catch (e) {
    debugPrint("Error fetching data: $e");
  }
}
