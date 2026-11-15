import "package:android_dev/screens/home_screen/models/comment_model.dart";
import "package:android_dev/screens/home_screen/models/post_model.dart";
import "package:android_dev/screens/home_screen/widgets/comment_widget.dart";
import "package:flutter/material.dart";

class PostWidget extends StatefulWidget {
  final PostModel? post;
  const PostWidget({super.key,required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final bool isLiked = false; 
 // This should ideally be managed by state management

 void openBottomSheet() {
    final comments = widget.post?.comments ?? [];
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        // StatefulBuilder lets the sheet redraw when a comment is added.
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void send() {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              setSheetState(() {
                widget.post?.addComment(CommentModel(
                  username: 'you',
                  avatarUrl: 'https://i.pravatar.cc/150?img=68',
                  text: text,
                ));
              });
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
          Text(
            widget.post?.description ?? '',
            style: const TextStyle(fontSize: 16.0),
          ),

        ],)

    );
  }
}