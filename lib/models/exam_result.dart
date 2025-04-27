class ExamResult {
  final int id;
  final int userId;
  final int hocphanId;
  final int bodetracnghiemId;
  final List<QuestionResult> questions; // Danh sách các kết quả câu hỏi
  final int totalPoint;
  final String status;

  ExamResult({
    required this.id,
    required this.userId,
    required this.hocphanId,
    required this.bodetracnghiemId,
    required this.questions,
    required this.totalPoint,
    required this.status,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    List<QuestionResult> questionList;

    // Kiểm tra xem 'question' có phải là danh sách hay không
    if (json['question'] is List) {
      questionList = (json['question'] as List<dynamic>)
          .map((questionJson) => QuestionResult.fromJson(questionJson))
          .toList();
    } else {
      // Nếu không phải danh sách, có thể là chuỗi hoặc không có
      questionList = [];
    }

    return ExamResult(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      hocphanId: json['hocphan_id'] ?? 0,
      bodetracnghiemId: json['bodetracnghiem_id'] ?? 0,
      questions: questionList,
      totalPoint: json['total_point'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class QuestionResult {
  final int questionId;
  final int result;

  QuestionResult({
    required this.questionId,
    required this.result,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['question_id'] ?? 0,
      result: json['result'] ?? 0,
    );
  }
}