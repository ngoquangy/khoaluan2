class Learning {
  final int userId;
  final String timeSpending;

  Learning({
    required this.userId,
    required this.timeSpending,
  });

  factory Learning.fromJson(Map<String, dynamic> json) {
    return Learning(
      userId: json['user_id'],
      timeSpending: json['time_spending'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'time_spending': timeSpending,
    };
  }
}