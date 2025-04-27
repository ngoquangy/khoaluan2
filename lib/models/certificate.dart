class Certificate {
  final int userId;
  final int hocPhanId;
  final String issueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Certificate({
    required this.userId,
    required this.hocPhanId,
    required this.issueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Tạo một đối tượng Certificate từ JSON
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      userId: json['user_id'],
      hocPhanId: json['hocphan_id'],
      issueDate: json['issue_date'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Chuyển đổi một đối tượng Certificate thành JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'hocphan_id': hocPhanId,
      'issue_date': issueDate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}