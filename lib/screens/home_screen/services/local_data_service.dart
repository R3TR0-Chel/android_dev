import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/db/database_provider.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

/// Local persistence API for posts, likes, comments and profiles.
/// Every read is a drift watch() stream, so the UI updates after each write.
class LocalDataService {
  LocalDataService(this._db);

  final AppDatabase _db;

  /// Feed for [userId]: author, like/comment counts, and whether this user
  /// liked each post, computed from the Likes and Comments tables.
  Stream<List<PostModel>> watchFeed(int userId) {
    return _db.customSelect(
      '''
      SELECT p.id, p.image_url, p.caption, p.author_id, u.username,
        (SELECT COUNT(*) FROM likes WHERE post_id = p.id) AS like_count,
        (SELECT COUNT(*) FROM comments WHERE post_id = p.id) AS comment_count,
        EXISTS(SELECT 1 FROM likes WHERE post_id = p.id AND user_id = ?) AS is_liked
      FROM posts p JOIN users u ON u.id = p.author_id
      ORDER BY p.created_at DESC, p.id DESC
      ''',
      variables: [Variable.withInt(userId)],
      readsFrom: {_db.posts, _db.users, _db.likes, _db.comments},
    ).watch().map((rows) => rows
        .map((row) => PostModel(
              id: row.read<int>('id'),
              imageUrl: row.read<String>('image_url'),
              description: row.read<String>('caption'),
              authorId: row.read<int>('author_id'),
              authorName: row.read<String>('username'),
              likeCount: row.read<int>('like_count'),
              commentCount: row.read<int>('comment_count'),
              isLiked: row.read<bool>('is_liked'),
            ))
        .toList());
  }

  Future<void> createPost({
    required int userId,
    required String imageUrl,
    required String caption,
  }) =>
      _db.into(_db.posts).insert(PostsCompanion.insert(
            authorId: userId,
            imageUrl: imageUrl,
            caption: caption,
          ));

  /// Removes the like if it exists, otherwise adds it.
  Future<void> toggleLike({required int userId, required int postId}) =>
      _db.transaction(() async {
        final removed = await (_db.delete(_db.likes)
              ..where((l) => l.userId.equals(userId) & l.postId.equals(postId)))
            .go();
        if (removed == 0) {
          await _db
              .into(_db.likes)
              .insert(LikesCompanion.insert(userId: userId, postId: postId));
        }
      });

  Stream<List<CommentModel>> watchComments(int postId) {
    final query = _db.select(_db.comments).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.comments.userId)),
    ])
      ..where(_db.comments.postId.equals(postId))
      ..orderBy([
        OrderingTerm.asc(_db.comments.createdAt),
        OrderingTerm.asc(_db.comments.id),
      ]);
    return query.watch().map((rows) => rows.map((row) {
          final comment = row.readTable(_db.comments);
          return CommentModel(
            id: comment.id,
            authorName: row.readTable(_db.users).username,
            body: comment.body,
            createdAt: comment.createdAt,
          );
        }).toList());
  }

  Future<void> addComment({
    required int userId,
    required int postId,
    required String body,
  }) =>
      _db.into(_db.comments).insert(
          CommentsCompanion.insert(postId: postId, userId: userId, body: body));

  Future<void> updateProfile({
    required int userId,
    String? avatarUrl,
    required String bio,
  }) =>
      (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
          UsersCompanion(avatarUrl: Value(avatarUrl), bio: Value(bio)));
}

final localDataServiceProvider = Provider<LocalDataService>(
  (ref) => LocalDataService(ref.watch(databaseProvider)),
);
