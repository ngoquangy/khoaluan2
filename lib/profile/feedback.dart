import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/home/home_main.dart';
import '../utils/screen_size.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/feedback.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  double _rating = 3;
  String? _comments;
  int? userId; // Thêm userId ở đây

  @override
  void initState() {
    super.initState();
    userId = int.tryParse(token.userId);
    if (userId == null || userId! < 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Lỗi', 'User ID không hợp lệ!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 24.h),
          onPressed: Get.back,
        ),
        title: const Text('Gửi Phản Hồi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text("Đánh giá của bạn về ứng dụng!",
                      style: TextStyle(
                          fontSize: 18.sp,
                          // color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 16.h),
                  ratingbar(),
                  SizedBox(height: 40.h),
                  Text("Gửi phản hồi của bạn cho chúng tôi!",
                      style: TextStyle(
                          fontSize: 15.sp,
                          // color: Colors.black,
                          fontFamily: 'Gilroy')),
                  SizedBox(height: 20.h),
                  TextFormField(
                    maxLines: 5,
                    onChanged: (value) {
                      _comments = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                          borderSide:
                              BorderSide(color: Color(0XFF23408F), width: 1.w)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 1.5)),
                      hintText: 'Viết phản hồi của bạn...',
                      hintStyle:
                          TextStyle(color: Color(0XFF6E758A), fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            submit_button(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget ratingbar() => RatingBar(
        initialRating: _rating,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemSize: 42,
        glow: false,
        ratingWidget: RatingWidget(
          full: Icon(Icons.star, color: Colors.amber),
          half: Icon(Icons.star_border, color: Colors.amber),
          empty: Icon(Icons.star_border, color: Colors.amber),
        ),
        itemPadding: EdgeInsets.symmetric(horizontal: 6),
        onRatingUpdate: (rating) {
          setState(() {
            _rating = rating;
          });
        },
      );

  Widget submit_button() => GestureDetector(
        onTap: () async {
          if (userId == null || userId! < 1) {
            Get.snackbar('Lỗi', 'User ID không hợp lệ!');
            return;
          }
          if (_comments == null || _comments!.isEmpty) {
            Get.snackbar('Lỗi', 'Vui lòng nhập nhận xét của bạn.');
            return;
          }

          FeedbackModel feedback = FeedbackModel(
            userId: userId!,
            rating: _rating.toInt(),
            comments: _comments!,
          );

          final response = await AuthServices.createFeedBack(feedback);

          if (response.statusCode == 201) {
            Get.off(HomeMainScreen());
            print('Feedback submitted successfully!');
          } else {
            print('Failed to submit feedback: ${response.body}');
          }
        },
        child: Container(
          height: 56.h,
          width: 374.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0XFF23408F),
          ),
          child: Center(
            child: Text("Gửi Phản Hồi",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy')),
          ),
        ),
      );
}
