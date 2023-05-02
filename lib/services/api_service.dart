import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  static Future<Map<String, dynamic>> get(String url,
      [ Map<String, dynamic>? queryParams]) async {
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    final Map<String, dynamic> responseJson = json.decode(response.body);
    return responseJson;
  }
}