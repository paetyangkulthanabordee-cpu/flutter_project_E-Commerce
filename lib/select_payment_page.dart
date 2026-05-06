import 'package:flutter/material.dart';
import 'confirm_payment_page.dart';

class SelectPaymentPage extends StatelessWidget {
  final double totalAmount;
  const SelectPaymentPage({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("เลือกช่องทางการชำระเงิน"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: Colors.blue[50],
            child: Column(
              children: [
                const Text("ยอดชำระทั้งหมด", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                  "${totalAmount.toStringAsFixed(2)} บาท",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("เลือกช่องทางชำระเงิน", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          // รายการวิธีการชำระเงินตามภาพ image_0addc0.png
          paymentMethodItem(Icons.local_shipping, "เก็บเงินปลายทาง", context),
          paymentMethodItem(Icons.account_balance, "ธนาคาร", context),
          paymentMethodItem(Icons.qr_code_scanner, "สแกนคิวอาร์โค้ด", context),
        ],
      ),
    );
  }

  Widget paymentMethodItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmPaymentPage(
              totalAmount: totalAmount,
              paymentMethod: title,
            ),
          ),
        );
      },
    );
  }
}