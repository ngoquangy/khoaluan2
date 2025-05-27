import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: Text('Điều Khoản Dịch Vụ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              question('1. Giới thiệu về ứng dụng'),
              SizedBox(height: 10.h),
              answer('Ứng dụng là nền tảng hỗ trợ học tập và kiểm tra kiến thức qua các bài trắc nghiệm, cung cấp chứng nhận hoàn thành sau khi người dùng đáp ứng yêu cầu nhất định.'),
              SizedBox(height: 30.h),
              question('2. Tài khoản người dùng'),
              SizedBox(height: 10.h),
              answer('Người dùng cần đăng ký tài khoản để sử dụng đầy đủ tính năng của ứng dụng. Bạn cam kết cung cấp thông tin chính xác và bảo mật tài khoản của mình.'),
              SizedBox(height: 30.h),
              question('3. Trách nhiệm người dùng'),
              SizedBox(height: 10.h),
              answer('Bạn không được gian lận, phát tán mã độc hoặc sao chép nội dung trái phép từ ứng dụng. Mỗi cá nhân chỉ được phép tạo một tài khoản duy nhất.'),
              SizedBox(height: 30.h),
              question('4. Nội dung và chứng nhận'),
              SizedBox(height: 10.h),
              answer('Câu hỏi và bài kiểm tra được biên soạn từ đội ngũ chuyên môn. Chứng nhận chỉ được cấp khi bạn hoàn thành bài kiểm tra với kết quả đạt yêu cầu.'),
              SizedBox(height: 30.h),
              question('5. Quyền sở hữu trí tuệ'),
              SizedBox(height: 10.h),
              answer('Toàn bộ nội dung và thiết kế của ứng dụng thuộc quyền sở hữu của nhà phát triển. Không được sao chép hoặc sử dụng lại nếu không được phép.'),
              SizedBox(height: 30.h),
              question('6. Thay đổi điều khoản'),
              SizedBox(height: 10.h),
              answer('Chúng tôi có quyền thay đổi điều khoản bất kỳ lúc nào. Thay đổi sẽ được thông báo và việc tiếp tục sử dụng ứng dụng đồng nghĩa với sự chấp nhận.'),
              SizedBox(height: 30.h),
              question('7. Giới hạn trách nhiệm'),
              SizedBox(height: 10.h),
              answer('Chúng tôi không chịu trách nhiệm với bất kỳ thiệt hại nào do việc sử dụng ứng dụng gây ra. Người dùng chịu trách nhiệm với kết quả học tập của mình.'),
              SizedBox(height: 30.h),
              question('8. Liên hệ'),
              SizedBox(height: 10.h),
              answer('Mọi thắc mắc xin liên hệ:\nEmail: ngoquangy2002@gmail.com\nHotline: 0964523167'),
              SizedBox(height: 30.h),
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
      ),
    );
  }
}
