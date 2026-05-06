import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingDetailPage extends StatefulWidget {
  final String bookingId; // รับ ID ของรายการสั่งซื้อมาเพื่อไปดึงข้อมูลต่อ
  const BookingDetailPage({super.key, required this.bookingId});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  Map<String, dynamic>? bookingData;
  final String baseUrl = "http://127.0.0.1/flutter_project_E-Commerce/php_api/";

  @override
  void initState() {
    super.initState();
    fetchBookingDetail();
  }

  // ดึงข้อมูลรายละเอียดการสั่งซื้อจาก DB
  Future<void> fetchBookingDetail() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_booking_detail.php?id=${widget.bookingId}")
      );

      if (response.statusCode == 200) {
        setState(() {
          bookingData = json.decode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียดคำสั่งซื้อ")),
      body: bookingData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // แสดงรูปสินค้า
                  Center(
                    child: Image.network(
                      "${baseUrl}images/${bookingData!['image']}",
                      height: 200,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 100),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("สินค้า: ${bookingData!['room_name']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Text("จำนวนที่สั่ง: ${bookingData!['qty']} ชิ้น"),
                  Text("ราคารวม: ${bookingData!['price']} บาท"),
                  Text("ชื่อผู้สั่งซื้อ: ${bookingData!['user_name']}"),
                  Text("วันที่สั่งซื้อ: ${bookingData!['booking_date']}"),
                ],
              ),
            ),
    );
  }
}