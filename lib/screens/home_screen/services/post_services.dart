import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/comment_model.dart';

class PostServices {
  final List<PostModel> posts = [];

  PostServices();

  void addPost(PostModel post) {
    posts.add(post);
  }

  void likePost(PostModel post) {
    post.addLike(post.likeCount + 1);
  }

  void commentOnPost(PostModel post, String text) {
    final comment = CommentModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      username: 'kae0961',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      text: text,
    );

    post.addCommentModel(comment);
  }

  void batchAddPosts(List<PostModel> newPosts) {
    posts.addAll(newPosts);
  }
}
