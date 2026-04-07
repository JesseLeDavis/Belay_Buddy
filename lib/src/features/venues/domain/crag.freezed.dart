// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CragLocation _$CragLocationFromJson(Map<String, dynamic> json) {
  return _CragLocation.fromJson(json);
}

/// @nodoc
mixin _$CragLocation {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this CragLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CragLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CragLocationCopyWith<CragLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CragLocationCopyWith<$Res> {
  factory $CragLocationCopyWith(
          CragLocation value, $Res Function(CragLocation) then) =
      _$CragLocationCopyWithImpl<$Res, CragLocation>;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$CragLocationCopyWithImpl<$Res, $Val extends CragLocation>
    implements $CragLocationCopyWith<$Res> {
  _$CragLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CragLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CragLocationImplCopyWith<$Res>
    implements $CragLocationCopyWith<$Res> {
  factory _$$CragLocationImplCopyWith(
          _$CragLocationImpl value, $Res Function(_$CragLocationImpl) then) =
      __$$CragLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$$CragLocationImplCopyWithImpl<$Res>
    extends _$CragLocationCopyWithImpl<$Res, _$CragLocationImpl>
    implements _$$CragLocationImplCopyWith<$Res> {
  __$$CragLocationImplCopyWithImpl(
      _$CragLocationImpl _value, $Res Function(_$CragLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CragLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$CragLocationImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CragLocationImpl implements _CragLocation {
  const _$CragLocationImpl({required this.latitude, required this.longitude});

  factory _$CragLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CragLocationImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'CragLocation(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CragLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of CragLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CragLocationImplCopyWith<_$CragLocationImpl> get copyWith =>
      __$$CragLocationImplCopyWithImpl<_$CragLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CragLocationImplToJson(
      this,
    );
  }
}

abstract class _CragLocation implements CragLocation {
  const factory _CragLocation(
      {required final double latitude,
      required final double longitude}) = _$CragLocationImpl;

  factory _CragLocation.fromJson(Map<String, dynamic> json) =
      _$CragLocationImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of CragLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CragLocationImplCopyWith<_$CragLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Crag _$CragFromJson(Map<String, dynamic> json) {
  return _Crag.fromJson(json);
}

/// @nodoc
mixin _$Crag {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CragLocation get location => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<CragType> get types => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  bool get isGym => throw _privateConstructorUsedError;
  int get activeClimbersCount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this Crag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Crag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CragCopyWith<Crag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CragCopyWith<$Res> {
  factory $CragCopyWith(Crag value, $Res Function(Crag) then) =
      _$CragCopyWithImpl<$Res, Crag>;
  @useResult
  $Res call(
      {String id,
      String name,
      CragLocation location,
      String? description,
      List<CragType> types,
      String? imageUrl,
      String? region,
      String? country,
      bool isGym,
      int activeClimbersCount,
      DateTime? createdAt,
      String? createdBy});

  $CragLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$CragCopyWithImpl<$Res, $Val extends Crag>
    implements $CragCopyWith<$Res> {
  _$CragCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Crag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = null,
    Object? description = freezed,
    Object? types = null,
    Object? imageUrl = freezed,
    Object? region = freezed,
    Object? country = freezed,
    Object? isGym = null,
    Object? activeClimbersCount = null,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as CragLocation,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<CragType>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      isGym: null == isGym
          ? _value.isGym
          : isGym // ignore: cast_nullable_to_non_nullable
              as bool,
      activeClimbersCount: null == activeClimbersCount
          ? _value.activeClimbersCount
          : activeClimbersCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Crag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CragLocationCopyWith<$Res> get location {
    return $CragLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CragImplCopyWith<$Res> implements $CragCopyWith<$Res> {
  factory _$$CragImplCopyWith(
          _$CragImpl value, $Res Function(_$CragImpl) then) =
      __$$CragImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      CragLocation location,
      String? description,
      List<CragType> types,
      String? imageUrl,
      String? region,
      String? country,
      bool isGym,
      int activeClimbersCount,
      DateTime? createdAt,
      String? createdBy});

  @override
  $CragLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$CragImplCopyWithImpl<$Res>
    extends _$CragCopyWithImpl<$Res, _$CragImpl>
    implements _$$CragImplCopyWith<$Res> {
  __$$CragImplCopyWithImpl(_$CragImpl _value, $Res Function(_$CragImpl) _then)
      : super(_value, _then);

  /// Create a copy of Crag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = null,
    Object? description = freezed,
    Object? types = null,
    Object? imageUrl = freezed,
    Object? region = freezed,
    Object? country = freezed,
    Object? isGym = null,
    Object? activeClimbersCount = null,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$CragImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as CragLocation,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      types: null == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<CragType>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      isGym: null == isGym
          ? _value.isGym
          : isGym // ignore: cast_nullable_to_non_nullable
              as bool,
      activeClimbersCount: null == activeClimbersCount
          ? _value.activeClimbersCount
          : activeClimbersCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CragImpl implements _Crag {
  const _$CragImpl(
      {required this.id,
      required this.name,
      required this.location,
      this.description,
      final List<CragType> types = const [],
      this.imageUrl,
      this.region,
      this.country,
      this.isGym = false,
      this.activeClimbersCount = 0,
      this.createdAt,
      this.createdBy})
      : _types = types;

  factory _$CragImpl.fromJson(Map<String, dynamic> json) =>
      _$$CragImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final CragLocation location;
  @override
  final String? description;
  final List<CragType> _types;
  @override
  @JsonKey()
  List<CragType> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  final String? imageUrl;
  @override
  final String? region;
  @override
  final String? country;
  @override
  @JsonKey()
  final bool isGym;
  @override
  @JsonKey()
  final int activeClimbersCount;
  @override
  final DateTime? createdAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'Crag(id: $id, name: $name, location: $location, description: $description, types: $types, imageUrl: $imageUrl, region: $region, country: $country, isGym: $isGym, activeClimbersCount: $activeClimbersCount, createdAt: $createdAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CragImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isGym, isGym) || other.isGym == isGym) &&
            (identical(other.activeClimbersCount, activeClimbersCount) ||
                other.activeClimbersCount == activeClimbersCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      location,
      description,
      const DeepCollectionEquality().hash(_types),
      imageUrl,
      region,
      country,
      isGym,
      activeClimbersCount,
      createdAt,
      createdBy);

  /// Create a copy of Crag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CragImplCopyWith<_$CragImpl> get copyWith =>
      __$$CragImplCopyWithImpl<_$CragImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CragImplToJson(
      this,
    );
  }
}

abstract class _Crag implements Crag {
  const factory _Crag(
      {required final String id,
      required final String name,
      required final CragLocation location,
      final String? description,
      final List<CragType> types,
      final String? imageUrl,
      final String? region,
      final String? country,
      final bool isGym,
      final int activeClimbersCount,
      final DateTime? createdAt,
      final String? createdBy}) = _$CragImpl;

  factory _Crag.fromJson(Map<String, dynamic> json) = _$CragImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  CragLocation get location;
  @override
  String? get description;
  @override
  List<CragType> get types;
  @override
  String? get imageUrl;
  @override
  String? get region;
  @override
  String? get country;
  @override
  bool get isGym;
  @override
  int get activeClimbersCount;
  @override
  DateTime? get createdAt;
  @override
  String? get createdBy;

  /// Create a copy of Crag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CragImplCopyWith<_$CragImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
