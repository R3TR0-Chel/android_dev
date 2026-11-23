import 'dart:convert';
import 'dart:math';

import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/db/database_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

// ponytail: salted SHA-256 is fine for a local demo; a real backend should
// use bcrypt/argon2 and keep passwords off the device.
String hashPassword(String password, String salt) =>
    sha256.convert(utf8.encode('$salt:$password')).toString();

String _newSalt() => base64Url
    .encode(List.generate(16, (_) => Random.secure().nextInt(256)));

/// Registration, login and logout. The session lives in the Sessions table,
/// so the app stays logged in after a restart.
class AuthService {
  AuthService(this._db);
  final AppDatabase _db;

  Stream<User?> watchCurrentUser() {
    final query = _db.select(_db.sessions).join([
      innerJoin(_db.users, _db.users.id.equalsExp(_db.sessions.userId)),
    ]);
    return query.watchSingleOrNull().map((row) => row?.readTable(_db.users));
  }

  Future<void> register(String username, String password) async {
    final name = username.trim().toLowerCase();
    if (!RegExp(r'^[a-z0-9._]{3,30}$').hasMatch(name)) {
      throw AuthException(
          'Username: 3–30 characters, letters, digits, "." or "_".');
    }
    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters.');
    }
    if (await _findUser(name) != null) {
      throw AuthException('This username is already taken.');
    }
    final salt = _newSalt();
    final id = await _db.into(_db.users).insert(UsersCompanion.insert(
          username: name,
          passwordHash: hashPassword(password, salt),
          salt: salt,
        ));
    await _startSession(id);
  }

  Future<void> login(String username, String password) async {
    final user = await _findUser(username.trim().toLowerCase());
    // Same message for both cases so nobody can probe which usernames exist.
    if (user == null || user.passwordHash != hashPassword(password, user.salt)) {
      throw AuthException('Wrong username or password.');
    }
    await _startSession(user.id);
  }

  Future<void> logout() => _db.delete(_db.sessions).go();

  Future<User?> _findUser(String name) =>
      (_db.select(_db.users)..where((u) => u.username.equals(name)))
          .getSingleOrNull();

  Future<void> _startSession(int userId) => _db.transaction(() async {
        await _db.delete(_db.sessions).go();
        await _db.into(_db.sessions).insert(SessionsCompanion(userId: Value(userId)));
      });
}

final authServiceProvider =
    Provider<AuthService>((ref) => AuthService(ref.watch(databaseProvider)));

/// The signed-in user, or null. Rebuilds everything that watches it on
/// login, logout and profile edits.
final currentUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).watchCurrentUser(),
);
