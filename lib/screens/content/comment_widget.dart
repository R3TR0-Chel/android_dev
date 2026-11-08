import 'package:flutter/material.dart';
import 'package:android_dev/screens/home_screen/models/comment_model.dart';

class CommentWidget extends StatelessWidget {

  final CommentModel comment;

  const CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: comment.imageUrl != null
                  ? Image.network(
                      comment.imageUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  comment.name ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  comment.description ?? '',
                ),

              ],
            ),
          ),

          Row(
            children: [
              const Icon(
                Icons.favorite_border,
                size: 18,
              ),

              const SizedBox(width: 3),

              Text(
                '${comment.likeCount ?? 0}',
              ),
            ],
          ),

        ],
      ),
    );
  }
}