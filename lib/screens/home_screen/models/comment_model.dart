class CommentModel {
  const CommentModel({
    required this.id,
    required this.authorName,
    required this.body,
    required this.createdAt,
  });

  final int id;
  final String authorName;
  final String body;
  final DateTime createdAt;
}
