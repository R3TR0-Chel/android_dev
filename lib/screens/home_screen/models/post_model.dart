import 'comment_model.dart'; 

class PostModel {
  final String? imageUrl;
  int? likeCount;
  int? commentCount;
  final String? description;

  final List<CommentModel> comments = [];

  PostModel({
    this.imageUrl,
    this.likeCount,
    this.commentCount,
    this.description,
  });

  void addLike(int newCount) {
    // This method should ideally update the like count in a state management solution
    likeCount = newCount;
  }

  void addComment(CommentModel comment) {
    // This method should ideally update the comment count in a state management solution
    comments.add(comment);
    commentCount = comments.length;
  }

}