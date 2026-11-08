import 'package:flutter/material.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';

class StoryWidget extends StatelessWidget {

  final StoryModel story;

  const StoryWidget({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.pink,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.network(
                story.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          story.name,
          style: const TextStyle(fontSize: 12),
        ),

      ],
    );
  }
}