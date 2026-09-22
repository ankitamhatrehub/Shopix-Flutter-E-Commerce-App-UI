import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_notification.dart';
import '../services/database_service.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class SqliteNotificationRepository implements NotificationRepository {
  final DatabaseService _db = DatabaseService.instance;

  @override
  Future<List<AppNotification>> getNotifications() => _db.getNotifications();

  @override
  Future<void> markAsRead(String id) => _db.markNotificationAsRead(id);

  @override
  Future<void> markAllAsRead() => _db.markAllNotificationsAsRead();
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return SqliteNotificationRepository();
});

