import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Services/token.dart' as token;
import '../profile/edit_screen.dart';
import '../profile/my_interface.dart';
import '../profile/privacy_policy.dart';
import '../profile/feedback.dart';
import '../login/login_empty_state.dart';
import '../profile/passwordChangeScreen.dart';
// import '../profile/my_profile.dart'; // Import MyProfile
import 'theme_provider.dart';
import '../home/home_main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Khi người dùng nhấn back, điều hướng về MyProfile
        Get.off(() => HomeMainScreen());
        return false;
      },
      child: Scaffold(
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
              _infoTile(context, "Tài khoản", token.userName, const EditScreen()),
              _toggleTile(context, "Đổi mật khẩu", const PasswordChangeScreen()),
              _sectionTitle("Giao diện"),
              _infoTile(
                context,
                "Hình nền",
                themeProvider.isDarkMode ? "Tối" : "Sáng",
                const Interface(),
              ),
              _sectionTitle("Giới thiệu"),
              _toggleTile(context, "Điều khoản dịch vụ", const PrivacyPolicy()),
              _toggleTile(context, "Gửi phản hồi", const FeedBack()),
              _logoutTile(context, "Đăng xuất"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoTile(
      BuildContext context, String title, String value, Widget screen) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            value.isNotEmpty ? Text(value, style: TextStyle(color: Colors.grey)) : null,
        trailing: Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _toggleTile(BuildContext context, String title, Widget screen) {
    return _infoTile(context, title, "", screen);
  }

  Widget _logoutTile(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(context),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: Color(0xFF23408F),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
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
                  _dialogButton(
                    "Có",
                    Colors.white,
                    const Color(0XFF23408F),
                    () async {
                      await _clearUserData();
                      await _googleSignOut();
                      Get.offAll(() => const EmptyState());
                    },
                  ),
                  SizedBox(width: 10.w),
                  _dialogButton(
                    "Không",
                    const Color(0XFF23408F),
                    Colors.white,
                    () => Get.back(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token.userId = "";
    token.userName = "";
    token.userEmail = "";
    token.userPhone = "";
    token.userAvatar = "";
  }

  Future<void> _googleSignOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      debugPrint("Google Sign-Out error: \$e");
    }
  }

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
