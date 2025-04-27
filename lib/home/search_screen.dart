import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:learn_megnagmet/My_cources/hoc_phan_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<SearchScreen> {
  final OngoingController ongoingController = Get.put(OngoingController());
  late Future<List<HocPhan>> futureHocPhan;
  late Future<List<BoDeTracNghiem>> futureBoDe;
  late Future<List<ExamResult>> futureExamResults;
  late int userId;
  String searchQuery = "";

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

    futureHocPhan = AuthServices.fetchHocPhan();
    futureBoDe = AuthServices.fetchBoDe();
    futureExamResults = AuthServices.fetchExamResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm Kiếm', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: GetBuilder(
        init: ongoingController,
        builder: (controller) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Học Phần',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9B9B9B),
                      fontWeight: FontWeight.bold,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF9B9B9B),
                      size: 34.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF23408F),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<HocPhan>>(
                future: futureHocPhan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có dữ liệu'));
                  } else {
                    final filteredList = snapshot.data!
                        .where((hocPhan) => hocPhan.title
                            .toLowerCase()
                            .contains(searchQuery))
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return HocPhanCard(
                          hocPhan: filteredList[index],
                          futureBoDe: futureBoDe,
                          futureExamResults: futureExamResults,
                          userId: userId,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
