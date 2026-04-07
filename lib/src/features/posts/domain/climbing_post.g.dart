// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climbing_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClimbingPostImpl _$$ClimbingPostImplFromJson(Map<String, dynamic> json) =>
    _$ClimbingPostImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cragId: json['cragId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dateTime: DateTime.parse(json['dateTime'] as String),
      type: $enumDecodeNullable(_$PostTypeEnumMap, json['type']) ??
          PostType.scheduled,
      needsBelay: json['needsBelay'] as bool? ?? false,
      offeringBelay: json['offeringBelay'] as bool? ?? false,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      isExpired: json['isExpired'] as bool? ?? false,
    );

Map<String, dynamic> _$$ClimbingPostImplToJson(_$ClimbingPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'cragId': instance.cragId,
      'title': instance.title,
      'description': instance.description,
      'dateTime': instance.dateTime.toIso8601String(),
      'type': _$PostTypeEnumMap[instance.type]!,
      'needsBelay': instance.needsBelay,
      'offeringBelay': instance.offeringBelay,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'isExpired': instance.isExpired,
    };

const _$PostTypeEnumMap = {
  PostType.immediate: 'immediate',
  PostType.scheduled: 'scheduled',
};
