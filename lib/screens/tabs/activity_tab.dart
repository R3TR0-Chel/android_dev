import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityTab extends ConsumerWidget {
  const ActivityTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: posts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load activity: $error')),
        data: (items) {
          final likedPosts = items.where((post) => post.isLiked).toList();
          return likedPosts.isEmpty
              ? const Center(child: Text('Posts you like will appear here.'))
              : ListView.builder(
                  itemCount: likedPosts.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Image.network(likedPosts[index].imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                    title: Text('You liked ${likedPosts[index].authorName}\'s post'),
                    subtitle: Text(likedPosts[index].description, maxLines: 1),
                  ),
                );
        },
      ),
    );
  }
}
