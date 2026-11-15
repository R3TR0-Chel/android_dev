import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/data/mock_data.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:android_dev/screens/home_screen/widgets/story_widget.dart";
import "package:flutter/material.dart";

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Created once in initState, so rebuilds don't add the posts again.
  final PostServices postServices = PostServices();

  @override
  void initState() {
    super.initState();
    postServices.batchAddPosts(mockPosts);
    postServices.batchAddStories(mockStories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: ListView.builder(
        // Item 0 is the stories row, the rest are posts.
        itemCount: postServices.posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: postServices.stories.length,
                itemBuilder: (context, i) =>
                    StoryWidget(story: postServices.stories[i]),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: PostWidget(post: postServices.posts[index - 1]),
          );
        },
      ),
    );
  }
}
