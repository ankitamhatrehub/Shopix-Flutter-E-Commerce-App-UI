import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';

abstract class UserRepository {
  Future<UserProfile?> getUser();
  Future<void> saveUser(UserProfile user);
  Future<void> updateUserAvatar(String avatarPath);
}

class SqliteUserRepository implements UserRepository {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<UserProfile?> getUser() => _db.getUser();

  @override
  Future<void> saveUser(UserProfile user) => _db.saveUser(user);

  @override
  Future<void> updateUserAvatar(String avatarPath) =>
      _db.updateUserAvatar(avatarPath);
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return SqliteUserRepository();
});

