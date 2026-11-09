import 'package:flutter/material.dart';
import '../screens/home_screen/models/story_model.dart';
import 'story_widget.dart';

class StoriesList extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesList({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    final labelHeight = MediaQuery.textScalerOf(context).scale(12) * 1.5;

    return SizedBox(
      height: 66 + 5 + labelHeight + 18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StoryWidget(
              story: stories[index],
            ),
          );
        },
      ),
    );
  }
}
