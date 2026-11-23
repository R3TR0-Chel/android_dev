import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:android_dev/screens/home_screen/services/local_data_service.dart';
import 'package:android_dev/core/auth/auth_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);
    // AuthGate only shows this tab while someone is signed in.
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return const SizedBox.shrink();
    final nickname = user.username;
    final avatarUrl = user.avatarUrl;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                _showEditProfile(context, ref, user.id, user.bio, avatarUrl),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => ref.read(authServiceProvider).logout(),
          ),
        ],
      ),
      body: posts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load profile: $error')),
        data: (allPosts) {
          final ownPosts =
              allPosts.where((post) => post.authorId == user.id).toList();
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                        ? null
                        : NetworkImage(avatarUrl),
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? Text(nickname.isEmpty ? 'A' : nickname[0].toUpperCase(),
                            style: const TextStyle(fontSize: 32))
                        : null,
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nickname,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        if (user.bio.isNotEmpty) Text(user.bio),
                        const SizedBox(height: 10),
                        Text('${ownPosts.length} posts'),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
                child:
                    Text('Posts', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SliverGrid.builder(
              itemCount: ownPosts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemBuilder: (context, index) => Image.network(
                ownPosts[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ]);
        },
      ),
    );
  }

  Future<void> _showEditProfile(
    BuildContext context,
    WidgetRef ref,
    int userId,
    String bio,
    String? avatarUrl,
  ) async {
    final bioController = TextEditingController(text: bio);
    final imageController = TextEditingController(text: avatarUrl ?? '');
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            TextField(
              controller: imageController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'Profile picture URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final image = imageController.text.trim();
              await ref.read(localDataServiceProvider).updateProfile(
                    userId: userId,
                    bio: bioController.text.trim(),
                    avatarUrl: image.isEmpty ? null : image,
                  );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    bioController.dispose();
    imageController.dispose();
  }
}
