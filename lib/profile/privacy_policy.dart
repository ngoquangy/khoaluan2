import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import '../utils/screen_size.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chính Sách Bảo Mật', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              question('1. Loại dữ liệu chúng tôi thu thập'),
              SizedBox(height: 10.h),
              answer(
                  'Chúng tôi có thể thu thập thông tin như họ tên, email, kết quả bài thi, số lần truy cập... nhằm mục đích cung cấp dịch vụ tốt hơn.'),
              SizedBox(height: 30.h),
              question('2. Việc tiết lộ dữ liệu của bạn'),
              SizedBox(height: 10.h),
              answer(
                  'Dữ liệu cá nhân của bạn sẽ không được chia sẻ với bên thứ ba nếu không có sự đồng ý của bạn, trừ trường hợp pháp luật yêu cầu.'),
              SizedBox(height: 30.h),
              question('3. Sử dụng dữ liệu cá nhân của bạn'),
              SizedBox(height: 10.h),
              answer(
                  'Chúng tôi sử dụng dữ liệu để cải thiện trải nghiệm người dùng, gửi thông báo kết quả, cấp chứng nhận... và đảm bảo tính bảo mật cho tài khoản.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget question(String s) {
    return Text(
      s,
      style: TextStyle(
        fontSize: 18.sp,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w700,
        // color: const Color(0XFF000000),
      ),
    );
  }

  Widget answer(String s) {
    return Text(
      s,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        // color: const Color(0XFF292929),
      ),
    );
  }
}
