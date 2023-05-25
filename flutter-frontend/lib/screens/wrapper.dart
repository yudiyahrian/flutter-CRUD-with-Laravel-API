import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_frontend/services/auth_provider.dart';
import 'package:flutter_frontend/screens/authenticate/login.dart';
import 'package:flutter_frontend/screens/admin/home.dart';
import 'package:flutter_frontend/screens/student/home.dart';
import 'package:flutter_frontend/screens/teacher/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLogin = false;
  int levelId = 0;

  @override
  void initState() {
    super.initState();
    initializeLoginState();
  }

  Future<void> initializeLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final checkLogin = prefs.getBool('isLogin') ?? false;
    final checkLevelId = prefs.getInt('level_id') ?? 0;

    setState(() {
      isLogin = checkLogin;
      levelId = checkLevelId;
    });
    if(context.mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateAuthStatus(isLogin, levelId);
    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isLoggedIn) {
      return Login();
    } else{
      switch (authProvider.levelId) {
        case 1:
          return const AdminHome();
        case 2:
          return const StudentHome();
        case 3:
          return const TeacherHome();
        default:
          return const CircularProgressIndicator(); // Handle any other cases or show loading indicator
      }
    }
  }
}