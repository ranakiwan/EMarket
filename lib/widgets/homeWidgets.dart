import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/service.dart';

Widget buildAppDrawer(BuildContext context, String name, String mail, File? imageFile) {
  return Drawer(
    backgroundColor: Colors.white,
    child: Container(
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue[100],
                backgroundImage: imageFile != null ? FileImage(imageFile) : null,
                child: imageFile == null
                    ? const Icon(Icons.person, size: 32, color: Colors.blue)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? 'Guest' : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mail.isEmpty ? '—' : mail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const ListTile(leading: Icon(Icons.credit_card), title: Text('Payment Method')),
          const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Address')),
          const ListTile(leading: Icon(Icons.notifications_none), title: Text('Notification')),
          const ListTile(leading: Icon(Icons.local_offer_outlined), title: Text('Offers')),
          const ListTile(leading: Icon(Icons.group_outlined), title: Text('Refer a Friend')),
          const ListTile(leading: Icon(Icons.phone_outlined), title: Text('Support')),
        ],
      ),
    ),
  );
}

Widget buildHomeBody({
  required BuildContext context,
  required GlobalKey<ScaffoldState> scaffoldKey,
  required bool isGridView,
  required List<dynamic> internetData,
  required Function(bool) onToggleView,
}) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      children: [
        _buildHeader(scaffoldKey),
        _buildAdBanner(),
        const SizedBox(height: 16),
        _buildProductHeader(isGridView, onToggleView),
        const SizedBox(height: 16),
        Expanded(
          child: isGridView
              ? _buildGridView(context, internetData)
              : _buildListView(context, internetData),
        ),
      ],
    ),
  );
}

Widget _buildHeader(GlobalKey<ScaffoldState> scaffoldKey) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    decoration: BoxDecoration(color: Colors.blue[200]),
    child: Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu),
            ),
            IconButton(
              onPressed: () => debugPrint("Bell button pressed"),
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => debugPrint("Map button pressed"),
              icon: const Icon(Icons.map_rounded),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Deliver to'),
                Text('Select your location'),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildAdBanner() {
  return Stack(
    children: [
      Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      Center(
        child: Image.asset(
          'assets/images/advertisement.jpg',
          width: 250,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

Widget _buildProductHeader(bool isGridView, Function(bool) onToggleView) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          'Our products',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Row(
        children: [
          IconButton(
            tooltip: 'Open menu',
            color: !isGridView ? Colors.amber : Colors.black,
            onPressed: () => onToggleView(false),
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            tooltip: 'Open window view',
            color: isGridView ? Colors.amber : Colors.black,
            onPressed: () => onToggleView(true),
            icon: const Icon(Icons.window),
          ),
        ],
      ),
    ],
  );
}

Widget _buildGridView(BuildContext context, List<dynamic> internetData) {
  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    childAspectRatio: 0.75,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    children: internetData.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServicePage(pageIndex: index)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Image.network(
                product['images'][0] ?? '',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                product['title'] ?? 'No Title',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$${product['price']?.toString() ?? 'No Price'}"),
                  Row(
                    children: [
                      const Icon(Icons.star_rate, color: Colors.yellow, size: 16),
                      Text(product['rating']?.toString() ?? 'No Rating'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildListView(BuildContext context, List<dynamic> internetData) {
  return ListView(
    children: internetData.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServicePage(pageIndex: index)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                product['images'][0] ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("\$${product['price']?.toString() ?? 'No Price'}"),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rate, color: Colors.yellow, size: 16),
                            Text(product['rating']?.toString() ?? 'No Rating'),
                          ],
                        ),
                        Text("${product['discountPercentage'] ?? 'No Offer'}%"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}
