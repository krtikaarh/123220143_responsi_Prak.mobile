import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';

class ApiService {
  static const String baseUrl = 'https://resp-api-three.vercel.app';

  static Future<List<Phone>> getPhones() async {
    final response = await http.get(Uri.parse('$baseUrl/phones'));
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded.map((json) => Phone.fromJson(json)).toList();
    } else if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .map((json) => Phone.fromJson(json))
          .toList();
    } else {
      throw Exception("Format data tidak dikenali: ${response.body}");
    }
  }

  static Future<Phone> getPhoneById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/phone/$id'));
    return Phone.fromJson(jsonDecode(response.body));
  }

  static Future<void> createPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone.toJson()),
    );

    print('POST Response Code: ${response.statusCode}');
    print('POST Response Body: ${response.body}');

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal membuat phone: ${response.body}');
    }
  }

  static Future<void> updatePhone(int id, Phone phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phone/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengedit phone: ${response.body}');
    }
  }

  static Future<void> deletePhone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/phone/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data');
    }
  }
}
