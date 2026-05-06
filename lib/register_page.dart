import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future registerEmployee() async {
    // ตรวจสอบความว่างเปล่า[cite: 4]
    if (userController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณากรอก Username และ Password")));
      return;
    }

    // URL สำหรับ Emulator[cite: 2]
    var url = Uri.parse("http://127.0.0.1/flutter_project_E-Commerce/php_api/register_employee.php");

    try {
      var response = await http.post(url, body: {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "phone": phoneController.text,
        "username": userController.text,
        "password": passController.text,
      });

      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("สมัครสมาชิกสำเร็จ!")));
        Navigator.pop(context); // กลับไปหน้า Login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ผิดพลาด: ${data['message']}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("สมัครสมาชิก")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "ชื่อ")),
              const SizedBox(height: 10),
              TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "นามสกุล")),
              const SizedBox(height: 10),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "เบอร์โทรศัพท์")),
              const SizedBox(height: 10),
              TextField(controller: userController, decoration: const InputDecoration(labelText: "Username")),
              const SizedBox(height: 10),
              TextField(controller: passController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: registerEmployee, child: const Text("ยืนยันการสมัคร")),
            ],
          ),
        ),
      ),
    );
  }
}