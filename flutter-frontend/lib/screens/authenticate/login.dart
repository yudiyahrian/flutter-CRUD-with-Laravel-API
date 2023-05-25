import 'package:flutter/material.dart';
import 'package:flutter_frontend/controllers/auth_controller.dart';
import 'package:flutter_frontend/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    void login() async {
      try {
        await AuthController.login(
          _emailController.text,
          _passwordController.text,
        );
          final prefs = await SharedPreferences.getInstance();
          int levelId = prefs.getInt('level_id') ?? 0;
          bool isLogin = prefs.getBool('isLogin') ?? false;

          authProvider.updateAuthStatus(isLogin, levelId);
      } catch (e) {
        // Handle login error
        print(e);
      }
    }

    void checkSharedPreferencesData() async {
      final prefs = await SharedPreferences.getInstance();
      final allData = prefs.getKeys();

      for (String key in allData) {
        var value = prefs.get(key);
        print('Key: $key, Value: $value');
      }
    }

    void clearSharedPreferencesData() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('SharedPreferences data cleared');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
