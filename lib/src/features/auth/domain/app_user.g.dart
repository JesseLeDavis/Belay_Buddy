// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      experienceLevel: $enumDecodeNullable(
              _$ExperienceLevelEnumMap, json['experienceLevel']) ??
          ExperienceLevel.intermediate,
      climbingTags: (json['climbingTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      favoriteCragIds: (json['favoriteCragIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      favoriteGymIds: (json['favoriteGymIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      connectionIds: (json['connectionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pendingConnectionIds: (json['pendingConnectionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      homeGymId: json['homeGymId'] as String?,
      homeCragId: json['homeCragId'] as String?,
      isHomeVisible: json['isHomeVisible'] as bool? ?? true,
      notifyHomeCatch: json['notifyHomeCatch'] as bool? ?? true,
      notifyHomeConnections: json['notifyHomeConnections'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
      'climbingTags': instance.climbingTags,
      'favoriteCragIds': instance.favoriteCragIds,
      'favoriteGymIds': instance.favoriteGymIds,
      'connectionIds': instance.connectionIds,
      'pendingConnectionIds': instance.pendingConnectionIds,
      'homeGymId': instance.homeGymId,
      'homeCragId': instance.homeCragId,
      'isHomeVisible': instance.isHomeVisible,
      'notifyHomeCatch': instance.notifyHomeCatch,
      'notifyHomeConnections': instance.notifyHomeConnections,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
    };

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
  ExperienceLevel.expert: 'expert',
};
