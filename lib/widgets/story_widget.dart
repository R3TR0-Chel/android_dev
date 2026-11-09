import 'package:flutter/material.dart';
import '../screens/home_screen/models/story_model.dart';
import 'avatar.dart';

class StoryWidget extends StatelessWidget {
  final StoryModel story;

  const StoryWidget({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
            child: Avatar(
              imageUrl: story.avatarUrl,
              radius: 30,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            story.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
