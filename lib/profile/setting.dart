import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/token.dart' as token;
import '../profile/edit_screen.dart';
import '../profile/my_interface.dart';
import '../profile/privacy_policy.dart';
import '../profile/feedback.dart';
import 'theme_provider.dart';
import '../login/login_empty_state.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cài Đặt', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Thông tin cá nhân"),
            _infoTile(context, "Tài khoản", token.userName, EditScreen()),
            // _infoTile(context, "Đổi mật khẩu", EditScreen()),
            SizedBox(height: 20.h),
            _sectionTitle("Giao diện"),
            _infoTile(context, "Hình nền",
                themeProvider.isDarkMode ? "Tối" : "Sáng", Interface()),
            SizedBox(height: 20.h),
            _sectionTitle("Giới thiệu"),
            _toggleTile(context, "Điều khoản dịch vụ", PrivacyPolicy()),
            _toggleTile(context, "Gửi phản hồi", FeedBack()),
            SizedBox(height: 20.h),
            _logoutTile(context, "Đăng xuất"),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoTile(
      BuildContext context, String title, String value, Widget screen) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: value.isNotEmpty
          ? Text(value, style: TextStyle(color: Colors.grey))
          : null,
      trailing: Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => screen)),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  Widget _toggleTile(BuildContext context, String title, Widget screen) {
    return _infoTile(context, title, "", screen);
  }

  Widget _logoutTile(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(context),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
              color: Color(0xFF23408F),
              borderRadius: BorderRadius.circular(10.r)),
          alignment: Alignment.center,
          child: Text(title,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: Colors.grey.shade300, // Màu viền
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Bạn có muốn đăng xuất?",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),
              Row(
                children: [
                  _dialogButton("Có", Colors.white, Color(0XFF23408F),
                      () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    Get.offAll(EmptyState());
                  }),
                  SizedBox(width: 10.w),
                  _dialogButton("Không", Color(0XFF23408F), Colors.white,
                      () => Get.back()),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// **Nút bấm hộp thoại**
  Widget _dialogButton(
      String title, Color textColor, Color bgColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22.h),
            border: Border.all(color: Colors.grey.shade300, width: 1.5.w),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18.sp, color: textColor),
          ),
        ),
      ),
    );
  }
}
