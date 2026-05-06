import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import หน้าอื่นๆ ที่เกี่ยวข้องให้ตรงกับชื่อไฟล์ในโปรเจกต์ของคุณ
import 'home_page.dart';
import 'booking_page.dart';
import 'product_detail.dart';
import 'payment_page.dart'; 

class RoomList extends StatefulWidget {
  final String name;
  const RoomList({super.key, required this.name});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  List rooms = [];
  List filteredRooms = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  // กำหนด Base URL สำหรับดึงข้อมูล
  // สำหรับ Android Emulator ใช้ 10.0.2.2
  // สำหรับ iOS Emulator หรือเครื่องจริงที่ต่อวง LAN เดียวกัน ให้ใช้ IP เครื่องคอมพิวเตอร์
  final String baseUrl = "http://127.0.0.1/flutter_project_E-Commerce/php_api/";

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  // ฟังก์ชันดึงข้อมูลสินค้าจากฐานข้อมูล[cite: 2]
  Future<void> fetchRooms() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}get_rooms.php"));
      if (response.statusCode == 200) {
        setState(() {
          rooms = json.decode(response.body);
          filteredRooms = rooms;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching rooms: $e");
    }
  }

  // ฟังก์ชันค้นหาสินค้า
  void searchRoom(String keyword) {
    final results = rooms.where((room) {
      final name = room['room_name'].toString().toLowerCase();
      return name.contains(keyword.toLowerCase());
    }).toList();
    setState(() {
      filteredRooms = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top victories Shop"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Center(
            child: Text(
              "Welcome, ${widget.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),        
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            ),
          ),
        ],
      ),

      // ปุ่มชำระเงินที่มุมขวาล่าง
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentPage(userName: widget.name),
            ),
          );
        },
        label: const Text("ชำระเงิน"),
        icon: const Icon(Icons.payment),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [
          // ช่องค้นหาสินค้า
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "ค้นหาสินค้า...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: searchRoom,
            ),
          ),

          // รายการสินค้า
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRooms.isEmpty
                    ? const Center(child: Text("ไม่พบข้อมูลสินค้า"))
                    : ListView.builder(
                        itemCount: filteredRooms.length,
                        itemBuilder: (context, index) {
                          final room = filteredRooms[index];
                          // จัดการ URL รูปภาพให้ถูกต้อง
                          String imageUrl = "${baseUrl}images/${room['image'] ?? ''}";

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                // กดที่ Card เพื่อดูรายละเอียดสินค้า
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetail(
                                      product: room,
                                      userName: widget.name,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // รูปภาพสินค้า
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        // กรณีโหลดรูปไม่ได้ หรือไม่มีรูป[cite: 2]
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.image, size: 50, color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    // ข้อมูลสินค้า
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room['room_name'] ?? "ไม่มีชื่อสินค้า",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // ใช้ 'qty' หรือ 'capacity' ตามชื่อ Column ใน Database ของคุณ
                                          Text("จำนวนสินค้า: ${room['qty'] ??  0}"),
                                          Text(
                                            "ราคา: ${room['price']} บาท",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ปุ่มสั่งซื้อ
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BookingPage(
                                              room: room,
                                              name: widget.name,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("สั่งซื้อ"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}