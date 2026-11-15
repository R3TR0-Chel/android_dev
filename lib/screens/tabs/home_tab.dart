
import 'package:android_dev/screens/content/post_widget.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:android_dev/providers/posts_provider.dart';
import 'package:android_dev/widgets/stories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);

    final stories = [
      StoryModel(
        username: 'adelya',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        imageUrl: 'https://picsum.photos/400/600?random=1',
      ),
      StoryModel(
        username: 'asya',
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        imageUrl: 'https://picsum.photos/400/600?random=2',
      ),
      StoryModel(
        username: 'zara',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        imageUrl: 'https://picsum.photos/400/600?random=3',
      ),
      StoryModel(
        username: 'rahat',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        imageUrl: 'https://picsum.photos/400/600?random=4',
      ),
      StoryModel(
        username: 'begaim',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        imageUrl: 'https://picsum.photos/400/600?random=4',
      ),
      StoryModel(
        username: 'diana',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        imageUrl: 'https://picsum.photos/400/600?random=4',
      ),
      StoryModel(
        username: 'alima',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        imageUrl: 'https://picsum.photos/400/600?random=4',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: ListView.builder(
        itemCount: posts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return StoriesList(stories: stories);
          }

          final post = posts[index - 1];

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: PostWidget(post: post),
          );
        },
      ),
    );
  }
}
