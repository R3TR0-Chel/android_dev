import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/services/post_services.dart';

final postServicesProvider = Provider<PostServices>((ref) {
  final service = PostServices();

  service.batchAddPosts(
    List.generate(
      10,
      (index) => PostModel(
        imageUrl:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=800',
        description:
            'This is post #${index + 1} description. It can be quite long and will wrap to the next line if necessary.',
        likeCount: index * 5,
      ),
    ),
  );

  return service;
});

final postsProvider =
    NotifierProvider<PostsNotifier, List<PostModel>>(
  PostsNotifier.new,
);

class PostsNotifier extends Notifier<List<PostModel>> {
  late PostServices _postServices;

  @override
  List<PostModel> build() {
    _postServices = ref.watch(postServicesProvider);
    return List.unmodifiable(_postServices.posts);
  }

  void addPost(PostModel post) {
    _postServices.addPost(post);
    state = List.unmodifiable(_postServices.posts);
  }

  // Like and unlike posts.
  void toggleLike(int index, bool isLiked) {
    final post = state[index];

    if (isLiked) {
      post.addLike(post.likeCount - 1);
    } else {
      _postServices.likePost(post);
    }

    state = List.unmodifiable(_postServices.posts);
  }

  // Add comment to post.
  void commentOnPost(int index, String text) {
    final post = state[index];

    _postServices.commentOnPost(post, text);

    state = List.unmodifiable(_postServices.posts);
  }
}