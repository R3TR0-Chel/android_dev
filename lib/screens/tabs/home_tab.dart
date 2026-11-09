import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/models/story_model.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:android_dev/widgets/stories_list.dart";
import "package:flutter/material.dart";

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final PostServices _postServices;
  late final List<StoryModel> _stories;

  @override
  void initState() {
    super.initState();
    _postServices = PostServices();
    _postServices.batchAddPosts(List.generate(
      10,
      (index) => PostModel(
        imageUrl: 'https://picsum.photos/500/400?random=$index',
        description:
            'This is post #${index + 1} description. It can be quite long and will wrap to the next line if necessary.',
        likeCount: index * 5,
      ),
    ));

    _stories = List.generate(
      8,
      (index) => StoryModel(
        username: 'user_${index + 1}',
        avatarUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
        imageUrl: 'https://picsum.photos/400/600?random=$index',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: ListView.builder(
        itemCount: _postServices.posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return StoriesList(stories: _stories);
          }
          final post = _postServices.posts[index - 1];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: PostWidget(post: post),
          );
        },
      ),
    );
  }
}
