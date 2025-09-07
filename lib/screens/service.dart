import 'package:flutter/material.dart';
import '../functions/serviceFunctions.dart';
import '../widgets/serviceWidgets.dart';
import '../functions/whishlistFunctions.dart';
import '../widgets/tagWidget.dart';
import 'reviews.dart';

class ServicePageArguments {}

class ServicePage extends StatefulWidget {
  final int pageIndex;
  const ServicePage({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  bool isChecked = false;
  bool is_added = false;
  List<dynamic> internetData = [];

Future<void> _initializeWishlistState() async {
  String itemId = widget.pageIndex.toString();
  bool exists = await isInWishlist(itemId);
  setState(() {
    is_added = exists;
  });
}

  @override
  void initState(){
    super.initState();
    _initializeWishlistState();
    fetchData((data) {
      setState(() {
        internetData = data;
      });
    });
  }

  Future<bool> checkIfInWishlist(String id) async {
    return await isInWishlist(id);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: internetData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      buildHeaderImage(internetData[widget.pageIndex]['images'][0] ?? '', context),
                      buildDetailsCard(
                        internetData[widget.pageIndex]['title'] ?? 'Service Title',
                        internetData[widget.pageIndex]['price']?.toString() ?? '00',
                        internetData[widget.pageIndex]['rating']?.toString() ?? '0.0',
                      ),
                    ],
                  ),
                  const SizedBox(height: 72),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Product Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            internetData[widget.pageIndex]['description'] ?? 'No description available',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: const TextField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Description',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Tags:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Row(children: [
                            ...internetData[widget.pageIndex]['tags'].map((tag) => TagWidget(label: tag ?? '')).toList(),
                          ],),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Warranty info:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Text(internetData[widget.pageIndex]['warrantyInformation'] ?? 'No warranty information available'),
                              const SizedBox(height: 8),
                              const Text("Shipping info:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Text(internetData[widget.pageIndex]['shippingInformation'] ?? 'No shipping information available'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReviewPage(reviews: internetData[widget.pageIndex]['reviews'] ?? [])),
                              );
                            },
                            child: const Text("Reviews"),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                            ),),
                          Row(
                            children: [
                              StatefulBuilder(
                                builder: (context, setStateCheckbox) {
                                  return Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                  );
                                },
                              ),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(text: 'I have read and agreed to the '),
                                      TextSpan(
                                        text: 'Terms and Conditions',
                                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                      ),
                                      TextSpan(text: ' And '),
                                      TextSpan(
                                        text: 'Privacy Policy.',
                                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(0, -2))],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                
                            const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Text(
                              '\$${internetData[widget.pageIndex]['price']}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                              child: IconButton(
                                icon: Icon(is_added ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                    onPressed: () async {
                                int item_id = widget.pageIndex;
                              print(item_id);
                                addItem(item_id.toString(), context);
                                is_added = await isInWishlist(item_id.toString());
                              setState(() {
                                is_added = is_added;
                              });
                            },
                          ),
                        ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {},
                            child: const Text('Book Now', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
