import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import '../widgets/phone_card.dart';
import 'create_screen.dart';
import 'detail_screen.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Phone>> phones;
  List<int> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    phones = ApiService.getPhones();
    loadFavorites();
  }

  void refreshData() {
    setState(() {
      phones = ApiService.getPhones();
    });
    loadFavorites(); // Juga refresh favorites
  }

  void loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favString = prefs.getString('favorites');
      if (favString != null) {
        final dynamic decodedData = jsonDecode(favString);
        List<int> favIds = [];
        
        if (decodedData is List) {
          favIds = decodedData.cast<int>();
        }
        
        setState(() {
          favoriteIds = favIds;
        });
      }
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() {
        favoriteIds = [];
      });
    }
  }

  void saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorites', jsonEncode(favoriteIds));
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  void toggleFavorite(int id) {
    setState(() {
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
      } else {
        favoriteIds.add(id);
      }
    });
    saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Phone'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites')
                .then((_) => refreshData()), // Refresh setelah kembali dari favorites
          )
        ],
      ),
      body: FutureBuilder<List<Phone>>(
        future: phones,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final phone = data[index];
                return PhoneCard(
                  phone: phone,
                  isFavorite: favoriteIds.contains(phone.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(phone: phone),
                    ),
                  ).then((_) => refreshData()), // Refresh setelah kembali dari detail
                  onDelete: () async {
                    try {
                      await ApiService.deletePhone(phone.id);
                      refreshData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Phone berhasil dihapus')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menghapus phone')),
                      );
                    }
                  },
                  onFavorite: () => toggleFavorite(phone.id),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreatePage()),
        ).then((_) => refreshData()),
        child: Icon(Icons.add),
      ),
    );
  }
}