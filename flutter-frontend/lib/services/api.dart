import 'package:shared_preferences/shared_preferences.dart';


// if using emulator don't forget to make laravel php artisan serve --host 0.0.0.0 and APP_URL on .env to ip address
const baseUrl = 'http://192.168.1.6:8000/api';

// const baseUrl = 'http://127.0.0.1:8000/api';

Future<Map<String, String>> getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  return {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}