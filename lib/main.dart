import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/create_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/favorite_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/favorites': (context) => FavoritePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
