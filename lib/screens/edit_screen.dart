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
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController brandController;
  late TextEditingController specController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.phone.name);
    priceController = TextEditingController(text: widget.phone.price.toString());
    brandController = TextEditingController(text: widget.phone.brand);
    specController = TextEditingController(text: widget.phone.specification);
  }

  Future<void> updatePhone() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updated = Phone(
      id: widget.phone.id,
      name: nameController.text.trim(),
      image: widget.phone.image,
      price: int.tryParse(priceController.text.trim()) ?? 0,
      brand: brandController.text.trim(),
      specification: specController.text.trim(),
    );

    try {
      await ApiService.updatePhone(widget.phone.id, updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone berhasil diperbarui')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui phone: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    brandController.dispose();
    specController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
                validator: (val) => val == null || val.isEmpty ? 'Brand wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Harga wajib diisi';
                  if (int.tryParse(val) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: specController,
                decoration: const InputDecoration(labelText: 'Spesifikasi'),
                validator: (val) => val == null || val.isEmpty ? 'Spesifikasi wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : updatePhone,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text('Perbarui'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
