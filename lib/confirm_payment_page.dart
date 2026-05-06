import 'package:flutter/material.dart';
import 'thanks_page.dart';

class ConfirmPaymentPage extends StatelessWidget {
  final double totalAmount;
  final String paymentMethod;

  const ConfirmPaymentPage({
    super.key, 
    required this.totalAmount, 
    required this.paymentMethod
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ยืนยันการชำระเงิน"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("สรุปรายละเอียดคำสั่งซื้อ", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _infoCard("ยอดที่ต้องชำระ", "${totalAmount.toStringAsFixed(2)} บาท", isBlue: true),
            _infoCard("วิธีการชำระเงิน", paymentMethod),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const ThanksPage()),
                    (route) => false,
                  );
                },
                child: const Text("ยืนยันคำสั่งซื้อ", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, {bool isBlue = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        trailing: Text(value, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 16,
            color: isBlue ? Colors.blue : Colors.black87
          )),
      ),
    );
  }
}