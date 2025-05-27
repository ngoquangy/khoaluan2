import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:learn_megnagmet/models/certificate.dart';
import 'package:learn_megnagmet/My_cources/detail.dart'; // Nhập file mới
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/Services/urlimage.dart';

class HocPhanCard extends StatelessWidget {
  final HocPhan hocPhan;
  final Future<List<BoDeTracNghiem>> futureBoDe;
  final Future<List<ExamResult>> futureExamResults;
  final int userId;

  const HocPhanCard({
    super.key,
    required this.hocPhan,
    required this.futureBoDe,
    required this.futureExamResults,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(hocPhan: hocPhan),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.h),
            border: Border.all(
              color: const Color(0XFFDEDEDE),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    '$urlImage${hocPhan.photo}',
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(child: _buildHocPhanDetails()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHocPhanDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          hocPhan.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        FutureBuilder<List<BoDeTracNghiem>>(
          future: futureBoDe,
          builder: (context, bodeSnapshot) {
            if (bodeSnapshot.connectionState == ConnectionState.waiting) {
              return Text('Đang tải...');
            } else if (bodeSnapshot.hasError) {
              return Text('Có lỗi: ${bodeSnapshot.error}');
            } else {
              final filteredBoDe = bodeSnapshot.data!
                  .where((boDe) => boDe.hocphanId == hocPhan.id)
                  .toList();
              return FutureBuilder<List<ExamResult>>(
                future: futureExamResults,
                builder: (context, examSnapshot) {
                  if (examSnapshot.connectionState == ConnectionState.waiting) {
                    return Text('Đang tải kết quả...');
                  } else if (examSnapshot.hasError) {
                    return Text('Có lỗi: ${examSnapshot.error}');
                  } else {
                    return _buildCompletionStatus(
                      filteredBoDe,
                      examSnapshot.data ?? [],
                    );
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCompletionStatus(
      List<BoDeTracNghiem> filteredBoDe, List<ExamResult> examResults) {
    int total = filteredBoDe.length;
    int completed = examResults
        .where((result) =>
            result.userId == userId &&
            result.status == "Hoàn thành" &&
            filteredBoDe.any((bode) => bode.id == result.bodetracnghiemId))
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hoàn thành: $completed / $total",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 6.0.h,
          percent: total > 0 ? completed / total : 0.0,
          trailing: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              "${(completed / (total > 0 ? total : 1) * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          backgroundColor: const Color(0XFFDEDEDE),
          progressColor: const Color(0XFF23408F),
          barRadius: Radius.circular(22.w),
        ),
      ],
    );
  }
}
