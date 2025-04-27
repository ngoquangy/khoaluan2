class LoaiTracNghiem {
  final int id;
  final String title;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  LoaiTracNghiem({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Phương thức chuyển đổi từ JSON sang đối tượng LoaiTracNghiem
  factory LoaiTracNghiem.fromJson(Map<String, dynamic> json) {
    return LoaiTracNghiem(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Phương thức chuyển đổi từ đối tượng LoaiTracNghiem sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}