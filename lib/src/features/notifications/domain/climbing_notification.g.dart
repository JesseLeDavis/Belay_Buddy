// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climbing_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClimbingNotificationImpl _$$ClimbingNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$ClimbingNotificationImpl(
      id: json['id'] as String,
      toUserId: json['toUserId'] as String,
      fromUserId: json['fromUserId'] as String,
      fromUserName: json['fromUserName'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      postId: json['postId'] as String?,
      cragId: json['cragId'] as String?,
      cragName: json['cragName'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClimbingNotificationImplToJson(
        _$ClimbingNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'toUserId': instance.toUserId,
      'fromUserId': instance.fromUserId,
      'fromUserName': instance.fromUserName,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'postId': instance.postId,
      'cragId': instance.cragId,
      'cragName': instance.cragName,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.catchNeeded: 'catchNeeded',
  NotificationType.connectionRequest: 'connectionRequest',
  NotificationType.connectionAccepted: 'connectionAccepted',
};
