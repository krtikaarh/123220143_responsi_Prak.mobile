import 'package:flutter/material.dart';
import 'package:responsi_143/screens/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import '../widgets/phone_card.dart';
import 'dart:convert';


class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Phone> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favData = prefs.getString('favorites');
    if (favData != null) {
      final List favIds = jsonDecode(favData);
      final allPhones = await ApiService.getPhones();
      setState(() {
        favorites = allPhones.where((p) => favIds.contains(p.id)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Phones')),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final phone = favorites[index];
          return PhoneCard(
            phone: phone,
            isFavorite: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(phoneId: phone.id),
              ),
            ),
            onFavorite: () {},
            onDelete: null,
          );
        },
      ),
    );
  }
}
