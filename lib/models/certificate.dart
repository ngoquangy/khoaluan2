class Certificate {
  final int userId;
  final int hocPhanId;
  final String issueDate;

  Certificate({
    required this.userId,
    required this.hocPhanId,
    required this.issueDate,
  });

  // Tạo một đối tượng Certificate từ JSON
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      userId: json['user_id'],
      hocPhanId: json['hocphan_id'],
      issueDate: json['issue_date'],
    );
  }

  // Chuyển đổi một đối tượng Certificate thành JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'hocphan_id': hocPhanId,
      'issue_date': issueDate,
    };
  }
}