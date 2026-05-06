import 'package:flutter/material.dart';
import 'package:flutter_booking/home_page.dart';
import 'room_list.dart'; // ตรวจสอบชื่อไฟล์หน้า Roomlist ของคุณให้ถูกต้อง

class ThanksPage extends StatelessWidget {
  const ThanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ไอคอนเครื่องหมายถูกสีเขียวตามรูปภาพ
            const Icon(Icons.check_circle, size: 100, color: Color(0xFF4CAF50)),
            const SizedBox(height: 30),
            const Text(
              "ขอบคุณที่ใช้บริการ!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              "คำสั่งซื้อของคุณได้รับการยืนยันแล้ว\nเราจะดำเนินการจัดส่งให้เร็วที่สุด",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // ปุ่มกลับสู่หน้าหลักที่เปลี่ยนให้ไปหน้า Roomlist
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3), // สีฟ้าตามรูป
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // ใช้ pushAndRemoveUntil เพื่อล้างหน้าจอเก่าและไปหน้า Roomlist
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(), // เรียกชื่อ Class หน้า Homepage
                    ),
                    (route) => false, // ล้าง Stack หน้าจอทั้งหมด
                  );
                },
                child: const Text(
                  "กลับสู่หน้าหลัก",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}