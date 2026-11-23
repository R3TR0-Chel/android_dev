import 'package:android_dev/core/auth/auth_service.dart';
import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/screens/home_screen/services/local_data_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late AuthService auth;
  late LocalDataService data;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    auth = AuthService(db);
    data = LocalDataService(db);
  });
  tearDown(() => db.close());

  test('register, logout, login', () async {
    await auth.register('Akylbek', 'secret1');
    final me = await auth.watchCurrentUser().first;
    expect(me!.username, 'akylbek');
    expect(me.passwordHash, isNot('secret1'));

    await expectLater(() => auth.register('akylbek', 'other12'),
        throwsA(isA<AuthException>()));

    await auth.logout();
    expect(await auth.watchCurrentUser().first, isNull);

    await expectLater(() => auth.login('akylbek', 'wrong!!'),
        throwsA(isA<AuthException>()));
    await expectLater(() => auth.login('aida.k', '!'), throwsA(isA<AuthException>()));

    await auth.login('akylbek', 'secret1');
    expect((await auth.watchCurrentUser().first)!.id, me.id);
  });

  test('likes and comments are stored per user', () async {
    await auth.register('akylbek', 'secret1');
    final me = (await auth.watchCurrentUser().first)!;
    final post = (await data.watchFeed(me.id).first).first;
    expect(post.isLiked, isFalse);

    await data.toggleLike(userId: me.id, postId: post.id);
    var after = (await data.watchFeed(me.id).first).first;
    expect(after.isLiked, isTrue);
    expect(after.likeCount, post.likeCount + 1);

    // Another user sees the count but not as their own like.
    final other = (await data.watchFeed(1).first).first;
    expect(other.likeCount, post.likeCount + 1);
    expect(other.isLiked, isFalse);

    await data.toggleLike(userId: me.id, postId: post.id);
    after = (await data.watchFeed(me.id).first).first;
    expect(after.likeCount, post.likeCount);

    await data.addComment(userId: me.id, postId: post.id, body: 'hi');
    final comments = await data.watchComments(post.id).first;
    expect(comments.last.authorName, 'akylbek');
    expect(comments.last.body, 'hi');
    expect((await data.watchFeed(me.id).first).first.commentCount,
        post.commentCount + 1);
  });
}
