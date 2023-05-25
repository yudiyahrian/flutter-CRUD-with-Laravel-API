import 'dart:convert';
import 'dart:io';
import 'package:flutter_frontend/models/user.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:http/http.dart' as http;

class UserController {

  static Future<List<UserModel>> getUsers() async {

    final headers = await getHeaders();

    final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      final List<UserModel> users = responseData.map((json) => UserModel.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<UserModel> getUserById(int id) async {

    final headers = await getHeaders();

    final response = await http.get(
        Uri.parse('$baseUrl/user/$id'),
        headers: headers
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      final UserModel user = UserModel.fromJson(data);
      return user;
    } else {
      throw Exception('Failed to fetch user');
    }
  }


  static Future<UserModel> createUser(UserModel user, File? imageFile) async {
    final headers = await getHeaders();

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/user'))
      ..headers.addAll(headers)
      ..fields['name'] = user.name!
      ..fields['email'] = user.email!
      ..fields['password'] = user.password!
      ..fields['level_id'] = user.levelId.toString();

    if (imageFile != null) {
      var image = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(image);
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      final UserModel createdUser = UserModel.fromJson(data);
      return createdUser;
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<UserModel> updateUser(UserModel user, File? imageFile) async {
    final headers = await getHeaders();

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/user/${user.id}'))
      ..headers.addAll(headers)
      ..fields['_method'] = 'PUT'
      ..fields['name'] = user.name!
      ..fields['email'] = user.email!
      ..fields['password'] = user.password!
      ..fields['level_id'] = user.levelId.toString();

    if (imageFile != null) {
      var image = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(image);
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final UserModel updatedUser = UserModel.fromJson(data);
      return updatedUser;
    } else {
      throw Exception('Failed to update user');
    }
  }


  static Future<void> deleteUser(int id) async {

    final headers = await getHeaders();

    final response = await http.delete(
        Uri.parse('$baseUrl/user/$id'),
      headers: headers
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
