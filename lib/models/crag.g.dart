// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CragLocationImpl _$$CragLocationImplFromJson(Map<String, dynamic> json) =>
    _$CragLocationImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$CragLocationImplToJson(_$CragLocationImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$CragImpl _$$CragImplFromJson(Map<String, dynamic> json) => _$CragImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      location: CragLocation.fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String?,
      types: (json['types'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CragTypeEnumMap, e))
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
      isGym: json['isGym'] as bool? ?? false,
      activeClimbersCount: (json['activeClimbersCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$CragImplToJson(_$CragImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'description': instance.description,
      'types': instance.types.map((e) => _$CragTypeEnumMap[e]!).toList(),
      'imageUrl': instance.imageUrl,
      'region': instance.region,
      'country': instance.country,
      'isGym': instance.isGym,
      'activeClimbersCount': instance.activeClimbersCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$CragTypeEnumMap = {
  CragType.sport: 'sport',
  CragType.trad: 'trad',
  CragType.boulder: 'boulder',
  CragType.mixed: 'mixed',
};
