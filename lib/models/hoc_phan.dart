class HocPhan {
  final int id;
  final String title;
  final String photo;
  final String content;
  final String summary;
  final int tinchi;
  final String hinhthucthi;
  final int? userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  HocPhan({
    required this.id,
    required this.title,
    required this.photo,
    required this.content,
    required this.summary,
    required this.tinchi,
    required this.hinhthucthi,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HocPhan.fromJson(Map<String, dynamic> json) {
    return HocPhan(
      id: json['id'],
      title: json['title'],
      photo: json['photo'],
      content: json['content'],
      summary: json['summary'],
      tinchi: json['tinchi'],
      hinhthucthi: json['hinhthucthi'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}