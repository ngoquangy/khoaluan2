// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:learn_megnagmet/controller/controller.dart';
// import 'package:learn_megnagmet/models/hoc_phan.dart';
// import 'package:learn_megnagmet/Services/auth_services.dart';
// import 'package:learn_megnagmet/My_cources/bo_de_screen.dart';
// import 'package:learn_megnagmet/models/bo_de.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:learn_megnagmet/models/exam_result.dart';
// import 'package:learn_megnagmet/Services/token.dart' as token;
// import 'package:learn_megnagmet/My_cources/xem_bode.dart';
// import 'package:learn_megnagmet/models/certificate.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _OngoingScreenState();
// }

// class _OngoingScreenState extends State<SearchScreen> {
//   final OngoingController ongoingController = Get.put(OngoingController());
//   late Future<List<HocPhan>> futureHocPhan;
//   late Future<List<BoDeTracNghiem>> futureBoDe;
//   late Future<List<ExamResult>> futureExamResults;
//   late int userId;
//   String searchQuery = "";

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

//     futureHocPhan = AuthServices.fetchHocPhan();
//     futureBoDe = AuthServices.fetchBoDe();
//     futureExamResults = AuthServices.fetchExamResults();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tìm Kiếm', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//       ),
//       body: GetBuilder(
//         init: ongoingController,
//         builder: (controller) => SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                 child: TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery =
//                           value.toLowerCase(); // Cập nhật từ khóa tìm kiếm
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Học Phần',
//                     hintStyle: TextStyle(
//                       color: const Color(0xFF9B9B9B),
//                       fontWeight: FontWeight.bold,
//                     ),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: const Color(0xFF9B9B9B),
//                       size: 34.sp,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: const Color(0xFF23408F),
//                         width: 1.w,
//                       ),
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                   ),
//                 ),
//               ),
//               FutureBuilder<List<HocPhan>>(
//                 future: futureHocPhan,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text('Không có dữ liệu'));
//                   } else {
//                     // Lọc danh sách học phần dựa trên từ khóa tìm kiếm
//                     final filteredList = snapshot.data!.where((hocPhan) {
//                       return hocPhan.title.toLowerCase().contains(searchQuery);
//                     }).toList();

//                     return _buildHocPhanList(filteredList);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHocPhanList(List<HocPhan> hocPhanList) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: hocPhanList.length,
//       itemBuilder: (context, index) {
//         return _buildHocPhanCard(hocPhanList[index]);
//       },
//     );
//   }

//   Widget _buildHocPhanCard(HocPhan hocPhan) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(22.h),
//           border: Border.all(
//             color: const Color(0XFFDEDEDE),
//             width: 1.5,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(10.w),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12.r),
//                 child: Image.network(
//                   hocPhan.photo,
//                   height: 100.h,
//                   width: 100.w,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Expanded(child: _buildHocPhanDetails(hocPhan)),
//               _buildActionButtons(hocPhan),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHocPhanDetails(HocPhan hocPhan) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 20.h),
//         Text(
//           hocPhan.title,
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontFamily: 'Gilroy',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.h),
//         FutureBuilder<List<BoDeTracNghiem>>(
//           future: futureBoDe,
//           builder: (context, bodeSnapshot) {
//             if (bodeSnapshot.connectionState == ConnectionState.waiting) {
//               return Text('Đang tải...');
//             } else if (bodeSnapshot.hasError) {
//               return Text('Có lỗi: ${bodeSnapshot.error}');
//             } else if (!bodeSnapshot.hasData || bodeSnapshot.data!.isEmpty) {
//               return Text('Không có bộ đề');
//             } else {
//               return _buildExamResults(hocPhan, bodeSnapshot.data!);
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildExamResults(HocPhan hocPhan, List<BoDeTracNghiem> allBode) {
//     List<BoDeTracNghiem> filteredBoDe =
//         allBode.where((boDe) => boDe.hocphanId == hocPhan.id).toList();
//     int count = filteredBoDe.length;

//     return FutureBuilder<List<ExamResult>>(
//       future: futureExamResults,
//       builder: (context, examSnapshot) {
//         if (examSnapshot.connectionState == ConnectionState.waiting) {
//           return Text('Đang tải kết quả...');
//         } else if (examSnapshot.hasError) {
//           return Text('Có lỗi: ${examSnapshot.error}');
//         } else {
//           return _buildCompletionStatus(
//               hocPhan, examSnapshot.data!, filteredBoDe, count);
//         }
//       },
//     );
//   }

//   Widget _buildCompletionStatus(HocPhan hocPhan, List<ExamResult> examResults,
//       List<BoDeTracNghiem> filteredBoDe, int count) {
//     int completedCount = examResults
//         .where((result) =>
//             result.userId == userId &&
//             filteredBoDe.any((boDe) => boDe.id == result.bodetracnghiemId) &&
//             result.status == "Hoàn thành")
//         .length;

//     int adjustedCount = count > 0 ? count : 0;

//     completedCount =
//         completedCount > adjustedCount ? adjustedCount : completedCount;

//     // Kiểm tra nếu hoàn thành 100%
//     if (completedCount == adjustedCount && adjustedCount > 0) {
//       // Tạo chứng chỉ
//       Certificate newCertificate = Certificate(
//         userId: userId,
//         hocPhanId: hocPhan.id, // Sử dụng hocPhan ở đây
//         issueDate: DateTime.now().toIso8601String(),
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       // Gọi phương thức tạo chứng chỉ
//       AuthServices.createCertificate(newCertificate).then((response) {});
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Hoàn thành: $completedCount / $adjustedCount",
//           style: TextStyle(
//             // color: Color(0XFF292929),
//             fontSize: 14.sp,
//             fontFamily: 'Gilroy',
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         SizedBox(height: 10.h),
//         LinearPercentIndicator(
//           padding: EdgeInsets.zero,
//           lineHeight: 6.0.h,
//           percent: adjustedCount > 0 ? completedCount / adjustedCount : 0.0,
//           trailing: Padding(
//             padding: EdgeInsets.only(left: 12.w),
//             child: Text(
//               "${(completedCount / (adjustedCount > 0 ? adjustedCount : 1) * 100).toStringAsFixed(0)}%",
//               style: TextStyle(
//                 fontFamily: 'Gilroy',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           backgroundColor: const Color(0XFFDEDEDE),
//           progressColor: const Color(0XFF23408F),
//           barRadius: Radius.circular(22.w),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(HocPhan hocPhan) {
//     return Row(
//       children: [
//         IconButton(
//           icon: Icon(Icons.assignment),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BoDeScreen(hocPhanId: hocPhan.id),
//               ),
//             );
//           },
//           color: Color(0XFF23408F),
//         ),
//         IconButton(
//           icon: Icon(Icons.visibility),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => XemBoDeScreen(hocPhanId: hocPhan.id),
//               ),
//             );
//           },
//           color: Color(0XFF23408F),
//         ),
//       ],
//     );
//   }
// }
// tách học phần ra làm một file riêng, nhớ là vẫn giữ nguyên giao diện 

