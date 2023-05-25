import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_frontend/services/api.dart';

class AuthController {

  static Future<bool> login(String email, String password) async {

    final response = await http.post(Uri.parse('$baseUrl/auth/login'),
      body: {
      'email': email,
      'password': password,
      }
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token']; // Retrieve the token from the response
      final levelId = data['level_id']; // Retrieve the level ID from the response

      // Store the token and level ID using shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('level_id', levelId);
      await prefs.setBool('isLogin', true);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept' : 'application/json'
      },
    );

    if (response.statusCode == 200) {
      // Clear the token and other data from shared_preferences
      await prefs.remove('token');
      await prefs.remove('isLogin');
      await prefs.remove('level_id');
      return true;
    } else {
      return false;
    }
  }


}