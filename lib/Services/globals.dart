import 'package:flutter/material.dart';

// const String baseURL = "http://127.0.0.1:8000/api/"; //emulator localhost
// const String baseURL = "http://10.0.2.2:8000/api/"; //emulator localhost
// const String baseURL = "http://192.168.1.68:8000/api/"; //emulator localhost
const String baseURL = "http://192.168.43.135:8000/api/"; //emulator localhost
const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}

