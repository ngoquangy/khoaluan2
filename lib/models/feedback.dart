class FeedbackModel {
  final int userId;
  final int rating;
  final String comments;

  FeedbackModel({required this.userId, required this.rating, required this.comments});

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "rating": rating,
      "comments": comments,
    };
  }
}
