import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/wrapper.dart';
import 'package:flutter_frontend/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const Wrapper(),
      );
  }
}