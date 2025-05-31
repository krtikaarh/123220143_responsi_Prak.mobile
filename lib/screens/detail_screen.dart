import 'package:flutter/material.dart';
import 'package:responsi_143/screens/edit_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int phoneId;

  const DetailPage({Key? key, required this.phoneId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Phone> phone;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    phone = ApiService.getPhoneById(widget.phoneId);
    checkFavorite();
  }

  void checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favString = prefs.getString('favorites');
    if (favString != null) {
      final List<dynamic> favList = jsonDecode(favString);
      setState(() {
        isFavorite = favList.contains(widget.phoneId);
      });
    }
  }

  void toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favString = prefs.getString('favorites');
    List<int> favList = [];
    if (favString != null) {
      favList = List<int>.from(jsonDecode(favString));
    }
    setState(() {
      if (favList.contains(widget.phoneId)) {
        favList.remove(widget.phoneId);
        isFavorite = false;
      } else {
        favList.add(widget.phoneId);
        isFavorite = true;
      }
    });
    await prefs.setString('favorites', jsonEncode(favList));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Phone>(
      future: phone,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final phone = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(phone.name),
              actions: [
                IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: toggleFavorite,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(phone.image),
                  SizedBox(height: 10),
                  Text('Nama: ${phone.name}', style: TextStyle(fontSize: 20)),
                  Text('Harga: Rp ${phone.price}'),
                ],
              ),
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'edit',
                  child: Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPage(phone: phone),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'delete',
                  child: Icon(Icons.delete),
                  onPressed: () async {
                    await ApiService.deletePhone(phone.id);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error loading data')));
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}