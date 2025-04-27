import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/My_cources/hoc_phan_list.dart'; // Thêm dòng này
import 'package:learn_megnagmet/Services/token.dart' as token;

class OngoingScreen extends StatefulWidget {
  const OngoingScreen({Key? key}) : super(key: key);

  @override
  State<OngoingScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  final OngoingController ongoingController = Get.put(OngoingController());
  late Future<List<HocPhan>> futureHocPhan;
  late Future<List<BoDeTracNghiem>> futureBoDe;
  late Future<List<ExamResult>> futureExamResults;
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = int.tryParse(token.userId) ?? 0;

    if (userId <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID không hợp lệ!')),
        );
      });
      return;
    }

    loadData();
  }

  void loadData() {
    futureHocPhan = AuthServices.fetchHocPhan();
    futureBoDe = AuthServices.fetchBoDe();
    futureExamResults = AuthServices.fetchExamResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Khóa Học',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder(
        init: ongoingController,
        builder: (controller) => FutureBuilder<List<HocPhan>>(
          future: futureHocPhan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có học phần'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return HocPhanCard(
                    hocPhan: snapshot.data![index],
                    futureBoDe: futureBoDe,
                    futureExamResults: futureExamResults,
                    userId: userId,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}