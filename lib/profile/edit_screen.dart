import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/controller.dart';
import '../Services/token.dart' as token;
import '../Services/auth_services.dart';
import '../profile/setting.dart'; // Import SettingsPage
import 'package:learn_megnagmet/Services/urlimage.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final EditScreenController editScreenController =
      Get.put(EditScreenController());

  final TextEditingController _nameController =
      TextEditingController(text: token.userName);
  final TextEditingController _emailController =
      TextEditingController(text: token.userEmail);
  final TextEditingController _phoneController =
      TextEditingController(text: token.userPhone);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chỉnh Sửa Hồ Sơ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Expanded(child: _buildForm()),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ListView(
      children: [
        SizedBox(height: 60.h),
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey[300],
                backgroundImage: token.userAvatar.isNotEmpty
                    ? NetworkImage('$urlImage${token.userAvatar}')
                    : AssetImage("assets/9187604.png") as ImageProvider,
              ),
              Positioned(
                bottom: 3.h,
                right: 3.w,
                child: GestureDetector(
                  onTap: _onAddImage,
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFF23408F),
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 18.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 60.h),
        _buildTextField(Icons.person, _nameController, "Họ và tên"),
        SizedBox(height: 20.h),
        _buildTextField(Icons.email, _emailController, "Email"),
        // SizedBox(height: 20.h),
        // _buildTextField(Icons.phone, _phoneController, "Số điện thoại"),
      ],
    );
  }

  Widget _buildTextField(
      IconData icon, TextEditingController controller, String hintText) {
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
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
            prefixIcon: Icon(icon, color: Color(0XFF23408F)),
            hintText: hintText,
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
      onTap: _updateProfile,
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h, top: 15.h),
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0XFF23408F),
          ),
          child: Center(
            child: Text(
              "Lưu",
              style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onAddImage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Get.snackbar('Thông báo', 'Đang cập nhật ảnh...');

        try {
          var response = await AuthServices.updatePhoto(token.userId, image);

          if (response.statusCode == 200) {
            setState(() {
              token.userAvatar = jsonDecode(response.body)['photo_url'];
            });
            Get.snackbar('Thành công', 'Ảnh đại diện đã được cập nhật!');
          } else {
            Get.snackbar('Lỗi', 'Không thể cập nhật ảnh: ${response.body}');
          }
        } catch (e) {
          Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
        }
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      var response = await AuthServices.updateProfile(
        token.userId,
        _nameController.text,
        _emailController.text,
        // _phoneController.text,
      );

      if (response.statusCode == 200) {
        token.userName = _nameController.text;
        token.userEmail = _emailController.text;
        token.userPhone = _phoneController.text;

        Get.snackbar('Thành công', 'Đã cập nhật hồ sơ thành công');
        // Quay về SettingsPage nếu lưu thành công
        Get.off(() => SettingsPage());
      } else {
        Get.snackbar('Lỗi', 'Không thể cập nhật hồ sơ: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
    }
  }
}
