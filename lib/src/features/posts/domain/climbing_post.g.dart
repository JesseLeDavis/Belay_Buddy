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
          PostType.partnerRequest,
      needsBelay: json['needsBelay'] as bool? ?? false,
      offeringBelay: json['offeringBelay'] as bool? ?? false,
      partnerNeedType: $enumDecodeNullable(
              _$PartnerNeedTypeEnumMap, json['partnerNeedType']) ??
          PartnerNeedType.belay,
      gradeRange: json['gradeRange'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isExpired: json['isExpired'] as bool? ?? false,
      respondentIds: (json['respondentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      climbingLevel: json['climbingLevel'] as String?,
      climbingGoals: (json['climbingGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lostFoundStatus: $enumDecodeNullable(
          _$LostFoundStatusEnumMap, json['lostFoundStatus']),
      lostFoundCategory: $enumDecodeNullable(
          _$LostFoundCategoryEnumMap, json['lostFoundCategory']),
      itemName: json['itemName'] as String?,
      locationNote: json['locationNote'] as String?,
      isResolved: json['isResolved'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
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
      'partnerNeedType': _$PartnerNeedTypeEnumMap[instance.partnerNeedType]!,
      'gradeRange': instance.gradeRange,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isExpired': instance.isExpired,
      'respondentIds': instance.respondentIds,
      'climbingLevel': instance.climbingLevel,
      'climbingGoals': instance.climbingGoals,
      'lostFoundStatus': _$LostFoundStatusEnumMap[instance.lostFoundStatus],
      'lostFoundCategory':
          _$LostFoundCategoryEnumMap[instance.lostFoundCategory],
      'itemName': instance.itemName,
      'locationNote': instance.locationNote,
      'isResolved': instance.isResolved,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$PostTypeEnumMap = {
  PostType.introduction: 'introduction',
  PostType.partnerRequest: 'partnerRequest',
  PostType.lostFound: 'lostFound',
};

const _$PartnerNeedTypeEnumMap = {
  PartnerNeedType.belay: 'belay',
  PartnerNeedType.ropedPartner: 'ropedPartner',
  PartnerNeedType.boulderingBuddy: 'boulderingBuddy',
};

const _$LostFoundStatusEnumMap = {
  LostFoundStatus.lost: 'lost',
  LostFoundStatus.found: 'found',
};

const _$LostFoundCategoryEnumMap = {
  LostFoundCategory.gear: 'gear',
  LostFoundCategory.clothing: 'clothing',
  LostFoundCategory.personalItem: 'personalItem',
  LostFoundCategory.rope: 'rope',
  LostFoundCategory.other: 'other',
};
