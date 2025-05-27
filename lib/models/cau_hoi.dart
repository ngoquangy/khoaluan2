class CauHoi {
  final int id;
  final String content;
  final String? code;
  final String? imageUrl;
  final int hocphanId;
  final int loaiId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CauHoi({
    required this.id,
    required this.content,
    required this.code,
    required this.imageUrl,
    required this.hocphanId,
    required this.loaiId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CauHoi.fromJson(Map<String, dynamic> json) {
    return CauHoi(
      id: json['id'],
      content: json['content'],
      code: json['code'],
      imageUrl: json['photo'],
      hocphanId: json['hocphan_id'],
      loaiId: json['loai_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'code': code,
      'photo': imageUrl,
      'hocphan_id': hocphanId,
      'loai_id': loaiId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}