import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;

class XemBoDeScreen extends StatefulWidget {
  final int hocPhanId;

  const XemBoDeScreen({Key? key, required this.hocPhanId}) : super(key: key);

  @override
  _XemBoDeScreenState createState() => _XemBoDeScreenState();
}

class _XemBoDeScreenState extends State<XemBoDeScreen> {
  late Future<List<ExamResult>> _examResults;
  late Future<List<BoDeTracNghiem>> _bodeResults;

  @override
  void initState() {
    super.initState();
    _examResults = AuthServices.fetchExamResults();
    _bodeResults = AuthServices.fetchBoDe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết Quả Luyện Tập', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: FutureBuilder<List<ExamResult>>(
          future: _examResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có kết quả nào'));
            }

            List<ExamResult> examResults = snapshot.data!;
            final userId = int.tryParse(token.userId) ?? 0;

            if (userId <= 0) {
              return Center(child: Text('User ID không hợp lệ!'));
            }

            List<ExamResult> filteredResults = examResults.where((result) =>
                result.userId == userId && result.hocphanId == widget.hocPhanId).toList();

            if (filteredResults.isEmpty) {
              return Center(child: Text('Không có kết quả nào cho học phần này'));
            }

            return FutureBuilder<List<BoDeTracNghiem>>(
              future: _bodeResults,
              builder: (context, bodeSnapshot) {
                if (bodeSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (bodeSnapshot.hasError) {
                  return Center(child: Text('Có lỗi xảy ra khi lấy bộ đề: ${bodeSnapshot.error}'));
                } else if (!bodeSnapshot.hasData || bodeSnapshot.data!.isEmpty) {
                  return Center(child: Text('Không có bộ đề nào'));
                }

                List<BoDeTracNghiem> bodeResults = bodeSnapshot.data!;

                return ListView.builder(
                  itemCount: filteredResults.length,
                  itemBuilder: (context, index) {
                    ExamResult result = filteredResults[index];
                    BoDeTracNghiem? matchedBode = bodeResults.firstWhere(
                      (bode) => bode.id == result.bodetracnghiemId,
                    );

                    return Card(
                      color: Color(0XFF23408F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.all(5.h),
                      child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (matchedBode != Null)
                              Text(
                                'Tên đề: ${matchedBode.title}',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            SizedBox(height: 8.h),
                            Text(
                              'Yêu cầu: Đạt từ 7 điểm',
                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Trạng thái: ${result.status == "Hoàn thành" ? "Hoàn thành" : "Chưa hoàn thành"}',
                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}