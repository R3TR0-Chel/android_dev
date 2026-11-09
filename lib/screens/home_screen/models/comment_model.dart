class CommentModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String text;

  int likeCount;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.text,
    this.likeCount = 0,
    this.isLiked = false,
  });

  void toggleLike() {
    isLiked = !isLiked;

    if (isLiked) {
      likeCount++;
    } else {
      likeCount--;
    }
  }
}