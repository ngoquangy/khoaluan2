import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/My_cources/detail.dart';
import 'package:get/get.dart';


class RecentAddedList extends StatelessWidget {
  const RecentAddedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0XFFFFFFFF),
      height: 223.h,
      width: double.infinity.w,
      child: FutureBuilder<List<HocPhan>>(
        future: AuthServices.fetchHocPhan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có học phần nào.'));
          } else {
            List<HocPhan> hocPhanList = snapshot.data!;
            // Lấy 3 khóa học mới nhất và đảo ngược thứ tự
            List<HocPhan> latestCourses =
                hocPhanList.take(3).toList().reversed.toList();

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: latestCourses.length,
              itemBuilder: (context, index) {
                final hocPhan = latestCourses[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () async {
                      // Chuyển đến BoDeScreen với danh sách bộ đề đã lọc
                        Get.to(() => DetailPage(hocPhan: hocPhan));
                    },
                    child: Container(
                      width: 320.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0XFFDEDEDE),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        // color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 158.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(hocPhan.photo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 11.h),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Text(
                              hocPhan.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                // color: Color(0XFF000000),
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                          // Thêm mô tả hoặc thông tin khác nếu cần
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Text(
                              hocPhan.summary,
                              style: TextStyle(
                                fontSize: 12.sp,
                                // color: Color(0XFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
