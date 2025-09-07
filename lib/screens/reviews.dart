import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  final List<dynamic> reviews;
  const ReviewPage({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Reviews"),
      ),
      body: Center(
        child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: reviews.map((review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['reviewerName'] ?? 'Anonymous',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: List.generate(
                  review['rating'],
                  (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review['comment'] ?? '',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            review['date'] ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }).toList(),
)
      ),
    );
  }
}
