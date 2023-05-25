import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  int _levelId = 0;

  bool get isLoggedIn => _isLoggedIn;
  int get levelId => _levelId;

  void updateAuthStatus(bool isLoggedIn, int levelId) {
    _isLoggedIn = isLoggedIn;
    _levelId = levelId;
    notifyListeners();
  }
}