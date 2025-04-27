import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void setLightMode() {
    _isDarkMode = false;
    notifyListeners();
  }

  void setDarkMode() {
    _isDarkMode = true;
    notifyListeners();
  }

  void setDefaultMode() {
    _isDarkMode = false; // Đặt về chế độ sáng mặc định
    notifyListeners();
  }
}