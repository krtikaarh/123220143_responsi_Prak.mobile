import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  void savePhone() async {
    final phone = Phone(id: 0, name: nameController.text, image: '', price: int.parse(priceController.text));
    await ApiService.createPhone(phone);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: priceController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            SizedBox(height: 16),
            ElevatedButton(onPressed: savePhone, child: Text('Simpan')),
          ],
        ),
      ),
    );
  }
}