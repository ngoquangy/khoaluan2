import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:learn_megnagmet/models/certificate.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:learn_megnagmet/My_cources/detail.dart'; // Nhập file mới

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final OngoingController ongoingController = Get.put(OngoingController());
  late Future<List<HocPhan>> futureHocPhan;
  late Future<List<BoDeTracNghiem>> futureBoDe;
  late Future<List<ExamResult>> futureExamResults;
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = int.tryParse(token.userId) ?? 0;

    if (userId > 0) {
      futureHocPhan = AuthServices.fetchHocPhan();
      futureBoDe = AuthServices.fetchBoDe();
      futureExamResults = AuthServices.fetchExamResults();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID không hợp lệ!')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa Học Của Tôi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<HocPhan>>(
        future: futureHocPhan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          return FutureBuilder<List<ExamResult>>(
            future: futureExamResults,
            builder: (context, examSnapshot) {
              if (examSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!examSnapshot.hasData) {
                return const Center(child: Text('Không có kết quả thi'));
              }

              List<HocPhan> completedHocPhan = snapshot.data!.where((hocPhan) {
                return examSnapshot.data!.any((exam) =>
                    exam.hocphanId == hocPhan.id && exam.userId == userId);
              }).toList();

              if (completedHocPhan.isEmpty) {
                return const Center(child: Text('Không có học phần phù hợp'));
              }

              return ListView.builder(
                itemCount: completedHocPhan.length,
                itemBuilder: (context, index) =>
                    _buildHocPhanCard(completedHocPhan[index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHocPhanCard(HocPhan hocPhan) {
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
            border: Border.all(color: const Color(0XFFDEDEDE), width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    hocPhan.photo,
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(hocPhan.title,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10.h),
                      FutureBuilder<List<BoDeTracNghiem>>(
                        future: futureBoDe,
                        builder: (context, bodeSnapshot) {
                          if (!bodeSnapshot.hasData) {
                            return const Text('Đang tải...');
                          }

                          List<BoDeTracNghiem> filteredBode = bodeSnapshot.data!
                              .where((b) => b.hocphanId == hocPhan.id)
                              .toList();

                          int total = filteredBode.length;

                          return FutureBuilder<List<ExamResult>>(
                            future: futureExamResults,
                            builder: (context, resultSnapshot) {
                              if (!resultSnapshot.hasData) {
                                return const Text('Đang tải kết quả...');
                              }

                              int completed = resultSnapshot.data!
                                  .where((res) =>
                                      res.userId == userId &&
                                      filteredBode.any((b) =>
                                          b.id == res.bodetracnghiemId) &&
                                      res.status == "Hoàn thành")
                                  .length;

                              completed = completed > total ? total : completed;

                              // Tạo chứng chỉ nếu hoàn thành tất cả
                              if (completed == total && total > 0) {
                                Certificate cert = Certificate(
                                  userId: userId,
                                  hocPhanId: hocPhan.id,
                                  issueDate: DateTime.now().toIso8601String(),
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );
                                AuthServices.createCertificate(cert);
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hoàn thành: $completed / $total",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 10.h),
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    lineHeight: 6.h,
                                    percent:
                                        total > 0 ? completed / total : 0.0,
                                    trailing: Padding(
                                      padding: EdgeInsets.only(left: 12.w),
                                      child: Text(
                                        "${(completed / (total > 0 ? total : 1) * 100).toStringAsFixed(0)}%",
                                        style: const TextStyle(
                                            fontSize: 14, fontFamily: 'Gilroy'),
                                      ),
                                    ),
                                    backgroundColor: const Color(0XFFDEDEDE),
                                    progressColor: const Color(0XFF23408F),
                                    barRadius: Radius.circular(22.w),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
