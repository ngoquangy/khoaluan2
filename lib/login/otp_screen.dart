import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/reset_password.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import '../utils/screen_size.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isVerifying = false;

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Text(
                  "Nhập Mã OTP",
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
                        "Vui lòng nhập mã OTP đã được gửi đến email ${widget.email}",
                        style: TextStyle(fontSize: 15.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 54.h),
                    _buildOTPField(),
                    SizedBox(height: 30.h),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
            prefixIcon: const Icon(Icons.security, color: Color(0XFF23408F)),
            hintText: "Nhập mã OTP",
            border: InputBorder.none,
            counterText: '',
          ),
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: GestureDetector(
        onTap: isVerifying
            ? null
            : () async {
                if (_otpController.text.isEmpty) {
                  Get.snackbar("Lỗi", "Vui lòng nhập mã OTP");
                  return;
                }

                setState(() => isVerifying = true);
                try {
                  final response = await AuthServices.verifyOTP(
                    widget.email,
                    _otpController.text,
                  );

                  if (response.statusCode == 200) {
                    Get.snackbar("Thành công", "Xác thực OTP thành công!");
                    Get.to(() => ResetPasswordScreen(email: widget.email));
                  } else {
                    Get.snackbar("Lỗi", "Mã OTP không hợp lệ hoặc đã hết hạn");
                  }
                } catch (e) {
                  Get.snackbar("Lỗi", "Đã xảy ra lỗi: $e");
                }
                setState(() => isVerifying = false);
              },
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isVerifying ? Colors.grey : const Color(0XFF23408F),
          ),
          child: Center(
            child: isVerifying
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Xác nhận",
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
}
