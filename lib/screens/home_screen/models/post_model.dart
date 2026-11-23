class PostModel {
  final int id;
  final String imageUrl;
  final String description;
  final int authorId;
  final String authorName;
  final int likeCount;
  final int commentCount;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.authorId,
    required this.authorName,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
  });
}
