import 'package:flutter/material.dart';
import 'package:learn_megnagmet/models/bo_de.dart';
import 'package:learn_megnagmet/models/cau_hoi.dart';
import 'package:learn_megnagmet/services/auth_services.dart';
import 'package:learn_megnagmet/models/chapter.dart';
import 'package:learn_megnagmet/models/hoc_phan.dart';
import 'package:learn_megnagmet/my_cources/question_display.dart';
import 'package:learn_megnagmet/models/exam_result.dart';
import 'package:learn_megnagmet/Services/token.dart' as token;

class BoDeTab extends StatefulWidget {
  final HocPhan hocPhan;
  final List<CauHoi> allCauHoi;

  const BoDeTab({
    super.key,
    required this.hocPhan,
    required this.allCauHoi,
  });

  @override
  State<BoDeTab> createState() => _BoDeTabState();
}

class _BoDeTabState extends State<BoDeTab> {
  late Future<List<BoDeTracNghiem>> futureBoDe;
  late Future<List<Chapter>> futureChapter;
  late Future<List<ExamResult>> futureExamResults = Future.value([]);

  @override
  void initState() {
    super.initState();
    futureBoDe = AuthServices.fetchBoDe();
    futureChapter = AuthServices.fetchChapter();
    futureExamResults =
        AuthServices.fetchExamResults(); // Gọi API để lấy kết quả
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Chapter>>(
      future: futureChapter,
      builder: (context, chapterSnapshot) {
        if (chapterSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (chapterSnapshot.hasError) {
          return Center(
              child: Text('Lỗi khi tải chương: ${chapterSnapshot.error}'));
        }

        final chapters = (chapterSnapshot.data ?? [])
            .where((chapter) => chapter.hocphanId == widget.hocPhan.id)
            .toList();

        return FutureBuilder<List<BoDeTracNghiem>>(
          future: futureBoDe,
          builder: (context, boDeSnapshot) {
            if (boDeSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (boDeSnapshot.hasError) {
              return Center(
                  child: Text('Lỗi khi tải bộ đề: ${boDeSnapshot.error}'));
            }

            final boDeList = boDeSnapshot.data!
                .where((boDe) => boDe.hocphanId == widget.hocPhan.id)
                .toList();

            return FutureBuilder<List<ExamResult>>(
              future: futureExamResults,
              builder: (context, examResultSnapshot) {
                if (examResultSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (examResultSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'Lỗi khi tải kết quả: ${examResultSnapshot.error}'));
                }

                final examResults = examResultSnapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...chapters.map((chapter) {
                        final boDeInChapter = boDeList
                            .where((boDe) => boDe.chapterId == chapter.id)
                            .toList();

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${chapter.title}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF23408F),
                                  ),
                                ),
                              ),
                              if (boDeInChapter.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child:
                                      Text('Không có bộ đề trong chương này.'),
                                )
                              else
                                Column(
                                  children: boDeInChapter.map((boDe) {
                                    return Container(
                                      child: _buildBoDeCard(boDe, examResults),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      // Hiển thị bộ đề không thuộc chương nào
                      Builder(
                        builder: (context) {
                          final boDeNoChapter = boDeList
                              .where((boDe) =>
                                  boDe.chapterId == null ||
                                  !chapters.any((chapter) =>
                                      chapter.id == boDe.chapterId))
                              .toList();

                          if (boDeNoChapter.isEmpty) return const SizedBox();

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade400, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...boDeNoChapter.map((boDe) {
                                  return Container(
                                    child: _buildBoDeCard(boDe, examResults),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBoDeCard(BoDeTracNghiem boDe, List<ExamResult> examResults) {
    ExamResult? examResult;
    try {
      examResult = examResults.firstWhere(
        (result) =>
            result.bodetracnghiemId == boDe.id &&
            result.hocphanId == widget.hocPhan.id &&
            result.userId == int.parse(token.userId),
      );
    } catch (e) {
      examResult = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boDe.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF23408F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  examResult != null
                      ? "Trạng thái: ${examResult.status}"
                      : "Trạng thái: Chưa hoàn thành",
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.description,
                color: Color(0xFF23408F), size: 25),
            onPressed: () {
              final questions = boDe.questions.map((question) {
                return widget.allCauHoi.firstWhere(
                  (cauHoi) => cauHoi.id == int.parse(question.idQuestion),
                );
              }).toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionDisplay(
                    questions: questions,
                    bodeId: boDe.id.toString(),
                    hocphanId: widget.hocPhan.id,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
