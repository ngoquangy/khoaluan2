import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/cau_hoi.dart';
import 'package:learn_megnagmet/Services/auth_services.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;
import 'package:learn_megnagmet/models/dap_an.dart';
import 'package:learn_megnagmet/models/loai_trac_nghiem.dart';
import 'package:learn_megnagmet/My_cources/resultScreen.dart';
import 'dart:async';

class QuestionDisplay extends StatefulWidget {
  final List<CauHoi> questions;
  final String bodeId; // Thêm biến để lưu bode.id
  final int hocphanId; // Thay đổi Int thành int

  QuestionDisplay(
      {required this.questions,
      required this.bodeId,
      required this.hocphanId}); // Cập nhật constructor

  @override
  _QuestionDisplayState createState() => _QuestionDisplayState();
}

class _QuestionDisplayState extends State<QuestionDisplay> {
  late Future<List<DapAn>> _dapAnFuture;
  late Future<List<LoaiTracNghiem>> _loaiTracNghiemFuture;
  final Map<String, String?> _selectedAnswers = {};
  final Map<String, String> _writtenAnswers = {};
  final Map<String, List<String>> _multiSelectedAnswers = {};
  final Map<String, String?> _replacementIds = {};

  late Timer _timer;
  int elapsedTime = 0; // Thời gian đã trôi qua tính bằng giây
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _dapAnFuture = AuthServices.fetchDapAn();
    _loaiTracNghiemFuture = AuthServices.fetchLoaiTracNghiem();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page!.toInt();
        });
      });

    // Bắt đầu bộ đếm thời gian
    _startTimer();
  }

  // Hàm bắt đầu bộ đếm thời gian
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++; // Tăng thời gian đã trôi qua
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy bộ đếm khi widget bị xóa
    super.dispose();
  }

  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  Future<void> _submitAnswers() async {
    final userIdString = token.userId; // Lấy userId từ token
    final userId = int.tryParse(userIdString); // Chuyển đổi sang int

    if (userId == null || userId < 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User ID không hợp lệ!')));
      return;
    }

    final results = <Map<String, dynamic>>[];
    final allDapAn = await _dapAnFuture;
    int correctCount = 0;

    for (var question in widget.questions) {
      final selectedAnswer = _selectedAnswers[question.id.toString()];
      int selectedAnswerId = 0;

      // Kiểm tra câu trả lời chọn một đáp án
      if (selectedAnswer != null) {
        final correctAnswer = allDapAn.firstWhere(
          (dapAn) => dapAn.tracNghiemId == question.id && dapAn.isCorrect,
          orElse: () =>
              DapAn(id: -1, tracNghiemId: -1, content: '', isCorrect: false),
        );

        selectedAnswerId =
            selectedAnswer == correctAnswer.id.toString() ? 1 : 0;
        if (selectedAnswerId == 1) correctCount++;

        results.add({
          'question_id': question.id,
          'result': selectedAnswerId,
        });
      }

      // Kiểm tra câu trả lời viết (Điền đáp án)
      if (_writtenAnswers.containsKey(question.id.toString())) {
        final writtenAnswer = _writtenAnswers[question.id.toString()];
        final matchingAnswers =
            allDapAn.where((d) => d.content == writtenAnswer).toList();

        selectedAnswerId = matchingAnswers.isNotEmpty ? 1 : 0;
        if (selectedAnswerId == 1) correctCount++;

        results.add({
          'question_id': question.id,
          'result': selectedAnswerId,
        });
      }

      // Kiểm tra câu trả lời cho nhiều đáp án
      if (_multiSelectedAnswers.containsKey(question.id.toString())) {
        final selectedMultiAnswers =
            _multiSelectedAnswers[question.id.toString()]!;
        final correctAnswersList = allDapAn
            .where((d) => d.tracNghiemId == question.id && d.isCorrect)
            .toList();

        selectedAnswerId =
            selectedMultiAnswers.length == correctAnswersList.length &&
                    selectedMultiAnswers.every((answer) => correctAnswersList
                        .any((correct) => correct.id.toString() == answer))
                ? 1
                : 0;

        if (selectedAnswerId == 1) correctCount++;

        results.add({
          'question_id': question.id,
          'result': selectedAnswerId,
        });
      }
    }

    if (results.isNotEmpty) {
      // Gửi kết quả và chuyển đến trang kết quả
      try {
        final response = await AuthServices.submitExamResults(
            userId,
            widget.hocphanId,
            widget.bodeId,
            results,
            0,
            "Chưa hoàn thành"); // Truyền hocphanId
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.statusCode == 200
              ? 'Nộp bài thành công!'
              : 'Có lỗi xảy ra khi nộp bài.'),
        ));

        // Chuyển đến trang kết quả
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              totalQuestions: widget.questions.length,
              correctAnswers: correctCount,
              bodeId: widget.bodeId,
              elapsedTime: elapsedTime, // Truyền thời gian đã trôi qua
              hocphanId: widget.hocphanId,
            ),
          ),
        );
        //
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Có lỗi xảy ra: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chưa có đáp án nào được chọn.')));
    }
  }

  void _nextQuestion() {
    if (_currentPage < widget.questions.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Chiều cao của AppBar
        child: Column(
          children: [
            AppBar(
              title: Text('Câu Hỏi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent, // Màu nền của AppBar
            ),
            Container(
              height: 4.0, // Chiều cao của gạch ngang
              color: const Color.fromARGB(
                  255, 210, 210, 210), // Màu của gạch ngang
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: FutureBuilder<List<DapAn>>(
          future: _dapAnFuture,
          builder: (context, dapAnSnapshot) {
            if (dapAnSnapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (dapAnSnapshot.hasError ||
                !dapAnSnapshot.hasData ||
                dapAnSnapshot.data!.isEmpty)
              return Center(child: Text('Có lỗi xảy ra'));

            return FutureBuilder<List<LoaiTracNghiem>>(
              future: _loaiTracNghiemFuture,
              builder: (context, loaiTracNghiemSnapshot) {
                if (loaiTracNghiemSnapshot.connectionState ==
                    ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (loaiTracNghiemSnapshot.hasError)
                  return Center(child: Text('Có lỗi xảy ra.'));

                final allDapAn = dapAnSnapshot.data!;
                final allLoaiTracNghiem = loaiTracNghiemSnapshot.data!;

                return PageView.builder(
                  controller: _pageController,
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    final cauHoi = widget.questions[index];
                    final dapAnList = allDapAn
                        .where((dapAn) => dapAn.tracNghiemId == cauHoi.id)
                        .toList();
                    final loaiTracNghiem = allLoaiTracNghiem
                        .firstWhere((loai) => loai.id == cauHoi.loaiId);

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuestionHeader(index, cauHoi,
                              allDapAn), // Truyền allDapAn vào đây
                          SizedBox(height: 10.h),
                          _buildAnswerWidgets(
                              loaiTracNghiem.title, dapAnList, cauHoi),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0XFF23408F),
        child: Container(
          height: 70.h,
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(300.w, 80.h),
                  padding: EdgeInsets.symmetric(vertical: 15.h)),
              onPressed: () {
                if (_currentPage < widget.questions.length - 1) {
                  _nextQuestion();
                } else {
                  _submitAnswers();
                }
              },
              child: Text(
                  _currentPage == widget.questions.length - 1
                      ? 'Nộp bài'
                      : 'Tiếp theo',
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(int index, CauHoi cauHoi, List<DapAn> allDapAn) {
    String displayedContent = removeHtmlTags(cauHoi.content).replaceAll(
      '...',
      _replacementIds[cauHoi.id.toString()] != null
          ? allDapAn
              .firstWhere((d) =>
                  d.id.toString() == _replacementIds[cauHoi.id.toString()])
              .content
          : '_____',
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu ${index + 1}: ',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: DragTarget<String>(
            onAccept: (data) {
              setState(() {
                _replacementIds[cauHoi.id.toString()] = data;
                _selectedAnswers[cauHoi.id.toString()] = data;
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Text(
                displayedContent,
                style: TextStyle(fontSize: 18.sp),
                softWrap: true,
              );
            },
          ),
        ),
      ],
    );
    // hiện cauHoi.code ở đây
  }

  Widget _buildAnswerWidgets(
      String questionType, List<DapAn> dapAnList, CauHoi cauHoi) {
    switch (questionType) {
      case "Kéo thả":
        return _buildDragAndDropAnswers(dapAnList);
      case "Chọn một đáp án":
      case "Chọn đúng sai":
        return _buildRadioAnswers(dapAnList, cauHoi);
      case "Điền đáp án":
        return _buildTextFieldAnswer(cauHoi);
      case "Chọn nhiều đáp án":
        return _buildCheckboxAnswers(dapAnList, cauHoi);
      default:
        return Container();
    }
  }

  Widget _buildDragAndDropAnswers(List<DapAn> dapAnList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: dapAnList.map((dapAn) {
        return Draggable<String>(
          data: dapAn.id.toString(),
          child: Card(
              margin: EdgeInsets.only(right: 8.0),
              child: Padding(
                  padding: EdgeInsets.all(8.0), child: Text(dapAn.content))),
          feedback: Material(
              child: Card(
                  elevation: 5,
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(dapAn.content)))),
          childWhenDragging: Container(),
        );
      }).toList(),
    );
  }

  Widget _buildRadioAnswers(List<DapAn> dapAnList, CauHoi cauHoi) {
    return Column(
      children: dapAnList.map((dapAn) {
        return RadioListTile<String>(
          title: Text(dapAn.content, style: TextStyle(fontSize: 14.sp)),
          value: dapAn.id.toString(),
          groupValue: _selectedAnswers[cauHoi.id.toString()],
          onChanged: (value) {
            setState(() {
              _selectedAnswers[cauHoi.id.toString()] = value;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTextFieldAnswer(CauHoi cauHoi) {
    return TextField(
      onChanged: (value) {
        setState(() {
          _writtenAnswers[cauHoi.id.toString()] = value;
        });
      },
      decoration: InputDecoration(
          labelText: 'Nhập đáp án', border: OutlineInputBorder()),
    );
  }

  Widget _buildCheckboxAnswers(List<DapAn> dapAnList, CauHoi cauHoi) {
    return Column(
      children: dapAnList.map((dapAn) {
        return CheckboxListTile(
          title: Text(dapAn.content),
          value: _multiSelectedAnswers[cauHoi.id.toString()]
                  ?.contains(dapAn.id.toString()) ??
              false,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _multiSelectedAnswers[cauHoi.id.toString()] =
                    _multiSelectedAnswers[cauHoi.id.toString()] ?? [];
                _multiSelectedAnswers[cauHoi.id.toString()]!
                    .add(dapAn.id.toString());
              } else {
                _multiSelectedAnswers[cauHoi.id.toString()]
                    ?.remove(dapAn.id.toString());
              }
            });
          },
        );
      }).toList(),
    );
  }
}
