import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

const String baseUrl =
    "http://127.0.0.1/flutter_project_E-Commerce/php_api/";

class EditRoomPage extends StatefulWidget {
  final dynamic product;

  const EditRoomPage({super.key, required this.product});

  @override
  State<EditRoomPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditRoomPage> {

  late TextEditingController nameController;
  late TextEditingController capacityController;
  late TextEditingController locationController;
  late TextEditingController priceController;

  XFile? selectedImage;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.product['room_name']?.toString());

    capacityController =
        TextEditingController(text: widget.product['capacity']?.toString());

    locationController =
        TextEditingController(text: widget.product['location']?.toString());

    priceController =
        TextEditingController(text: widget.product['price']?.toString());
  }

  ////////////////////////////////////////////////////////////
  // ✅ PICK IMAGE
  ////////////////////////////////////////////////////////////

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ UPDATE PRODUCT + IMAGE
  ////////////////////////////////////////////////////////////

  Future<void> updateProduct() async {
    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${baseUrl}update_room_with_image.php"),
      );

      ////////////////////////////////////////////////////////
      // ✅ Fields
      ////////////////////////////////////////////////////////

      request.fields['id'] = widget.product['id'].toString();
      request.fields['room_name'] = nameController.text;
      request.fields['capacity'] = capacityController.text;
      request.fields['location'] = locationController.text;
      request.fields['price'] = priceController.text;
      request.fields['old_image'] = widget.product['image'];

      ////////////////////////////////////////////////////////
      // ✅ Image (ถ้ามี)
      ////////////////////////////////////////////////////////

      if (selectedImage != null) {

        if (kIsWeb) {

          final bytes = await selectedImage!.readAsBytes();

          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: selectedImage!.name,
            ),
          );

        } else {

          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              selectedImage!.path,
            ),
          );
        }
      }

      ////////////////////////////////////////////////////////
      // ✅ Send
      ////////////////////////////////////////////////////////

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      final data = json.decode(responseData);

      if (data["success"] == true) {

        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("แก้ไขเรียบร้อย")),
        );
      }

    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  ////////////////////////////////////////////////////////////
  // ✅ UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    String imageUrl =
        "${baseUrl}images/${widget.product['image']}";

    return Scaffold(
      appBar: AppBar(title: const Text("แก้ไขสินค้า")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: SingleChildScrollView(
          child: Column(
            children: [

              //////////////////////////////////////////////////
              // 🖼 IMAGE PREVIEW
              //////////////////////////////////////////////////

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: selectedImage == null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : kIsWeb
                          ? Image.network(
                              selectedImage!.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "ชื่อสินค้า"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: "จำนวนสินค้า"),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "รายละเอียดสินค้า"),
              ),

              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "ราคาสินค้า"),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateProduct,
                  child: const Text("บันทึก"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}