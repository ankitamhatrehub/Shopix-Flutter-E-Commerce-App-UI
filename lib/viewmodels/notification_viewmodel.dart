import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/app_notification.dart';
import '../repositories/notification_repository.dart';

class NotificationState {
  final List<AppNotification> notifications;
  final bool isLoading;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NotificationViewModel extends StateNotifier<NotificationState> {
  final NotificationRepository _repo;

  NotificationViewModel(this._repo) : super(const NotificationState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    final list = await _repo.getNotifications();
    state = state.copyWith(notifications: list, isLoading: false);
  }

  Future<void> markAsRead(String id) async {
    await _repo.markAsRead(id);
    final updated = state.notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead();
    final updated =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updated);
  }
}

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationViewModel(repo);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationViewModelProvider).unreadCount;
});

