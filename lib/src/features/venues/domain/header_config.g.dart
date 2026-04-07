// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HeaderPanelImpl _$$HeaderPanelImplFromJson(Map<String, dynamic> json) =>
    _$HeaderPanelImpl(
      index: (json['index'] as num).toInt(),
      assetUrl: json['assetUrl'] as String?,
      slideDelay: (json['slideDelay'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$HeaderPanelImplToJson(_$HeaderPanelImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'assetUrl': instance.assetUrl,
      'slideDelay': instance.slideDelay,
    };

_$HeaderConfigImpl _$$HeaderConfigImplFromJson(Map<String, dynamic> json) =>
    _$HeaderConfigImpl(
      cragId: json['cragId'] as String,
      panels: (json['panels'] as List<dynamic>?)
              ?.map((e) => HeaderPanel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$HeaderConfigImplToJson(_$HeaderConfigImpl instance) =>
    <String, dynamic>{
      'cragId': instance.cragId,
      'panels': instance.panels,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };
