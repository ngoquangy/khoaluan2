import 'dart:convert';

class BoDeTracNghiem {
  final int id;
  final String title;
  final int hocphanId;
  final int? chapterId;
  final int time;
  final String target;
  final List<Question> questions;

  BoDeTracNghiem({
    required this.id,
    required this.title,
    required this.hocphanId,
    required this.chapterId,
    required this.time,
    required this.target,
    required this.questions,
  });

  // Factory method để parse từ JSON
  factory BoDeTracNghiem.fromJson(Map<String, dynamic> json) {
    return BoDeTracNghiem(
      id: json['id'],
      title: json['title'],
      hocphanId: json['hocphan_id'],
      chapterId: json['chuong_id'],
      time: json['time'],
      target: json['muctieu'],
      questions: (jsonDecode(json['questions']) as List<dynamic>)
          .map((item) => Question.fromJson(item))
          .toList(),
    );
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hocphan_id': hocphanId,
      'chuong_id': chapterId,
      'time': time,
      'muctieu': target,
      'questions': jsonEncode(questions.map((q) => q.toJson()).toList()),
    };
  }
}

class Question {
  final String idQuestion;
  // final double points;

  Question({
    required this.idQuestion,
    // required this.points,
  });

  // Factory method để parse từ JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      idQuestion: json['id_question'],
      // points: double.parse(json['points']),
    );
  }

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id_question': idQuestion,
      // 'points': points.toString(),
    };
  }
}
