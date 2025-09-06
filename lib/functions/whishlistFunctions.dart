import 'package:beauty_products/functions/homeFunctions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'offlineFunctions.dart';

  const _key = 'wishlist';
Future<List<dynamic>> fetchProducts() async {
  try {
    final response = await Dio().get('https://dummyjson.com/products');
    return response.data['products'];
  } catch (e) {
    print('Error fetching products: $e');
    return [];
  }
}

  // Add an item ID to wishlist
  Future<void> addItem(String productId, BuildContext context) async {
    bool is_added = false;
    print("id to be added: $productId");
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlist = prefs.getStringList(_key) ?? [];
    final List<String> titles = prefs.getStringList("cachedTitles") ?? [] ;
    for (var i = 0; i < wishlist.length; i++) {
      print("item in wishlist: ${wishlist[i]}");
    }
    print("contained? ${wishlist.contains(productId)}");
    if (!wishlist.contains(productId)) {
      wishlist.add(productId);
      List<dynamic> products =  await fetchProducts();
      titles.add(products[int.parse(productId)]['title']);
      print("the title is ${products[int.parse(productId)]['title']}");
      print("here are the titles: $titles");
      is_added = true;
      for (var i = 0; i < wishlist.length; i++) {
      print("item in wishlist: ${wishlist[i]}");
    }
      await prefs.setStringList(_key, wishlist);
      await prefs.setStringList("cachedTitles", titles);
    }
    var message = is_added ? 'Item added to wishlist!' : 'Item already in wishlist!';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }



  Future<int> findIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlist = prefs.getStringList(_key) ?? [];
    return int.parse(wishlist[index]);
  }

  Future<String> findTitle(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> titles = prefs.getStringList("cachedTitles") ?? [];
    return titles[index];
  }

  // Remove an item ID from wishlist
  Future<void> removeItem(String productId) async {
    print("id to be removed: $productId");
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlist = prefs.getStringList(_key) ?? [];
    final List<String> titles = prefs.getStringList("cachedTitles") ?? [];
    for (var i = 0; i < wishlist.length; i++) {
      print("item in wishlist: ${wishlist[i]}");
    }
    print("will be removed: ${wishlist[int.parse(productId)]}");
    wishlist.removeAt(int.parse(productId));
    print("title to be removed: ${titles[int.parse(productId)]}");
    titles.remove(titles[int.parse(productId)]);
    //titles.clear();
    print("new title list: $titles");
    //titles.removeAt(int.parse(productId));
    await prefs.setStringList("cachedTitles", titles);
    for (var i = 0; i < wishlist.length; i++) {
      print("item in wishlist: ${wishlist[i]}");
    }
    await prefs.setStringList(_key, wishlist);
  }

  // Check if an item is in wishlist
  Future<bool> isInWishlist(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> wishlist = prefs.getStringList(_key) ?? [];
    return wishlist.contains(productId);
  }

  // Get all wishlist items
  Future<List<String>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

Future<List<dynamic>> getWishlistTitles() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> i = prefs.getStringList(_key) ?? [];
    List<String> t = prefs.getStringList("cachedTitles") ?? [];
    List<Map<String, dynamic>> wishlist = [];

  // make sure both lists have the same length
  for (int index = 0; index < i.length && index < t.length; index++) {
    wishlist.add({
      "id": int.parse(i[index]),
      "title": t[index],
    });
  }

  return wishlist;
}
  

  Future<List<dynamic>> getWishlistProducts() async {
  final wishlistIds = await getWishlist(); 
  if(await hasInternetConnection()){
final allProducts = await fetchProducts();
  final wishlistProducts = [];
  for (var id in wishlistIds) {
    wishlistProducts.add(allProducts[int.parse(id)]);
  }
  //wishlistProducts = allProducts.where((product) {
  //  return wishlistIds.contains(product['id'].toString());
  //}).toList();
  for (var item in wishlistProducts) {
    print(item['title']);
  }
  return wishlistProducts;
  }
  return getWishlistTitles();

  
}
