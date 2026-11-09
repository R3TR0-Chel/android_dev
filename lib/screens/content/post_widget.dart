import 'package:android_dev/screens/home_screen/models/post_model.dart';
import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/widgets/comment_widget.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final PostModel? post;

  const PostWidget({
    super.key,
    required this.post,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;

  Future<void> openBottomSheet() async {
    final post = widget.post;

    if (post == null) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) => _CommentsSheet(post: post),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              widget.post?.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 200,
                child: Center(
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
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
                  setState(() {
                    if (isLiked) {
                      widget.post?.addLike(
                        (widget.post?.likeCount ?? 1) - 1,
                      );
                      isLiked = false;
                    } else {
                      widget.post?.addLike(
                        (widget.post?.likeCount ?? 0) + 1,
                      );
                      isLiked = true;
                    }
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
          if (widget.post != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              child: Text(
                '${widget.post!.likeCount} likes',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.post?.description != null &&
              widget.post!.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(
                widget.post!.description!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final PostModel post;

  const _CommentsSheet({required this.post});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_isSubmitting) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future<void>.sync(() {
        widget.post.addCommentModel(
          CommentModel(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            username: 'kae0961',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
            text: text,
          ),
        );
      });

      if (!mounted) return;
      _controller.clear();
      _focusNode.requestFocus();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
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
                  ? const Center(child: Text('No comments yet.'))
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
                      controller: _controller,
                      focusNode: _focusNode,
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
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: _isSubmitting ? null : _submitComment,
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
