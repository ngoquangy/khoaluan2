import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/reset_password.dart';
import '../utils/screen_size.dart';
import 'login_empty_state.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              SizedBox(height: 16.h),
              _backButton(),
              Center(
                child: Text(
                  "Forgot Password",
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
                        "Enter your registered phone number to reset password.",
                        style: TextStyle(fontSize: 15.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 54.h),
                    _phoneNumberField(),
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
        onTap: () {
          if (_formKey.currentState!.validate()) {
            Get.to(ResetPassword());
          }
        },
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF23408F),
          ),
          child: Center(
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700),
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
          text: 'Back to login?',
          style: TextStyle(fontSize: 15.sp, color: Colors.black),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.off(const EmptyState()),
              text: ' Login',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }

  Widget _phoneNumberField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Phone Number',
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
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Icon(Icons.arrow_back, size: 24.h),
    );
  }
}
