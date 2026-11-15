import 'package:android_dev/providers/posts_provider.dart';
import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/widgets/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWidget extends ConsumerStatefulWidget {
  final PostModel? post;

  const PostWidget({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  bool isLiked = false;

  Future<void> openBottomSheet() async {
    final post = widget.post;

    if (post == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return CommentsBottomSheet(
          post: post,
          onSubmit: (text) {
            final posts = ref.read(postsProvider);
            final index = posts.indexOf(post);

            if (index == -1) return;

            ref.read(postsProvider.notifier).commentOnPost(
                  index,
                  text,
                );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    if (post == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                );
              },
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  final posts = ref.read(postsProvider);
                  final index = posts.indexOf(post);

                  if (index == -1) return;

                  ref.read(postsProvider.notifier).toggleLike(
                        index,
                        isLiked,
                      );

                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: openBottomSheet,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            child: Text(
              '${post.likeCount} likes',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (post.description != null &&
              post.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(
                post.description!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class CommentsBottomSheet extends StatefulWidget {
  final PostModel post;
  final ValueChanged<String> onSubmit;

  const CommentsBottomSheet({
    super.key,
    required this.post,
    required this.onSubmit,
  });

  @override
  State<CommentsBottomSheet> createState() =>
      _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendComment() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    widget.onSubmit(text);

    setState(() {
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: (screenHeight - bottomInset) * 0.65,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: widget.post.comments.isEmpty
                  ? const Center(
                      child: Text('No comments yet.'),
                    )
                  : ListView.builder(
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) {
                        return CommentWidget(
                          comment: widget.post.comments[index],
                        );
                      },
                    ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: sendComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}