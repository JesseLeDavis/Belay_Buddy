// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_found_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LostFoundItemImpl _$$LostFoundItemImplFromJson(Map<String, dynamic> json) =>
    _$LostFoundItemImpl(
      id: json['id'] as String,
      cragId: json['cragId'] as String,
      userId: json['userId'] as String,
      status: $enumDecode(_$LostFoundStatusEnumMap, json['status']),
      category: $enumDecode(_$LostFoundCategoryEnumMap, json['category']),
      itemName: json['itemName'] as String,
      description: json['description'] as String?,
      locationNote: json['locationNote'] as String?,
      isResolved: json['isResolved'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$LostFoundItemImplToJson(_$LostFoundItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cragId': instance.cragId,
      'userId': instance.userId,
      'status': _$LostFoundStatusEnumMap[instance.status]!,
      'category': _$LostFoundCategoryEnumMap[instance.category]!,
      'itemName': instance.itemName,
      'description': instance.description,
      'locationNote': instance.locationNote,
      'isResolved': instance.isResolved,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$LostFoundStatusEnumMap = {
  LostFoundStatus.found: 'found',
  LostFoundStatus.lost: 'lost',
};

const _$LostFoundCategoryEnumMap = {
  LostFoundCategory.gear: 'gear',
  LostFoundCategory.clothing: 'clothing',
  LostFoundCategory.personalItem: 'personalItem',
  LostFoundCategory.rope: 'rope',
  LostFoundCategory.other: 'other',
};
