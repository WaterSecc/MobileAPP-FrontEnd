import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:watersec_mobileapp_front/classes/category.dart';

class CategoryService {
  final _httpClient = http.Client();
  String urlProd = dotenv.env['URLPRODB2B'] ?? '';
  String categoriesEndpoint = dotenv.env['CATEGORIES'] ?? '';

  // Method to fetch categories from the API
  Future<List<Category>> fetchCategories(String accessToken) async {
    final url = Uri.parse(urlProd + categoriesEndpoint);
    final response = await _httpClient.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}
