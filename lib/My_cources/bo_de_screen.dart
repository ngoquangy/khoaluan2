// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:learn_megnagmet/Services/auth_services.dart';
// import 'package:learn_megnagmet/models/bo_de.dart';
// import 'package:learn_megnagmet/models/cau_hoi.dart';
// import 'question_display.dart';
// import 'package:learn_megnagmet/models/exam_result.dart';
// import 'package:learn_megnagmet/Services/token.dart' as token;
// import 'package:learn_megnagmet/models/learning.dart';

// class BoDeScreen extends StatefulWidget {
//   final int hocPhanId;

//   const BoDeScreen({Key? key, required this.hocPhanId}) : super(key: key);

//   @override
//   _BoDeScreenState createState() => _BoDeScreenState();
// }

// class _BoDeScreenState extends State<BoDeScreen> {
//   late Future<List<ExamResult>> _resultFuture;
//   late Future<List<BoDeTracNghiem>> _bodeFuture;
//   late Future<List<CauHoi>> _cauHoiFuture;
//   List<CauHoi> allCauHoi = [];
//   int userId = 0;

//   @override
//   void initState() {
//     super.initState();
//     userId = int.tryParse(token.userId) ?? 0;

//     if (userId <= 0) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('User ID không hợp lệ!')),
//         );
//       });
//       return;
//     }

//     _resultFuture = AuthServices.fetchExamResults();
//     _bodeFuture = AuthServices.fetchBoDe();
//     _cauHoiFuture = AuthServices.fetchCauHoi().then((cauHoiList) {
//       setState(() {
//         allCauHoi = cauHoiList;
//       });
//       return cauHoiList;
//     });
//   }

//   final String timeSpending =
//       DateTime.now().toIso8601String().split('T')[0]; // Lấy ngày hiện tại
//   Future<void> createLearning() async {
//     Learning learning = Learning(userId: userId, timeSpending: timeSpending);

//     AuthServices.createThanhTuu(learning).then((response) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bộ Đề', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(15.w),
//           child: FutureBuilder<List<BoDeTracNghiem>>(
//             future: _bodeFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Có lỗi xảy ra'));
//               } else {
//                 List<BoDeTracNghiem> allBodes = snapshot.data!
//                     .where((bode) => bode.hocphanId == widget.hocPhanId)
//                     .toList();

//                 return FutureBuilder<List<ExamResult>>(
//                   future: _resultFuture,
//                   builder: (context, resultSnapshot) {
//                     if (resultSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (resultSnapshot.hasError) {
//                       return Center(child: Text('Có lỗi xảy ra'));
//                     } else {
//                       List<ExamResult> examResults = resultSnapshot.data!;

//                       List<BoDeTracNghiem> laiBaiTapBodes = allBodes
//                           .where((bode) => bode.target == "Làm bài tập")
//                           .toList();

//                       List<ExamResult> matchingResults = examResults
//                           .where((result) =>
//                               result.hocphanId == widget.hocPhanId &&
//                               result.userId == userId &&
//                               result.bodetracnghiemId != Null &&
//                               result.status == "Hoàn thành" &&
//                               allBodes.any((bode) =>
//                                   bode.id == result.bodetracnghiemId &&
//                                   bode.target == "Làm bài tập"))
//                           .toList();

//                       List<BoDeTracNghiem> filteredBodes = allBodes;

//                       return Column(
//                         children: [
//                           Expanded(
//                             child: GridView.builder(
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                               ),
//                               itemCount: filteredBodes.length,
//                               itemBuilder: (context, index) {
//                                 final bode = filteredBodes[index];

//                                 bool isEnabled = bode.target == "Làm bài tập" ||
//                                     (laiBaiTapBodes.length ==
//                                         matchingResults.length);
//                                 Color backgroundColor =
//                                     isEnabled ? Color(0XFF23408F) : Colors.grey;

//                                 return Padding(
//                                   padding: EdgeInsets.all(5.h),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if (isEnabled) {
//                                         createLearning();
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 QuestionDisplay(
//                                               questions: bode.questions
//                                                   .map((question) {
//                                                 return allCauHoi.firstWhere(
//                                                   (cauHoi) =>
//                                                       cauHoi.id ==
//                                                       int.parse(
//                                                           question.idQuestion),
//                                                 );
//                                               }).toList(),
//                                               bodeId: bode.id.toString(),
//                                               hocphanId: widget.hocPhanId,
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     },
//                                     child: Container(
//                                       padding: EdgeInsets.all(16.h),
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(22.h),
//                                         color: backgroundColor,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: const Color(0XFF23408F)
//                                                 .withOpacity(0.14),
//                                             blurRadius: 16.h,
//                                             offset: const Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           bode.title,
//                                           style: TextStyle(
//                                             fontSize: 25.sp,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//                   },
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
