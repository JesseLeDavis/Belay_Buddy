import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/notifications/domain/climbing_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All notifications for the current user.
final notificationsProvider =
    StreamProvider<List<ClimbingNotification>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getNotificationsForUser(userId));
});

/// Unread notification count (used for badge).
final unreadNotificationCountProvider = Provider<int>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return 0;
  return MockData.getUnreadNotificationCount(userId);
});
