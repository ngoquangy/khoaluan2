class TrainingDetail {
  final int hocphanId;
  final int tracnghiemId;
  final String point;
  final String totalTime;
  final String date;
  final int trueCount;
  final int falseCount;
  final int totalCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrainingDetail({
    required this.hocphanId,
    required this.tracnghiemId,
    required this.point,
    required this.totalTime,
    required this.date,
    required this.trueCount,
    required this.falseCount,
    required this.totalCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainingDetail.fromJson(Map<String, dynamic> json) {
    return TrainingDetail(
      hocphanId: json['hocphan_id'],
      tracnghiemId: json['tracnghiem_id'],
      point: json['point'],
      totalTime: json['total_time'],
      date: json['date'],
      trueCount: json['true_count'],
      falseCount: json['false_count'],
      totalCount: json['total_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hocphan_id': hocphanId,
      'tracnghiem_id': tracnghiemId,
      'point': point,
      'total_time': totalTime,
      'date': date,
      'true_count': trueCount,
      'false_count': falseCount,
      'total_count': totalCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
