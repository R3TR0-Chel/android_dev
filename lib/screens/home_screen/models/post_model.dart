import 'comment_model.dart';

class PostModel {
  final String? imageUrl;
  int likeCount;
  int commentCount;
  final String? description;
  final List<CommentModel> comments;

  PostModel({
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.description,
    List<CommentModel>? comments,
  }) : comments = comments ?? [] {
    commentCount = this.comments.length;
  }

  void addLike(int newCount) {
    likeCount = newCount;
  }

  void addComment(int newCount) {
    commentCount = newCount;
  }

  void addCommentModel(CommentModel comment) {
    comments.add(comment);
    commentCount = comments.length;
  }
}