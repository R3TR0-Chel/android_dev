import 'package:android_dev/screens/content/like_digest_sheet.dart';
import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:android_dev/screens/home_screen/services/local_data_service.dart';
import 'package:android_dev/core/db/app_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentProfileProvider = StreamProvider<UserProfile?>(
  (ref) => ref.watch(localDataServiceProvider).watchProfile('me'),
);

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedPostsProvider);
    final profile = ref.watch(currentProfileProvider).asData?.value;
    final nickname = profile?.nickname ?? 'alimhan';
    final avatarUrl = profile?.avatarUrl;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfile(context, ref, nickname, avatarUrl),
          ),
          IconButton(onPressed: () => LikesDigestSheet.show(context), icon: Icon(Icons.notifications_rounded))
        ],
      ),
      body: posts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load profile: $error')),
        data: (allPosts) {
          final ownPosts =
              allPosts.where((post) => post.authorId == 'me').toList();
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
    String nickname,
    String? avatarUrl,
  ) async {
    final nameController = TextEditingController(text: nickname);
    final imageController = TextEditingController(text: avatarUrl ?? '');
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
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
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final image = imageController.text.trim();
              await ref.read(localDataServiceProvider).saveProfile(
                    UserProfilesCompanion.insert(
                      id: 'me',
                      nickname: name,
                      avatarUrl: Value(image.isEmpty ? null : image),
                    ),
                  );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    nameController.dispose();
    imageController.dispose();
  }
}
