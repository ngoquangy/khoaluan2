import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/otp_screen.dart';
import '../utils/screen_size.dart';
import 'login_empty_state.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Text(
                  "Quên Mật Khẩu",
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        "Nhập email bạn đăng ký để nhận mã OTP!",
                        style: TextStyle(fontSize: 15.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 54.h),
                    _EmailField(),
                    SizedBox(height: 30.h),
                    _submitButton(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: _backLoginButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Center(
      child: GestureDetector(
        onTap: isSubmitting
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => isSubmitting = true);
                  final email = _emailController.text.trim();
                  final response = await AuthServices.forgotPassword(email);

                  if (response.statusCode == 200) {
                    Get.snackbar(
                        "Thành công", "Mã OTP đã được gửi đến email của bạn!");
                    Get.to(() => OTPScreen(email: _emailController.text));
                  } else if (response.statusCode == 404) {
                    Get.snackbar(
                        "Thông báo", "Email không tồn tại! Vui lòng thử lại!");
                  } else {
                    Get.snackbar(
                        "Lỗi", "Đã xảy ra lỗi: ${response.statusCode}");
                  }
                  setState(() => isSubmitting = false);
                }
              },
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSubmitting ? Colors.grey : const Color(0XFF23408F),
          ),
          child: Center(
            child: isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Gửi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _backLoginButton() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Quay lại đăng nhập?',
          style: TextStyle(fontSize: 15.sp, color: Colors.black),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.off(const EmptyState()),
              text: ' Đăng nhập',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }

  Widget _EmailField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Gilroy',
                color: const Color(0XFF9B9B9B),
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
            fillColor: const Color(0xFFF5F5F5),
            contentPadding:
                EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h)),
        validator: (val) {
          if (val!.isEmpty) {
            return 'Vui lòng nhập email';
          } else if (!RegExp(r'^.+@[a-zA-Z]+\.[a-zA-Z]+.*$').hasMatch(val)) {
            return 'Email không hợp lệ';
          }
          return null;
        },
      ),
    );
  }
}
