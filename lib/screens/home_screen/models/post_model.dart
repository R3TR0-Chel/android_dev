import 'package:android_dev/screens/home_screen/models/comment_model.dart';

class PostModel {
  final String? imageUrl;
  int? likeCount;
  int? commentCount;
  final String? description;
  final List<CommentModel> comments;
  bool isLiked = false;

  PostModel({
    this.imageUrl,
    this.likeCount,
    this.commentCount,
    this.description,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  void addLike(int newCount) {
    // This method should ideally update the like count in a state management solution
    likeCount = newCount;
  }

  void addComment(CommentModel comment) {
    comments.add(comment);
    commentCount = comments.length;
  }
}
