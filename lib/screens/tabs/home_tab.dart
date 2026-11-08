import "package:android_dev/screens/content/post_widget.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart";
import "package:flutter/material.dart";
import 'package:android_dev/screens/content/story_widget.dart';
import 'package:android_dev/screens/home_screen/models/story_model.dart';
import 'package:android_dev/screens/home_screen/data/sample_posts.dart';

class HomeTab extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    PostServices postServices = PostServices();
    postServices.stories.addAll([
      StoryModel(
        name: 'Anna',
        imageUrl: 'https://picsum.photos/seed/anna/200',
      ),
      StoryModel(
        name: 'Maria',
        imageUrl: 'https://picsum.photos/seed/maria/200',
      ),
      StoryModel(
        name: 'Alex',
        imageUrl: 'https://picsum.photos/seed/alex/200',
      ),
      StoryModel(
        name: 'John',
        imageUrl: 'https://picsum.photos/seed/john/200',
      ),
      StoryModel(
        name: 'Kate',
        imageUrl: 'https://picsum.photos/seed/kate/200',
      ),
      StoryModel(
        name: 'David',
        imageUrl: 'https://picsum.photos/seed/david/200',
      ),
    ]);
    postServices.batchAddPosts(samplePosts);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: Column(
        children: [

          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: postServices.stories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoryWidget(
                    story: postServices.stories[index],
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: postServices.posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: PostWidget(
                    post: postServices.posts[index],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
