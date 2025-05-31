import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';

class ApiService {
  static const String baseUrl = 'https://resp-api-three.vercel.app/phones';

  static Future<List<Phone>> getPhones() async {
    final response = await http.get(Uri.parse(baseUrl));
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Phone.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load phones. Status code: ${response.statusCode}',
      );
    }
  }

  static Future<Phone> getPhoneById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    return Phone.fromJson(jsonDecode(response.body));
  }

  static Future<void> createPhone(Phone phone) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone.toJson()),
    );
  }

  static Future<void> updatePhone(int id, Phone phone) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phone.toJson()),
    );
  }

  static Future<void> deletePhone(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
