import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  final Map room;
  final String name;

  const BookingPage({super.key, required this.room, required this.name});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  var nameController = TextEditingController();
  var descController = TextEditingController();
  var priceController = TextEditingController(); // แสดงราคารวม[cite: 1]
  var qtyController = TextEditingController(text: "1"); // ช่องจำนวน
  final startController = TextEditingController();
  final endController = TextEditingController();

  double unitPrice = 0.0;
  double totalPrice = 0.0;

  //เพิ่ม override //
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    descController = TextEditingController(text: widget.room['location']?? "");
    unitPrice = double.tryParse(widget.room['price'].toString()) ?? 0.0;
    totalPrice = unitPrice; 
    priceController.text = totalPrice.toStringAsFixed(2);
  }

  // ฟังก์ชันคำนวณราคาใหม่เมื่อเปลี่ยนจำนวน
  void calculateTotalPrice(String value) {
  // แปลงค่าจากช่องจำนวนเป็นตัวเลข ถ้าว่างหรือพิมพ์ไม่ใช่เลขให้เป็น 0
  int qty = int.tryParse(value) ?? 0; 
  
  setState(() {
    // คำนวณราคาทั้งหมด
    totalPrice = unitPrice * qty; 
    
    // อัปเดตตัวเลขในช่องราคาให้แสดงผลทันที
    priceController.text = totalPrice.toStringAsFixed(2); 
  });
}

  ////////////////////////////////////////////////////////////
  // DATE PICKER
  ////////////////////////////////////////////////////////////

  Future pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // ห้ามเลือกวันที่ย้อนหลัง
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        descController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  ////////////////////////////////////////////////////////////
  // TIME PICKER
  ////////////////////////////////////////////////////////////

  Future pickStartTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        startController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future pickEndTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        endController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  ////////////////////////////////////////////////////////////
  // SAVE BOOKING
  ////////////////////////////////////////////////////////////

  Future saveBooking() async {
    // ตรวจสอบกรอกข้อมูลครบ
    if (nameController.text.isEmpty ||
        descController.text.isEmpty ||
        startController.text.isEmpty ||
        endController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")));
      return;
    }

    // ตรวจสอบเวลาเริ่ม < เวลาสิ้นสุด
    if (startController.text.compareTo(endController.text) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เวลาเริ่มต้องน้อยกว่าเวลาสิ้นสุด")),
      );
      return;
    }

    var url = Uri.parse(
      "http://localhost/flutter_project_E-Commerce/php_api/add_booking.php",
    );

    var response = await http.post(
      url,
      body: {
        "room_id": widget.room['id'].toString(),
        "user_name": nameController.text,
        "booking_date": descController.text,
        "start_time": startController.text,
        "end_time": endController.text,
      },
    );

    var data = jsonDecode(response.body);

    if (data['status'] == "success") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("จองสำเร็จ")));

      Navigator.pop(context);
    } else if (data['status'] == "unavailable") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ห้องไม่ว่าง เวลาชนกัน")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("เกิดข้อผิดพลาด")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////
  // UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    String roomName = widget.room['room_name'] ?? "Meeting Room";
    String roomImage = widget.room['image'] ?? "";

    return Scaffold(
      appBar: AppBar(title: Text("จอง $roomName")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [
              ////////////////////////////////////////////////////////////
              // ROOM IMAGE
              ////////////////////////////////////////////////////////////
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "http://localhost/flutter_project_E-Commerce/php_api/images/$roomImage",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              // ROOM NAME
              ////////////////////////////////////////////////////////////
              Text(
                roomName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////
              // USER NAME
              ////////////////////////////////////////////////////////////
              TextField(
                controller: nameController,
                readOnly: true, //ทำให้อ่านได้อย่างเดียว
                decoration: const InputDecoration(
                  labelText: "ชื่อผู้ซื้อสินค้า",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              // DATE
              ////////////////////////////////////////////////////////////
              TextField(
                controller: descController,
                readOnly: true, //ทำให้อ่านได้อย่างเดียว
                decoration: const InputDecoration(
                  labelText: "รายละเอียดสินค้า",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              // START TIME
              ////////////////////////////////////////////////////////////
              TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                  labelText: "จำนวน",
                  border: OutlineInputBorder(),
                  ),
                   onChanged: (value) {
    // ทุกครั้งที่พิมพ์ ราคาจะถูกคำนวณใหม่ทันทีแบบ Real-time[cite: 2]
                   calculateTotalPrice(value); 
                  },
                ),

                  const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              // END TIME
              ////////////////////////////////////////////////////////////
              TextField(
                controller: priceController,
                readOnly: true, //ทำให้อ่านได้อย่างเดียว
                decoration: const InputDecoration(
                  labelText: "ราคา",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveBooking,
                  child: const Text("บันทึกการสั่งซื้อ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
