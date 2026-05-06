import 'package:flutter/material.dart';
import 'booking_page.dart';

class ProductDetail extends StatelessWidget {
  final Map product;
  final String userName;

  const ProductDetail({super.key, required this.product, required this.userName});

  @override
  Widget build(BuildContext context) {
    // กำหนด URL ของรูปภาพ[cite: 2, 5]
    String baseUrl = "http://127.0.0.1/flutter_project_E-Commerce/php_api/";
    String imageUrl = "${baseUrl}images/${product['image'] ?? ''}";

    return Scaffold(
      appBar: AppBar(title: Text(product['room_name'] ?? "รายละเอียด")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['room_name'] ?? "", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("ราคา: ${product['price']} บาท", style: const TextStyle(fontSize: 22, color: Colors.blue)),
                  const Divider(height: 40),
                  const Text("รายละเอียด:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(product['location'] ?? "ไม่มีข้อมูล", style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => BookingPage(room: product, name: userName)));
          },
          child: const Text("สั่งซื้อตอนนี้"),
        ),
      ),
    );
  }
}