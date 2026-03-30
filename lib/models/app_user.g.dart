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
      climbingStyles: (json['climbingStyles'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ClimbingStyleEnumMap, e))
              .toList() ??
          const [ClimbingStyle.all],
      favoriteCragIds: (json['favoriteCragIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      'climbingStyles': instance.climbingStyles
          .map((e) => _$ClimbingStyleEnumMap[e]!)
          .toList(),
      'favoriteCragIds': instance.favoriteCragIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
    };

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
  ExperienceLevel.expert: 'expert',
};

const _$ClimbingStyleEnumMap = {
  ClimbingStyle.sport: 'sport',
  ClimbingStyle.trad: 'trad',
  ClimbingStyle.boulder: 'boulder',
  ClimbingStyle.all: 'all',
};
