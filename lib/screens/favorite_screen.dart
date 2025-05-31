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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? favData = prefs.getString('favorites');
      if (favData != null) {
        // Parse JSON dan pastikan sebagai List
        final dynamic decodedData = jsonDecode(favData);
        List<int> favIds = [];
        
        if (decodedData is List) {
          favIds = decodedData.cast<int>();
        } else if (decodedData is Map) {
          // Jika data adalah Map, ambil values atau keys sesuai struktur
          favIds = [];
        }
        
        final allPhones = await ApiService.getPhones();
        setState(() {
          favorites = allPhones.where((p) => favIds.contains(p.id)).toList();
        });
      }
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() {
        favorites = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Phones')),
      body: favorites.isEmpty 
        ? Center(
            child: Text(
              'Belum ada phone favorit',
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final phone = favorites[index];
              return PhoneCard(
                phone: phone,
                isFavorite: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(phone: phone),
                  ),
                ).then((_) => loadFavorites()), // Refresh setelah kembali
                onFavorite: () {
                  // Hapus dari favorit
                  removeFavorite(phone.id);
                },
                onDelete: null,
              );
            },
          ),
    );
  }

  void removeFavorite(int phoneId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? favData = prefs.getString('favorites');
      if (favData != null) {
        final dynamic decodedData = jsonDecode(favData);
        List<int> favIds = [];
        
        if (decodedData is List) {
          favIds = decodedData.cast<int>();
        }
        
        favIds.remove(phoneId);
        await prefs.setString('favorites', jsonEncode(favIds));
        loadFavorites(); // Refresh tampilan
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }
}