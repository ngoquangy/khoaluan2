import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/My_cources/detail.dart';
import 'package:learn_megnagmet/Services/urlimage.dart';

class RecentAddedList extends StatelessWidget {
  const RecentAddedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HocPhan>>(
      future: AuthServices.fetchHocPhan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return const Center(child: Text('Không có học phần nào.'));
        }

        final latestCourses = data.take(3).toList().reversed.toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: latestCourses
                .map((hocPhan) => Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: _HocPhanCard(hocPhan: hocPhan),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _HocPhanCard extends StatelessWidget {
  final HocPhan hocPhan;

  const _HocPhanCard({required this.hocPhan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => DetailPage(hocPhan: hocPhan)),
      child: Container(
        width: 320.w,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0XFFDEDEDE), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                '$urlImage${hocPhan.photo}',
                width: double.infinity,
                height: 158.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hocPhan.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _stripHtmlTags(hocPhan.content),
                    style: TextStyle(fontSize: 12.sp),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hàm loại bỏ thẻ HTML khỏi chuỗi văn bản
String _stripHtmlTags(String htmlText) {
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(regex, '').replaceAll('&nbsp;', ' ').trim();
}
