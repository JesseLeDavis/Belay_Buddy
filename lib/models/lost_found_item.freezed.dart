// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LostFoundItem _$LostFoundItemFromJson(Map<String, dynamic> json) {
  return _LostFoundItem.fromJson(json);
}

/// @nodoc
mixin _$LostFoundItem {
  String get id => throw _privateConstructorUsedError;
  String get cragId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  LostFoundStatus get status => throw _privateConstructorUsedError;
  LostFoundCategory get category => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get locationNote => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LostFoundItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LostFoundItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostFoundItemCopyWith<LostFoundItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostFoundItemCopyWith<$Res> {
  factory $LostFoundItemCopyWith(
          LostFoundItem value, $Res Function(LostFoundItem) then) =
      _$LostFoundItemCopyWithImpl<$Res, LostFoundItem>;
  @useResult
  $Res call(
      {String id,
      String cragId,
      String userId,
      LostFoundStatus status,
      LostFoundCategory category,
      String itemName,
      String? description,
      String? locationNote,
      bool isResolved,
      DateTime? createdAt});
}

/// @nodoc
class _$LostFoundItemCopyWithImpl<$Res, $Val extends LostFoundItem>
    implements $LostFoundItemCopyWith<$Res> {
  _$LostFoundItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostFoundItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cragId = null,
    Object? userId = null,
    Object? status = null,
    Object? category = null,
    Object? itemName = null,
    Object? description = freezed,
    Object? locationNote = freezed,
    Object? isResolved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cragId: null == cragId
          ? _value.cragId
          : cragId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      locationNote: freezed == locationNote
          ? _value.locationNote
          : locationNote // ignore: cast_nullable_to_non_nullable
              as String?,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostFoundItemImplCopyWith<$Res>
    implements $LostFoundItemCopyWith<$Res> {
  factory _$$LostFoundItemImplCopyWith(
          _$LostFoundItemImpl value, $Res Function(_$LostFoundItemImpl) then) =
      __$$LostFoundItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String cragId,
      String userId,
      LostFoundStatus status,
      LostFoundCategory category,
      String itemName,
      String? description,
      String? locationNote,
      bool isResolved,
      DateTime? createdAt});
}

/// @nodoc
class __$$LostFoundItemImplCopyWithImpl<$Res>
    extends _$LostFoundItemCopyWithImpl<$Res, _$LostFoundItemImpl>
    implements _$$LostFoundItemImplCopyWith<$Res> {
  __$$LostFoundItemImplCopyWithImpl(
      _$LostFoundItemImpl _value, $Res Function(_$LostFoundItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostFoundItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cragId = null,
    Object? userId = null,
    Object? status = null,
    Object? category = null,
    Object? itemName = null,
    Object? description = freezed,
    Object? locationNote = freezed,
    Object? isResolved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$LostFoundItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cragId: null == cragId
          ? _value.cragId
          : cragId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      locationNote: freezed == locationNote
          ? _value.locationNote
          : locationNote // ignore: cast_nullable_to_non_nullable
              as String?,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LostFoundItemImpl implements _LostFoundItem {
  const _$LostFoundItemImpl(
      {required this.id,
      required this.cragId,
      required this.userId,
      required this.status,
      required this.category,
      required this.itemName,
      this.description,
      this.locationNote,
      this.isResolved = false,
      this.createdAt});

  factory _$LostFoundItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LostFoundItemImplFromJson(json);

  @override
  final String id;
  @override
  final String cragId;
  @override
  final String userId;
  @override
  final LostFoundStatus status;
  @override
  final LostFoundCategory category;
  @override
  final String itemName;
  @override
  final String? description;
  @override
  final String? locationNote;
  @override
  @JsonKey()
  final bool isResolved;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'LostFoundItem(id: $id, cragId: $cragId, userId: $userId, status: $status, category: $category, itemName: $itemName, description: $description, locationNote: $locationNote, isResolved: $isResolved, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostFoundItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cragId, cragId) || other.cragId == cragId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.locationNote, locationNote) ||
                other.locationNote == locationNote) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, cragId, userId, status,
      category, itemName, description, locationNote, isResolved, createdAt);

  /// Create a copy of LostFoundItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostFoundItemImplCopyWith<_$LostFoundItemImpl> get copyWith =>
      __$$LostFoundItemImplCopyWithImpl<_$LostFoundItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LostFoundItemImplToJson(
      this,
    );
  }
}

abstract class _LostFoundItem implements LostFoundItem {
  const factory _LostFoundItem(
      {required final String id,
      required final String cragId,
      required final String userId,
      required final LostFoundStatus status,
      required final LostFoundCategory category,
      required final String itemName,
      final String? description,
      final String? locationNote,
      final bool isResolved,
      final DateTime? createdAt}) = _$LostFoundItemImpl;

  factory _LostFoundItem.fromJson(Map<String, dynamic> json) =
      _$LostFoundItemImpl.fromJson;

  @override
  String get id;
  @override
  String get cragId;
  @override
  String get userId;
  @override
  LostFoundStatus get status;
  @override
  LostFoundCategory get category;
  @override
  String get itemName;
  @override
  String? get description;
  @override
  String? get locationNote;
  @override
  bool get isResolved;
  @override
  DateTime? get createdAt;

  /// Create a copy of LostFoundItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostFoundItemImplCopyWith<_$LostFoundItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
