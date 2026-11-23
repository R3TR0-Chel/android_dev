import 'package:android_dev/screens/home_screen/models/post_model.dart';

class PostServices{

  final List<PostModel> posts = [];

  PostServices();

  void addPost(PostModel post) {
    posts.add(post);
  }

  void batchAddPosts(List<PostModel> newPosts) {
    posts.addAll(newPosts);
  }
}