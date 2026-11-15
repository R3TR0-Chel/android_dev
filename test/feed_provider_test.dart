import "package:android_dev/providers/feed_provider.dart";
import "package:android_dev/providers/service_providers.dart";
import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("feed likes and comments go through the injected PostServices", () {
    // Dependency injection in action: swap the real service (20 mock posts)
    // for one with a single known post.
    final fake = PostServices()..addPost(PostModel(likeCount: 5));
    final container = ProviderContainer(
      overrides: [postServicesProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);

    final post = container.read(feedProvider).single;
    final feed = container.read(feedProvider.notifier);

    feed.toggleLike(post);
    expect(post.isLiked, isTrue);
    expect(post.likeCount, 6);

    feed.toggleLike(post);
    expect(post.isLiked, isFalse);
    expect(post.likeCount, 5);

    final before = container.read(feedProvider);
    feed.addComment(
      post,
      CommentModel(username: "you", avatarUrl: "", text: "hi"),
    );
    expect(post.comments.single.text, "hi");
    expect(post.commentCount, 1);
    // A new list object is what makes watching widgets rebuild.
    expect(identical(container.read(feedProvider), before), isFalse);
  });
}
