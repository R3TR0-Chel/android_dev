import 'package:android_dev/core/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_data_service.dart';
import '../models/post_model.dart';

// select: only re-run when the user id changes, not on every profile edit.
final _userIdProvider = Provider<int?>(
  (ref) => ref.watch(currentUserProvider.select((user) => user.value?.id)),
);

final feedPostsProvider = StreamProvider<List<PostModel>>((ref) {
  // 0 matches no user, so a logged-out feed shows nothing as liked.
  final userId = ref.watch(_userIdProvider) ?? 0;
  return ref.watch(localDataServiceProvider).watchFeed(userId);
});

/// Write actions for the signed-in user. Both the service and the user id
/// are injected, so widgets never pass user ids around.
class FeedController {
  FeedController(this._localData, this._userId);

  final LocalDataService _localData;
  final int? _userId;

  int get _signedInId =>
      _userId ?? (throw StateError('No user is signed in.'));

  Future<void> toggleLike(int postId) =>
      _localData.toggleLike(userId: _signedInId, postId: postId);

  Future<void> addComment(int postId, String body) =>
      _localData.addComment(userId: _signedInId, postId: postId, body: body);

  Future<void> createPost({required String imageUrl, required String caption}) =>
      _localData.createPost(
          userId: _signedInId, imageUrl: imageUrl, caption: caption);
}

final feedControllerProvider = Provider<FeedController>(
  (ref) => FeedController(
      ref.watch(localDataServiceProvider), ref.watch(_userIdProvider)),
);
