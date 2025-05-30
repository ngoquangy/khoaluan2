import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../utils/screen_size.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/models/training_details.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/My_cources/detail.dart';

class ResultScreen extends StatefulWidget {
  final int elapsedTime; // Thêm biến để nhận elapsedTime
  final int totalQuestions;
  final int correctAnswers;
  final String bodeId; // Biến bodeId
  final int hocphanId;

  ResultScreen({
    required this.elapsedTime, // Thêm biến vào constructor
    required this.totalQuestions,
    required this.correctAnswers,
    required this.bodeId, // Tham số constructor
    required this.hocphanId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  HomeMainController controller = Get.put(HomeMainController());
  late double score;
  HocPhan? hocPhan; // Add this line

  @override
  void initState() {
    super.initState();
    // Tính điểm và lưu ngay
    score = (widget.correctAnswers / widget.totalQuestions) * 10;
    _saveScore();
    _loadHocPhan(); // Load HocPhan data
  }

  Future<void> _loadHocPhan() async {
    try {
      List<HocPhan> allHocPhan = await AuthServices.fetchHocPhan();
      HocPhan foundHocPhan = allHocPhan.firstWhere(
        (hp) => hp.id == widget.hocphanId,
      );

      setState(() {
        hocPhan = foundHocPhan;
      });
    } catch (e) {
      // Xử lý lỗi nếu không tìm thấy HocPhan
      print('Lỗi khi tải dữ liệu HocPhan: $e');
    }
  }

  Future<void> _saveScore() async {
    final userIdString = token.userId; // Lấy userId từ token
    final userId = int.tryParse(userIdString); // Chuyển đổi sang int

    if (userId == null || userId < 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User ID không hợp lệ!')));
      return;
    }

    // Tạo đối tượng TrainingDetail
    TrainingDetail trainingDetail = TrainingDetail(
      hocphanId: widget.hocphanId, // Thay đổi theo ID học phần của bạn
      tracnghiemId:
          int.parse(widget.bodeId), // Thay đổi theo ID bài trắc nghiệm của bạn
      point: score.round().toString(),
      totalTime: widget.elapsedTime.toString(),
      date: DateTime.now().toIso8601String(),
      trueCount: widget.correctAnswers,
      falseCount: widget.totalQuestions - widget.correctAnswers,
      totalCount: widget.totalQuestions,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      // Gọi phương thức tạo TrainingDetail
      await AuthServices.createTrainingDetails(trainingDetail);
    } catch (e) {
      // Xử lý lỗi mạng hoặc lỗi khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }

    try {
      await AuthServices.updatePoint(userId, widget.bodeId, score.round());
    } catch (e) {
      // Xử lý lỗi mạng hoặc lỗi khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }

    if (score >= 7) {
      try {
        await AuthServices.updateStatus(userId, widget.bodeId, "Hoàn thành");
      } catch (e) {
        // Xử lý lỗi mạng hoặc lỗi khác
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
          children: [
            AppBar(
              title: Text('Kết Quả',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  // Trở về trang DetailPage khi nhấn nút back
                  Get.to(() => DetailPage(hocPhan: hocPhan!));
                },
              ),
            ),
            Container(
              height: 4.0,
              color: const Color.fromARGB(255, 210, 210, 210),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Image(
                image: AssetImage("assets/success.png"),
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20.h),
              Text(
                'Tuyệt vời! Bạn đã hoàn thành bài luyện tập',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Tổng điểm đạt được: ${score.round()} /10',
                style: TextStyle(fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
              Text(
                'Thời gian: ${_formatElapsedTime(widget.elapsedTime)}',
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Biểu tượng "đúng"
                  Icon(
                    Icons.check_circle, // Biểu tượng "đúng"
                    color: Colors.green, // Màu cho biểu tượng "đúng"
                    size: 24.sp, // Kích thước biểu tượng
                  ),
                  SizedBox(
                      width: 8), // Khoảng cách giữa biểu tượng và số câu đúng
                  Text(
                    'Đúng: ${widget.correctAnswers}', // Số câu đúng
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(width: 20), // Khoảng cách giữa đúng và sai
                  // Biểu tượng "sai"
                  Icon(
                    Icons.cancel, // Biểu tượng "sai"
                    color: Colors.red, // Màu cho biểu tượng "sai"
                    size: 24.sp, // Kích thước biểu tượng
                  ),
                  SizedBox(
                      width: 8), // Khoảng cách giữa biểu tượng và số câu sai
                  Text(
                    'Sai: ${widget.totalQuestions - widget.correctAnswers}', // Số câu sai
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  String _formatElapsedTime(int elapsedTime) {
    final int minutes = elapsedTime ~/ 60; // Tính số phút
    final int seconds = elapsedTime % 60; // Tính số giây
    return '$minutes:${seconds.toString().padLeft(2, '0')}'; // Định dạng phút:giây
  }
}
