class DapAn {
  final int id;
  final int tracNghiemId;
  final String content;
  final bool isCorrect;

  DapAn({
    required this.id,
    required this.tracNghiemId,
    required this.content,
    required this.isCorrect,
  });

  factory DapAn.fromJson(Map<String, dynamic> json) {
    return DapAn(
      id: json['id'],
      tracNghiemId: json['tracnghiem_id'],
      content: json['content'],
      isCorrect: json['is_correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracnghiem_id': tracNghiemId,
      'content': content,
      'is_correct': isCorrect,
    };
  }
}