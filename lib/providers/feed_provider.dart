import "package:android_dev/providers/service_providers.dart";
import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// The feed's data manager. Widgets watch its state (the list of posts) and
// call its methods to change data. The real work is still done by
// PostServices; the notifier then publishes a new list so watchers rebuild.
class FeedNotifier extends Notifier<List<PostModel>> {
  @override
  List<PostModel> build() => List.of(ref.watch(postServicesProvider).posts);

  void toggleLike(PostModel post) {
    ref.read(postServicesProvider).toggleLike(post);
    _refresh();
  }

  void addComment(PostModel post, CommentModel comment) {
    ref.read(postServicesProvider).commentOnPost(post, comment);
    _refresh();
  }

  // Riverpod only notifies when `state` gets a new object, so after changing
  // a post in place we hand it a fresh copy of the list.
  void _refresh() => state = List.of(ref.read(postServicesProvider).posts);
}

final feedProvider =
    NotifierProvider<FeedNotifier, List<PostModel>>(FeedNotifier.new);

// Stories never change, so a plain read-only Provider is enough.
final storiesProvider = Provider<List<StoryModel>>(
  (ref) => ref.watch(postServicesProvider).stories,
);
