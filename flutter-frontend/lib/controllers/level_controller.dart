import 'dart:convert';
import 'package:flutter_frontend/models/level.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:http/http.dart' as http;

class LevelController {

  static Future<List<LevelModel>> getLevel() async {

    final headers = await getHeaders();

    final response = await http.get(
        Uri.parse('$baseUrl/level'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      final List<LevelModel> levels = responseData.map((json) => LevelModel.fromJson(json)).toList();
      return levels;
    } else {
      throw Exception('Failed to fetch levels');
    }
  }
}
