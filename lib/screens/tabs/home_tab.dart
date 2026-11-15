import "package:android_dev/providers/feed_provider.dart";
import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/widgets/story_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// HomeTab no longer creates PostServices or loads data in initState.
// It watches the providers, and rebuilds when their data changes.
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedProvider);
    final stories = ref.watch(storiesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: ListView.builder(
        // Item 0 is the stories row, the rest are posts.
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, i) => StoryWidget(story: stories[i]),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: PostWidget(post: posts[index - 1]),
          );
        },
      ),
    );
  }
}
