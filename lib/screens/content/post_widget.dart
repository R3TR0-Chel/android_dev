import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:flutter/material.dart"; 

import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/services/post_services.dart"; 
import 'package:android_dev/screens/content/comment_widget.dart';

class PostWidget extends StatefulWidget {
  final PostModel? post;
  const PostWidget({super.key,required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final bool isLiked = false; 
 // This should ideally be managed by state management

  void openBottomSheet() async {

    final post = widget.post;

    if (post == null) return;

    final TextEditingController commentController =
        TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (context, setModalState) {

            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,

                child: Column(
                  children: [

                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: post.comments.length,

                        itemBuilder: (context, index) {
                          return CommentWidget(
                            comment: post.comments[index],
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),

                      child: Row(
                        children: [

                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                hintText: 'Write a comment...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.send),

                            onPressed: () {

                              final text =
                                  commentController.text.trim();

                              if (text.isEmpty) return;

                              post.addComment(
                                CommentModel(
                                  name: 'You',
                                  description: text,
                                  likeCount: 0,
                                ),
                              );

                              commentController.clear();

                              setModalState(() {});

                              setState(() {});
                            },
                          ),

                        ],
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

    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.post?.imageUrl ?? 'https://via.placeholder.com/150',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    // This should ideally update the like count in a state management solution
                    if (isLiked) {
                      widget.post?.addLike((widget.post?.likeCount ?? 1) - 1);
                    } else {
                      widget.post?.addLike((widget.post?.likeCount ?? 0) + 1);
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  openBottomSheet();
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ), 
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                  '${widget.post?.commentCount ?? 0} comments',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
              ),
            ),
          ),
          Text(
            widget.post?.description ?? '',
            style: const TextStyle(fontSize: 16.0),
          ),

        ],)

    );
  }
}