import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'profile/theme_provider.dart'; // Import ThemeProvider
import 'login/login_empty_state.dart'; // Import màn hình đăng nhập

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 47, 44, 44) : const Color(0xFFF5F5F5),
      ),
      home: const EmptyState(), // Màn hình đăng nhập
    );
  }
}