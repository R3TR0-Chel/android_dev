import 'package:flutter/material.dart';
import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:android_dev/widgets/avatar.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel comment;

  const CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            imageUrl: comment.avatarUrl,
            radius: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: '${comment.username} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: comment.text),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                comment.toggleLike();
              });
            },
            child: Column(
              children: [
                Icon(
                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: comment.isLiked ? Colors.red : Colors.grey,
                  size: 18,
                ),
                const SizedBox(height: 3),
                Text(
                  '${comment.likeCount}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
