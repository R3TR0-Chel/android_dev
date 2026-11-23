import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Schema v2: normalized tables linked with foreign keys.
// Likes and comments are their own rows (who, which post, when) instead of a
// counter on the post, so counts and "did I like it" are computed per user.

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 30).unique()();
  TextColumn get passwordHash => text()();
  TextColumn get salt => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get bio => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Posts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get authorId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get imageUrl => text()();
  TextColumn get caption => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Likes extends Table {
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  IntColumn get postId =>
      integer().references(Posts, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // One like per user per post, enforced by the database.
  @override
  Set<Column<Object>> get primaryKey => {userId, postId};
}

class Comments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get postId =>
      integer().references(Posts, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get body => text().withLength(min: 1, max: 500)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// The signed-in user. Zero rows = logged out, one row = logged in.
class Sessions extends Table {
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

@DriftDatabase(tables: [Users, Posts, Likes, Comments, Sessions])
class AppDatabase extends _$AppDatabase {
  // Tests pass NativeDatabase.memory(); the app uses a file on the device.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'social_app'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seed();
        },
        onUpgrade: (m, from, to) async {
          // v1 only held demo data, so replace its tables with the new schema.
          for (final old in ['cached_posts', 'user_profiles', 'post_comments']) {
            await customStatement('DROP TABLE IF EXISTS $old');
          }
          await m.createAll();
          await _seed();
        },
        // SQLite ignores REFERENCES unless this is switched on.
        beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
      );

  // Demo authors so the feed isn't empty. Their password hash '!' can never
  // match a real hash, so nobody can log in as them.
  Future<void> _seed() async {
    const authors = [
      ('aida.k', 1),
      ('timur_dev', 3),
      ('dana.travels', 16),
    ];
    const posts = [
      (0, '1507525428034-b723cf961d3e', 'Issyk-Kul in July never disappoints 🌊'),
      (1, '1517694712202-14dd9538aa97', 'First Flutter app running on a real device 🚀'),
      (2, '1464822759023-fed622ff2c3b', 'Ala-Archa trail, 14 km round trip. Legs are gone.'),
      (0, '1495474472287-4d71bcdd2085', 'Monday fuel ☕'),
      (2, '1519681393784-d120267933ba', 'Bishkek lights after the rain.'),
      (1, '1543466835-00a7907e9de1', 'Meet Bars, the newest member of our family 🐶'),
    ];
    final ids = <int>[];
    for (final (name, avatar) in authors) {
      ids.add(await into(users).insert(UsersCompanion.insert(
        username: name,
        passwordHash: '!',
        salt: '',
        avatarUrl: Value('https://i.pravatar.cc/150?img=$avatar'),
      )));
    }
    for (final (i, (author, photo, caption)) in posts.indexed) {
      final postId = await into(this.posts).insert(PostsCompanion.insert(
        authorId: ids[author],
        imageUrl: 'https://images.unsplash.com/photo-$photo?w=600&h=600&fit=crop',
        caption: caption,
        createdAt: Value(DateTime(2026, 11, 1 + i)),
      ));
      await into(likes).insert(
          LikesCompanion.insert(userId: ids[(author + 1) % 3], postId: postId));
      await into(comments).insert(CommentsCompanion.insert(
        postId: postId,
        userId: ids[(author + 2) % 3],
        body: 'Love this!',
      ));
    }
  }
}
