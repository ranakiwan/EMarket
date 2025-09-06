import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

Future<void> saveFirstFiveProducts(List<dynamic> products) async {
  final prefs = await SharedPreferences.getInstance();
  List<dynamic> firstFive = products.take(5).toList();
  List<String> jsonList = firstFive.map((p) => jsonEncode(p)).toList();
  await prefs.setStringList('first_five_products', jsonList);
}

Future<List<dynamic>> getFirstFiveProducts() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('first_five_products');

  if (jsonList != null) {
    // Decode each JSON string into dynamic (usually Map<String, dynamic>)
    return jsonList.map((jsonStr) => jsonDecode(jsonStr)).toList();
  }

  return [];
}

Future<void> printFirstFiveProducts() async {
  List<dynamic> products = await getFirstFiveProducts();
  for (var product in products) {
    print(product);
  }
}