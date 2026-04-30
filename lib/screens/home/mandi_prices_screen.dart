import 'package:flutter/material.dart';

class MandiPricesScreen extends StatelessWidget {
  const MandiPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> prices = [
      {'crop': 'Rice', 'price': '₹2,183', 'market': 'Nagaon APMC'},
      {'crop': 'Mustard', 'price': '₹5,450', 'market': 'Nalbari Mandi'},
      {'crop': 'Jute', 'price': '₹4,200', 'market': 'Barpeta Mandi'},
      {'crop': 'Potato', 'price': '₹1,800', 'market': 'Guwahati Mandi'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mandi Prices')),
      body: ListView.builder(
        itemCount: prices.length,
        itemBuilder: (context, index) {
          final item = prices[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.shopping_basket, color: Colors.orange),
              title: Text(item['crop'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['market']),
              trailing: Text(
                item['price'],
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
