import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<void> fetchData(Function(List<dynamic>) onSuccess) async {
  final dio = Dio();
  try {
    final response = await dio.get("https://dummyjson.com/products");
    onSuccess(response.data['products']);
  } catch (e) {
    print("Error fetching data: $e");
  }
}
