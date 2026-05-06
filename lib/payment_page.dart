import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final String userName;
  const PaymentPage({super.key, required this.userName});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List bookingItems = [];
  bool isLoading = true;
  double totalAmount = 0.0;
  String selectedMethod = ""; 

  final String baseUrl = "http://127.0.0.1/flutter_project_E-Commerce/php_api/";

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}get_bookings.php"),
        body: {"user_name": widget.userName},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          double sum = 0;
          for (var item in data) {
            sum += double.tryParse(item['price'].toString()) ?? 0;
          }
          setState(() {
            bookingItems = data;
            totalAmount = sum;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Fetch error: $e");
    }
  }

  // ฟังก์ชันยืนยันและแสดงหน้าขอบคุณ
  Future<void> confirmPayment() async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}clear_bookings.php"),
        body: {
          "user_name": widget.userName,
          "payment_method": selectedMethod,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == "success") {
          setState(() {
            bookingItems = [];
            totalAmount = 0;
          });
          
          Navigator.pop(context); // ปิด BottomSheet
          showSuccessDialog(); // เรียกหน้าขอบคุณ
        }
      }
    } catch (e) {
      debugPrint("Confirm error: $e");
    }
  }

  // หน้าขอบคุณการสั่งซื้อ (Success Dialog)
  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("ขอบคุณสำหรับการสั่งซื้อ!", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("ระบบได้รับคำสั่งซื้อของคุณเรียบร้อยแล้ว\nรูปแบบการชำระเงิน: $selectedMethod"),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // ปิด Dialog
                  Navigator.pop(context); // กลับไปหน้าแรก
                },
                child: const Text("กลับสู่หน้าหลัก"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("เลือกรูปแบบการชำระเงิน", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  _buildOption(setModalState, "เก็บเงินปลายทาง", Icons.local_shipping),
                  _buildOption(setModalState, "ธนาคาร", Icons.account_balance),
                  _buildOption(setModalState, "สแกนคิวอาร์โค้ด", Icons.qr_code_scanner),

                  const Divider(height: 40),
                  
                  // แสดงรูปแบบที่เลือกไว้ (ตามที่คุณต้องการ)
                  if (selectedMethod.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("คุณเลือก: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(selectedMethod, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedMethod.isEmpty ? null : confirmPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("ยืนยันคำสั่งซื้อ", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOption(StateSetter setModalState, String title, IconData icon) {
    return Card(
      elevation: 0,
      color: selectedMethod == title ? Colors.blue.withOpacity(0.05) : Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: selectedMethod == title ? Colors.blue : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        secondary: Icon(icon, color: selectedMethod == title ? Colors.blue : Colors.grey),
        value: title,
        groupValue: selectedMethod,
        onChanged: (value) {
          setModalState(() {
            selectedMethod = value.toString();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายการที่ต้องชำระเงิน")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: bookingItems.isEmpty
                      ? const Center(child: Text("ไม่มีรายการที่ต้องชำระ"))
                      : ListView.builder(
                          itemCount: bookingItems.length,
                          itemBuilder: (context, index) {
                            final item = bookingItems[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: ListTile(
                                leading: const Icon(Icons.shopping_bag, color: Colors.purple),
                                title: Text(item['room_name'] ?? ""),
                                subtitle: Text("ราคา: ${item['price']} บาท"),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ทั้งหมด ${bookingItems.length} รายการ"),
                          Text("รวม: ${totalAmount.toStringAsFixed(2)} บาท", 
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: bookingItems.isEmpty ? null : showPaymentSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("ชำระเงินสินค้าทั้งหมด"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}