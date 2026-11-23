import 'package:android_dev/screens/content/post_widget.dart';
import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _stories = [
  ('Your story', null),
  ('Maya', 'https://i.pravatar.cc/160?img=47'),
  ('Noah', 'https://i.pravatar.cc/160?img=11'),
  ('Sofia', 'https://i.pravatar.cc/160?img=32'),
  ('Leo', 'https://i.pravatar.cc/160?img=59'),
  ('Aisha', 'https://i.pravatar.cc/160?img=5'),
];

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text('Instagram')),
      body: posts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load posts: $error')),
        data: (items) => Column(
          children: [
            const _StoriesList(),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('No posts yet. Create your first post.'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: PostWidget(
                          post: items[index],
                          onLike: () => ref.read(feedControllerProvider).toggleLike(items[index].id),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoriesList extends StatelessWidget {
  const _StoriesList();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 108,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          scrollDirection: Axis.horizontal,
          itemCount: _stories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final story = _stories[index];
            final isOwnStory = story.$2 == null;
            return SizedBox(
              width: 68,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isOwnStory
                          ? null
                          : const LinearGradient(colors: [Colors.purple, Colors.orange]),
                    ),
                    child: CircleAvatar(
                      radius: 29,
                      backgroundColor: Colors.white,
                      backgroundImage: story.$2 == null ? null : NetworkImage(story.$2!),
                      child: isOwnStory
                          ? const Icon(Icons.add, color: Colors.black)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(story.$1, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        ),
      );
}
