import 'package:android_dev/screens/home_screen/services/local_data_service.dart';
import 'package:android_dev/screens/home_screen/state/feed_controller.dart';
import 'package:android_dev/screens/home_screen/models/comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final commentsProvider = StreamProvider.autoDispose.family<List<CommentModel>, int>(
  (ref, postId) => ref.watch(localDataServiceProvider).watchComments(postId),
);

class CommentsSheet extends ConsumerStatefulWidget {
  const CommentsSheet({super.key, required this.postId});

  final int postId;

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _controller.text.trim();
    if (body.isEmpty) return;
    await ref.read(feedControllerProvider).addComment(widget.postId, body);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsProvider(widget.postId));
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .7,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Expanded(
              child: comments.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Could not load comments: $error')),
                data: (items) => items.isEmpty
                    ? const Center(child: Text('Be the first to comment.'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(items[index].authorName),
                          subtitle: Text(items[index].body),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                      decoration: const InputDecoration(hintText: 'Add a comment...'),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _submit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
