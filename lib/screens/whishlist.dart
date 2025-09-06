import 'package:flutter/material.dart';
import '../functions/whishlistFunctions.dart';
import 'service.dart';
import '../functions/homeFunctions.dart';

class WhishlistScreen extends StatefulWidget {
  const WhishlistScreen({Key? key}) : super(key: key);

  @override
  State<WhishlistScreen> createState() => _WhishlistScreenState();
}

class _WhishlistScreenState extends State<WhishlistScreen> {
  late Future<List<dynamic>> wishlistFuture;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    wishlistFuture = getWishlistProducts();
    _initData();
  }

  Future<void> _initData() async {
      bool internet = await hasInternetConnection();
    setState(() {
      hasInternet = internet;
    });
  }


  void refreshWishlist() {
    setState(() {
      wishlistFuture = getWishlistProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Wishlist'),foregroundColor: Colors.black, backgroundColor: Colors.white,),
      body: FutureBuilder<List<dynamic>>(
        future: wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final wishlistItems = snapshot.data ?? [];
            if (wishlistItems.isEmpty) {
              return const Center(child: Text('No items in wishlist'));
            }

            return ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return ListTile(
                  title: Text(item['title'] ?? 'No Title'),
                  onTap: () async {
                    bool internet = await hasInternetConnection();
                    if (internet) {
                      int i = await findIndex(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ServicePage(pageIndex: i)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No internet connection')),
                      );
                    }
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await removeItem(index.toString());
                      refreshWishlist();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
