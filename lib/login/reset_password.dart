import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/login_empty_state.dart'; // Or wherever your login screen is
import 'package:learn_megnagmet/Services/auth_services.dart';
import '../utils/screen_size.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isResetting = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Center(
                  child: Text(
                    "Đặt Lại Mật Khẩu",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: 'Gilroy',
                      color: Color(0XFF000000),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Nhập một mật khẩu mới cho tài khoản của bạn!",
                          style: TextStyle(
                            color: Color(0XFF000000),
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            _buildPasswordField(
                              controller: _passwordController,
                              label: 'Mật khẩu mới',
                              isObscured: !isPasswordVisible,
                              onToggle: () => setState(
                                  () => isPasswordVisible = !isPasswordVisible),
                            ),
                            SizedBox(height: 20.h),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              label: 'Nhập lại mật khẩu mới',
                              isObscured: !isConfirmPasswordVisible,
                              onToggle: () => setState(() =>
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: _buildOkButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: (val) {
        if (val!.isEmpty) return 'Vui lòng nhập mật khẩu';
        if (val.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
        if (label == 'Nhập lại mật khẩu mới' &&
            val != _passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          fontSize: 15.sp,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0XFF23408F), width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.w),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.w),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        contentPadding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Image(
            image: isObscured
                ? const AssetImage("assets/notvisible_eye.png")
                : const AssetImage("assets/visible_eye.png"),
            height: 20.h,
            width: 20.w,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 15.sp,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: GestureDetector(
        onTap: isResetting
            ? null
            : () async {
                if (formKey.currentState!.validate()) {
                  setState(() => isResetting = true);
                  try {
                    final response = await AuthServices.resetPassword(
                      email: widget.email,
                      password: _passwordController.text.trim(),
                      passwordConfirmation:
                          _confirmPasswordController.text.trim(),
                    );

                    if (response.statusCode == 200) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: const Color(0XFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          actions: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.h),
                                    Image(
                                      image: const AssetImage(
                                          "assets/Privacy2.png"),
                                      height: 88.13.h,
                                      width: 76.33.w,
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      "Thành công!",
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      "Mật khẩu của bạn đã được thay đổi thành công!",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ).then((_) {
                        Future.delayed(const Duration(seconds: 3), () {
                          Get.offAll(const EmptyState());
                        });
                      });
                    } else {
                      Get.snackbar("Lỗi",
                          "Không thể đặt lại mật khẩu: ${response.body}");
                    }
                  } catch (e) {
                    Get.snackbar("Lỗi", "Đã xảy ra lỗi: $e");
                  }
                  setState(() => isResetting = false);
                }
              },
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isResetting ? Colors.grey : const Color(0XFF23408F),
          ),
          child: Center(
            child: isResetting
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Hoàn thành",
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

  Widget _buildOkButton() {
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
}
