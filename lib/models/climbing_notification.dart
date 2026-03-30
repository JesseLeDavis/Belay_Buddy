import 'package:freezed_annotation/freezed_annotation.dart';

part 'climbing_notification.freezed.dart';
part 'climbing_notification.g.dart';

enum NotificationType {
  catchNeeded,       // A connection posted they need a belay/catch
  connectionRequest, // Someone wants to connect with you
  connectionAccepted, // Your connection request was accepted
}

@freezed
class ClimbingNotification with _$ClimbingNotification {
  const factory ClimbingNotification({
    required String id,
    required String toUserId,
    required String fromUserId,
    required String fromUserName,
    required NotificationType type,
    String? postId,
    String? cragId,
    String? cragName,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _ClimbingNotification;

  factory ClimbingNotification.fromJson(Map<String, dynamic> json) =>
      _$ClimbingNotificationFromJson(json);
}
