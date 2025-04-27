import 'dart:convert'; // Đảm bảo import thư viện json
// import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/home/home_main.dart';
import 'package:learn_megnagmet/login/forgot_password.dart';
import 'package:learn_megnagmet/login/sign_up/sign_up_empty_screen.dart';
import 'package:learn_megnagmet/utils/shared_pref.dart';
import 'package:learn_megnagmet/Services/auth_services.dart'; // Import AuthServices

import '../utils/screen_size.dart';
import 'package:learn_megnagmet/Services/token.dart'
    as token; // Import token.dart

class EmptyState extends StatefulWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool ispassHiden = true;

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Expanded(
                  flex: 1,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          "Đăng Nhập",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            fontFamily: 'Gilroy',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: Text(
                          "Glad to meet you again!",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF000000),
                              fontSize: 15.sp,
                              fontFamily: 'Gilroy',
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      email_password_form(),
                      SizedBox(height: 21.h),
                      forgotpassword(),
                      SizedBox(height: 40.h),
                      loginbutton(),
                      SizedBox(height: 40.h),
                      or_sign_in_with_text(),
                      SizedBox(height: 41.h),
                      login_google(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: sign_up(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  toggle() {
    setState(() {
      ispassHiden = !ispassHiden;
    });
  }

  Widget forgotpassword() {
    return GestureDetector(
      onTap: () {
        Get.to(const ForgotPassword());
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          "Forgot password?",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Color(0XFF23408F),
          ),
        ),
      ),
    );
  }

  Widget loginbutton() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (formkey.currentState!.validate()) {
            String email = emailController.text;
            String password = passwordController.text;

            // Gọi phương thức đăng nhập
            var response = await AuthServices.login(email, password);
            Map responseMap = jsonDecode(response.body);

            // Kiểm tra mã trạng thái
            if (response.statusCode == 200) {
              // Giải mã JSON
              token.userId = responseMap['user']['id'].toString();
              token.userName =
                  responseMap['user']['full_name']; // Lưu tên người dùng
              token.userEmail =
                  responseMap['user']['email']; // Lưu email người dùng
              token.userPhone =
                  responseMap['user']['phone']; // Lưu số điện thoại
              token.userAvatar =
                  responseMap['user']['photo'] ?? ''; // Lưu URL ảnh đại diện

              PrefData.setLogin(true);
              Get.to(const HomeMainScreen());
            } else {
              // Hiển thị thông báo lỗi nếu đăng nhập không thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đăng nhập thất bại: ${response.body}")),
              );
            }
          }
        },
        child: Container(
          height: 56.h,
          width: 374.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF23408F),
          ),
          child: Center(
            child: Text("Đăng Nhập",
                style: TextStyle(
                    color: Color(0XFFFFFFFF),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy')),
          ),
        ),
      ),
    );
  }

  Widget login_google() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/google.png")),
            SizedBox(width: 10.w),
            Text(
              "Login with Google",
              style: TextStyle(
                  // color: Color(0XFF000000),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget sign_up() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already have an account?',
          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodyMedium!
                .color, // 👈 màu tự đổi theo theme
            fontSize: 15.sp,
            fontFamily: 'Gilroy',
          ),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(const SignInEmptyScreen());
                },
              text: ' Sign up',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                  color: Theme.of(context).textTheme.bodyMedium!.color
                  // 👈 màu nổi bật theo theme
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget or_sign_in_with_text() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 0.h,
            thickness: 2,
            indent: 20,
            endIndent: 0,
            color: const Color(0XFFDEDEDE),
          ),
        ),
        GestureDetector(
          child: Text("OR Sign in with",
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Gilroy',
                  fontStyle: FontStyle.normal)),
        ),
        Expanded(
          child: Divider(
            height: 0.h,
            thickness: 2,
            indent: 20,
            endIndent: 0,
            color: const Color(0XFFDEDEDE),
          ),
        )
      ],
    );
  }

  Widget email_password_form() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700),
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                contentPadding:
                    EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h)),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter the email';
              } else {
                if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                    .hasMatch(val)) {
                  return 'Please enter valid email address';
                }
              }
              return null;
            },
          ),
          SizedBox(height: 15.h),
          TextFormField(
            controller: passwordController,
            obscureText: ispassHiden,
            decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0XFF23408F), width: 1.w),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                contentPadding:
                    EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                suffixIcon: GestureDetector(
                  onTap: () => toggle(),
                  child: Image(
                    image: ispassHiden
                        ? const AssetImage("assets/notvisible_eye.png")
                        : const AssetImage("assets/visible_eye.png"),
                    height: 20.h,
                    width: 20.w,
                  ),
                )),
            validator: (val) {
              if (val!.isEmpty) {
                return 'Enter the password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
