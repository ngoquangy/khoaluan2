import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../utils/screen_size.dart';
import 'theme_provider.dart';

class Interface extends StatelessWidget {
  const Interface({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Lấy ThemeProvider từ Provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Giao Diện', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Nút Sáng
            GestureDetector(
              onTap: () {
                themeProvider.setLightMode(); // Chuyển sang sáng
              },
              child: Container(
                width: double.infinity,
                height: 50.h,
                color:
                    themeProvider.isDarkMode ? Colors.black : Colors.yellow,
                alignment: Alignment.center,
                child: Text(
                  'Sáng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Nút Tối
            GestureDetector(
              onTap: () {
                themeProvider.setDarkMode(); // Chuyển sang tối
              },
              child: Container(
                width: double.infinity,
                height: 50.h,
                color:
                    themeProvider.isDarkMode ? Colors.yellow : Colors.black,
                alignment: Alignment.center,
                child: Text(
                  'Tối',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color:
                        themeProvider.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
