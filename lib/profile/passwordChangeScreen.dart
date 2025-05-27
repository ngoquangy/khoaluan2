import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:learn_megnagmet/profile/setting.dart'; // Import EditScreen

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hasPassword = false;
  bool isLoading = true;
  bool isSubmitting = false;

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _checkHasPassword();
  }

  Future<void> _checkHasPassword() async {
    try {
      final userId = int.parse(token.userId);
      final result = await AuthServices.checkHasPassword(userId);
      setState(() {
        hasPassword = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Lỗi', 'Không thể kiểm tra mật khẩu: $e');
    }
  }

  Future<void> _handleChangePassword() async {
    setState(() {
      oldPasswordError = null;
      newPasswordError = null;
      confirmPasswordError = null;
    });

    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    bool valid = true;
    if (hasPassword) {
      if (oldPassword.isEmpty) {
        oldPasswordError = 'Vui lòng nhập mật khẩu cũ';
        valid = false;
      } else if (oldPassword.length < 6) {
        oldPasswordError = 'Mật khẩu cũ phải có ít nhất 6 ký tự';
        valid = false;
      }
    }
    if (newPassword.isEmpty) {
      newPasswordError = 'Vui lòng nhập mật khẩu mới';
      valid = false;
    } else if (newPassword.length < 6) {
      newPasswordError = 'Mật khẩu mới phải có ít nhất 6 ký tự';
      valid = false;
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Vui lòng xác nhận mật khẩu mới';
      valid = false;
    } else if (confirmPassword != newPassword) {
      confirmPasswordError = 'Mật khẩu xác nhận không khớp';
      valid = false;
    }

    if (!valid) {
      setState(() {});
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final userId = int.parse(token.userId);
      final response = await AuthServices().updatePassword(
        userId: userId,
        oldPassword: hasPassword ? oldPassword : null,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
      );
      setState(() => isSubmitting = false);
      if (response['success'] == true) {
        Get.snackbar('Thành công', response['message']);
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        // Quay về EditScreen nếu lưu thành công
        Get.off(() => SettingsPage());
      } else {
        Get.snackbar('Lỗi', response['message'] ?? 'Lỗi không xác định');
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi Mật Khẩu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(top: 30.h),
                        children: [
                          if (hasPassword) ...[
                            _buildPasswordField(
                              controller: oldPasswordController,
                              label: 'Mật khẩu cũ',
                              isObscured: !oldPasswordVisible,
                              onToggle: () => setState(() => oldPasswordVisible = !oldPasswordVisible),
                            ),
                            if (oldPasswordError != null) ...[
                              SizedBox(height: 4.h),
                              Text(oldPasswordError!, style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                            ],
                            SizedBox(height: 20.h),
                          ],
                          _buildPasswordField(
                            controller: newPasswordController,
                            label: 'Mật khẩu mới',
                            isObscured: !newPasswordVisible,
                            onToggle: () => setState(() => newPasswordVisible = !newPasswordVisible),
                          ),
                          if (newPasswordError != null) ...[
                            SizedBox(height: 4.h),
                            Text(newPasswordError!, style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                          ],
                          SizedBox(height: 20.h),
                          _buildPasswordField(
                            controller: confirmPasswordController,
                            label: 'Nhập lại mật khẩu mới',
                            isObscured: !confirmPasswordVisible,
                            onToggle: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                          ),
                          if (confirmPasswordError != null) ...[
                            SizedBox(height: 4.h),
                            Text(confirmPasswordError!, style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.h, top: 15.h),
                      child: _buildSaveButton(),
                    ),
                  ],
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
        child: TextField(
          controller: controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
            prefixIcon: const Icon(Icons.lock, color: Color(0XFF23408F)),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            ),
            hintText: label,
            border: InputBorder.none,
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

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: isSubmitting ? null : _handleChangePassword,
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: isSubmitting ? Colors.grey : const Color(0XFF23408F),
        ),
        child: Center(
          child: isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Lưu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
