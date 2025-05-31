import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  final Phone phone;

  const EditPage({Key? key, required this.phone}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.phone.name);
    priceController = TextEditingController(text: widget.phone.price.toString());
  }

  void updatePhone() async {
    final updated = Phone(id: widget.phone.id, name: nameController.text, image: widget.phone.image, price: int.parse(priceController.text));
    await ApiService.updatePhone(widget.phone.id, updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: priceController, decoration: InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number),
            SizedBox(height: 16),
            ElevatedButton(onPressed: updatePhone, child: Text('Perbarui')),
          ],
        ),
      ),
    );
  }
}