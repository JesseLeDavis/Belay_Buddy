// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'header_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HeaderPanel _$HeaderPanelFromJson(Map<String, dynamic> json) {
  return _HeaderPanel.fromJson(json);
}

/// @nodoc
mixin _$HeaderPanel {
  int get index => throw _privateConstructorUsedError; // 0-5, left to right
  String? get assetUrl =>
      throw _privateConstructorUsedError; // Firebase Storage download URL; null = use default
  double get slideDelay => throw _privateConstructorUsedError;

  /// Serializes this HeaderPanel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeaderPanel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeaderPanelCopyWith<HeaderPanel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeaderPanelCopyWith<$Res> {
  factory $HeaderPanelCopyWith(
          HeaderPanel value, $Res Function(HeaderPanel) then) =
      _$HeaderPanelCopyWithImpl<$Res, HeaderPanel>;
  @useResult
  $Res call({int index, String? assetUrl, double slideDelay});
}

/// @nodoc
class _$HeaderPanelCopyWithImpl<$Res, $Val extends HeaderPanel>
    implements $HeaderPanelCopyWith<$Res> {
  _$HeaderPanelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeaderPanel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? assetUrl = freezed,
    Object? slideDelay = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      assetUrl: freezed == assetUrl
          ? _value.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      slideDelay: null == slideDelay
          ? _value.slideDelay
          : slideDelay // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeaderPanelImplCopyWith<$Res>
    implements $HeaderPanelCopyWith<$Res> {
  factory _$$HeaderPanelImplCopyWith(
          _$HeaderPanelImpl value, $Res Function(_$HeaderPanelImpl) then) =
      __$$HeaderPanelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, String? assetUrl, double slideDelay});
}

/// @nodoc
class __$$HeaderPanelImplCopyWithImpl<$Res>
    extends _$HeaderPanelCopyWithImpl<$Res, _$HeaderPanelImpl>
    implements _$$HeaderPanelImplCopyWith<$Res> {
  __$$HeaderPanelImplCopyWithImpl(
      _$HeaderPanelImpl _value, $Res Function(_$HeaderPanelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeaderPanel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? assetUrl = freezed,
    Object? slideDelay = null,
  }) {
    return _then(_$HeaderPanelImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      assetUrl: freezed == assetUrl
          ? _value.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      slideDelay: null == slideDelay
          ? _value.slideDelay
          : slideDelay // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeaderPanelImpl implements _HeaderPanel {
  const _$HeaderPanelImpl(
      {required this.index, this.assetUrl, this.slideDelay = 0});

  factory _$HeaderPanelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderPanelImplFromJson(json);

  @override
  final int index;
// 0-5, left to right
  @override
  final String? assetUrl;
// Firebase Storage download URL; null = use default
  @override
  @JsonKey()
  final double slideDelay;

  @override
  String toString() {
    return 'HeaderPanel(index: $index, assetUrl: $assetUrl, slideDelay: $slideDelay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderPanelImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.slideDelay, slideDelay) ||
                other.slideDelay == slideDelay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, assetUrl, slideDelay);

  /// Create a copy of HeaderPanel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeaderPanelImplCopyWith<_$HeaderPanelImpl> get copyWith =>
      __$$HeaderPanelImplCopyWithImpl<_$HeaderPanelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeaderPanelImplToJson(
      this,
    );
  }
}

abstract class _HeaderPanel implements HeaderPanel {
  const factory _HeaderPanel(
      {required final int index,
      final String? assetUrl,
      final double slideDelay}) = _$HeaderPanelImpl;

  factory _HeaderPanel.fromJson(Map<String, dynamic> json) =
      _$HeaderPanelImpl.fromJson;

  @override
  int get index; // 0-5, left to right
  @override
  String? get assetUrl; // Firebase Storage download URL; null = use default
  @override
  double get slideDelay;

  /// Create a copy of HeaderPanel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeaderPanelImplCopyWith<_$HeaderPanelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeaderConfig _$HeaderConfigFromJson(Map<String, dynamic> json) {
  return _HeaderConfig.fromJson(json);
}

/// @nodoc
mixin _$HeaderConfig {
  String get cragId => throw _privateConstructorUsedError;
  List<HeaderPanel> get panels =>
      throw _privateConstructorUsedError; // exactly 6
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this HeaderConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeaderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeaderConfigCopyWith<HeaderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeaderConfigCopyWith<$Res> {
  factory $HeaderConfigCopyWith(
          HeaderConfig value, $Res Function(HeaderConfig) then) =
      _$HeaderConfigCopyWithImpl<$Res, HeaderConfig>;
  @useResult
  $Res call(
      {String cragId,
      List<HeaderPanel> panels,
      DateTime? updatedAt,
      String? updatedBy});
}

/// @nodoc
class _$HeaderConfigCopyWithImpl<$Res, $Val extends HeaderConfig>
    implements $HeaderConfigCopyWith<$Res> {
  _$HeaderConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeaderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cragId = null,
    Object? panels = null,
    Object? updatedAt = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      cragId: null == cragId
          ? _value.cragId
          : cragId // ignore: cast_nullable_to_non_nullable
              as String,
      panels: null == panels
          ? _value.panels
          : panels // ignore: cast_nullable_to_non_nullable
              as List<HeaderPanel>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeaderConfigImplCopyWith<$Res>
    implements $HeaderConfigCopyWith<$Res> {
  factory _$$HeaderConfigImplCopyWith(
          _$HeaderConfigImpl value, $Res Function(_$HeaderConfigImpl) then) =
      __$$HeaderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cragId,
      List<HeaderPanel> panels,
      DateTime? updatedAt,
      String? updatedBy});
}

/// @nodoc
class __$$HeaderConfigImplCopyWithImpl<$Res>
    extends _$HeaderConfigCopyWithImpl<$Res, _$HeaderConfigImpl>
    implements _$$HeaderConfigImplCopyWith<$Res> {
  __$$HeaderConfigImplCopyWithImpl(
      _$HeaderConfigImpl _value, $Res Function(_$HeaderConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeaderConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cragId = null,
    Object? panels = null,
    Object? updatedAt = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$HeaderConfigImpl(
      cragId: null == cragId
          ? _value.cragId
          : cragId // ignore: cast_nullable_to_non_nullable
              as String,
      panels: null == panels
          ? _value._panels
          : panels // ignore: cast_nullable_to_non_nullable
              as List<HeaderPanel>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeaderConfigImpl implements _HeaderConfig {
  const _$HeaderConfigImpl(
      {required this.cragId,
      final List<HeaderPanel> panels = const [],
      this.updatedAt,
      this.updatedBy})
      : _panels = panels;

  factory _$HeaderConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderConfigImplFromJson(json);

  @override
  final String cragId;
  final List<HeaderPanel> _panels;
  @override
  @JsonKey()
  List<HeaderPanel> get panels {
    if (_panels is EqualUnmodifiableListView) return _panels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_panels);
  }

// exactly 6
  @override
  final DateTime? updatedAt;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'HeaderConfig(cragId: $cragId, panels: $panels, updatedAt: $updatedAt, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderConfigImpl &&
            (identical(other.cragId, cragId) || other.cragId == cragId) &&
            const DeepCollectionEquality().equals(other._panels, _panels) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cragId,
      const DeepCollectionEquality().hash(_panels), updatedAt, updatedBy);

  /// Create a copy of HeaderConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeaderConfigImplCopyWith<_$HeaderConfigImpl> get copyWith =>
      __$$HeaderConfigImplCopyWithImpl<_$HeaderConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeaderConfigImplToJson(
      this,
    );
  }
}

abstract class _HeaderConfig implements HeaderConfig {
  const factory _HeaderConfig(
      {required final String cragId,
      final List<HeaderPanel> panels,
      final DateTime? updatedAt,
      final String? updatedBy}) = _$HeaderConfigImpl;

  factory _HeaderConfig.fromJson(Map<String, dynamic> json) =
      _$HeaderConfigImpl.fromJson;

  @override
  String get cragId;
  @override
  List<HeaderPanel> get panels; // exactly 6
  @override
  DateTime? get updatedAt;
  @override
  String? get updatedBy;

  /// Create a copy of HeaderConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeaderConfigImplCopyWith<_$HeaderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
