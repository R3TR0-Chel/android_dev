import "package:android_dev/providers/feed_provider.dart";
import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/widgets/comment_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

// No local state any more: likes and comments live in feedProvider.
// ConsumerWidget is a StatelessWidget that also gets a `ref`.
class PostWidget extends ConsumerWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  void openBottomSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        // Consumer rebuilds the sheet whenever feedProvider changes,
        // e.g. right after a comment is added.
        return Consumer(
          builder: (context, ref, _) {
            ref.watch(feedProvider);
            final comments = post.comments;

            void send() {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              ref.read(feedProvider.notifier).addComment(
                    post,
                    CommentModel(
                      username: 'you',
                      avatarUrl: 'https://i.pravatar.cc/150?img=68',
                      text: text,
                    ),
                  );
              controller.clear();
            }

            return Padding(
              // Push the sheet above the keyboard.
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Comments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: comments.isEmpty
                          ? const Center(child: Text('No comments yet'))
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) =>
                                  CommentWidget(comment: comments[index]),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (_) => send(),
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: send,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              post.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : null,
                ),
                // ref.read: we only call a method, we don't need to rebuild.
                onPressed: () =>
                    ref.read(feedProvider.notifier).toggleLike(post),
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () => openBottomSheet(context),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${post.likeCount ?? 0} likes',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              post.description ?? '',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
