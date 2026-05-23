// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'climbing_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClimbingPost _$ClimbingPostFromJson(Map<String, dynamic> json) {
  return _ClimbingPost.fromJson(json);
}

/// @nodoc
mixin _$ClimbingPost {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get cragId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  PostType get type =>
      throw _privateConstructorUsedError; // Partner request fields
  bool get needsBelay => throw _privateConstructorUsedError;
  bool get offeringBelay => throw _privateConstructorUsedError;
  PartnerNeedType get partnerNeedType => throw _privateConstructorUsedError;
  String? get gradeRange => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  bool get isExpired => throw _privateConstructorUsedError;
  List<String> get respondentIds =>
      throw _privateConstructorUsedError; // Introduction fields
  String? get climbingLevel => throw _privateConstructorUsedError;
  List<String> get climbingGoals =>
      throw _privateConstructorUsedError; // Lost & Found fields
  LostFoundStatus? get lostFoundStatus => throw _privateConstructorUsedError;
  LostFoundCategory? get lostFoundCategory =>
      throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  String? get locationNote => throw _privateConstructorUsedError;
  bool get isResolved => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClimbingPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClimbingPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClimbingPostCopyWith<ClimbingPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClimbingPostCopyWith<$Res> {
  factory $ClimbingPostCopyWith(
          ClimbingPost value, $Res Function(ClimbingPost) then) =
      _$ClimbingPostCopyWithImpl<$Res, ClimbingPost>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String cragId,
      String title,
      String? description,
      DateTime dateTime,
      PostType type,
      bool needsBelay,
      bool offeringBelay,
      PartnerNeedType partnerNeedType,
      String? gradeRange,
      DateTime? expiresAt,
      bool isExpired,
      List<String> respondentIds,
      String? climbingLevel,
      List<String> climbingGoals,
      LostFoundStatus? lostFoundStatus,
      LostFoundCategory? lostFoundCategory,
      String? itemName,
      String? locationNote,
      bool isResolved,
      DateTime? createdAt});
}

/// @nodoc
class _$ClimbingPostCopyWithImpl<$Res, $Val extends ClimbingPost>
    implements $ClimbingPostCopyWith<$Res> {
  _$ClimbingPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClimbingPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cragId = null,
    Object? title = null,
    Object? description = freezed,
    Object? dateTime = null,
    Object? type = null,
    Object? needsBelay = null,
    Object? offeringBelay = null,
    Object? partnerNeedType = null,
    Object? gradeRange = freezed,
    Object? expiresAt = freezed,
    Object? isExpired = null,
    Object? respondentIds = null,
    Object? climbingLevel = freezed,
    Object? climbingGoals = null,
    Object? lostFoundStatus = freezed,
    Object? lostFoundCategory = freezed,
    Object? itemName = freezed,
    Object? locationNote = freezed,
    Object? isResolved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      cragId: null == cragId
          ? _value.cragId
          : cragId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      needsBelay: null == needsBelay
          ? _value.needsBelay
          : needsBelay // ignore: cast_nullable_to_non_nullable
              as bool,
      offeringBelay: null == offeringBelay
          ? _value.offeringBelay
          : offeringBelay // ignore: cast_nullable_to_non_nullable
              as bool,
      partnerNeedType: null == partnerNeedType
          ? _value.partnerNeedType
          : partnerNeedType // ignore: cast_nullable_to_non_nullable
              as PartnerNeedType,
      gradeRange: freezed == gradeRange
          ? _value.gradeRange
          : gradeRange // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      respondentIds: null == respondentIds
          ? _value.respondentIds
          : respondentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      climbingLevel: freezed == climbingLevel
          ? _value.climbingLevel
          : climbingLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      climbingGoals: null == climbingGoals
          ? _value.climbingGoals
          : climbingGoals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lostFoundStatus: freezed == lostFoundStatus
          ? _value.lostFoundStatus
          : lostFoundStatus // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus?,
      lostFoundCategory: freezed == lostFoundCategory
          ? _value.lostFoundCategory
          : lostFoundCategory // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory?,
      itemName: freezed == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ClimbingPostImplCopyWith<$Res>
    implements $ClimbingPostCopyWith<$Res> {
  factory _$$ClimbingPostImplCopyWith(
          _$ClimbingPostImpl value, $Res Function(_$ClimbingPostImpl) then) =
      __$$ClimbingPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String cragId,
      String title,
      String? description,
      DateTime dateTime,
      PostType type,
      bool needsBelay,
      bool offeringBelay,
      PartnerNeedType partnerNeedType,
      String? gradeRange,
      DateTime? expiresAt,
      bool isExpired,
      List<String> respondentIds,
      String? climbingLevel,
      List<String> climbingGoals,
      LostFoundStatus? lostFoundStatus,
      LostFoundCategory? lostFoundCategory,
      String? itemName,
      String? locationNote,
      bool isResolved,
      DateTime? createdAt});
}

/// @nodoc
class __$$ClimbingPostImplCopyWithImpl<$Res>
    extends _$ClimbingPostCopyWithImpl<$Res, _$ClimbingPostImpl>
    implements _$$ClimbingPostImplCopyWith<$Res> {
  __$$ClimbingPostImplCopyWithImpl(
      _$ClimbingPostImpl _value, $Res Function(_$ClimbingPostImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClimbingPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cragId = null,
    Object? title = null,
    Object? description = freezed,
    Object? dateTime = null,
    Object? type = null,
    Object? needsBelay = null,
    Object? offeringBelay = null,
    Object? partnerNeedType = null,
    Object? gradeRange = freezed,
    Object? expiresAt = freezed,
    Object? isExpired = null,
    Object? respondentIds = null,
    Object? climbingLevel = freezed,
    Object? climbingGoals = null,
    Object? lostFoundStatus = freezed,
    Object? lostFoundCategory = freezed,
    Object? itemName = freezed,
    Object? locationNote = freezed,
    Object? isResolved = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ClimbingPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      cragId: null == cragId
          ? _value.cragId
          : cragId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostType,
      needsBelay: null == needsBelay
          ? _value.needsBelay
          : needsBelay // ignore: cast_nullable_to_non_nullable
              as bool,
      offeringBelay: null == offeringBelay
          ? _value.offeringBelay
          : offeringBelay // ignore: cast_nullable_to_non_nullable
              as bool,
      partnerNeedType: null == partnerNeedType
          ? _value.partnerNeedType
          : partnerNeedType // ignore: cast_nullable_to_non_nullable
              as PartnerNeedType,
      gradeRange: freezed == gradeRange
          ? _value.gradeRange
          : gradeRange // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      respondentIds: null == respondentIds
          ? _value._respondentIds
          : respondentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      climbingLevel: freezed == climbingLevel
          ? _value.climbingLevel
          : climbingLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      climbingGoals: null == climbingGoals
          ? _value._climbingGoals
          : climbingGoals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lostFoundStatus: freezed == lostFoundStatus
          ? _value.lostFoundStatus
          : lostFoundStatus // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus?,
      lostFoundCategory: freezed == lostFoundCategory
          ? _value.lostFoundCategory
          : lostFoundCategory // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory?,
      itemName: freezed == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
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
class _$ClimbingPostImpl implements _ClimbingPost {
  const _$ClimbingPostImpl(
      {required this.id,
      required this.userId,
      required this.cragId,
      required this.title,
      this.description,
      required this.dateTime,
      this.type = PostType.partnerRequest,
      this.needsBelay = false,
      this.offeringBelay = false,
      this.partnerNeedType = PartnerNeedType.belay,
      this.gradeRange,
      this.expiresAt,
      this.isExpired = false,
      final List<String> respondentIds = const [],
      this.climbingLevel,
      final List<String> climbingGoals = const [],
      this.lostFoundStatus,
      this.lostFoundCategory,
      this.itemName,
      this.locationNote,
      this.isResolved = false,
      this.createdAt})
      : _respondentIds = respondentIds,
        _climbingGoals = climbingGoals;

  factory _$ClimbingPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClimbingPostImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String cragId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime dateTime;
  @override
  @JsonKey()
  final PostType type;
// Partner request fields
  @override
  @JsonKey()
  final bool needsBelay;
  @override
  @JsonKey()
  final bool offeringBelay;
  @override
  @JsonKey()
  final PartnerNeedType partnerNeedType;
  @override
  final String? gradeRange;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final bool isExpired;
  final List<String> _respondentIds;
  @override
  @JsonKey()
  List<String> get respondentIds {
    if (_respondentIds is EqualUnmodifiableListView) return _respondentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_respondentIds);
  }

// Introduction fields
  @override
  final String? climbingLevel;
  final List<String> _climbingGoals;
  @override
  @JsonKey()
  List<String> get climbingGoals {
    if (_climbingGoals is EqualUnmodifiableListView) return _climbingGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_climbingGoals);
  }

// Lost & Found fields
  @override
  final LostFoundStatus? lostFoundStatus;
  @override
  final LostFoundCategory? lostFoundCategory;
  @override
  final String? itemName;
  @override
  final String? locationNote;
  @override
  @JsonKey()
  final bool isResolved;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ClimbingPost(id: $id, userId: $userId, cragId: $cragId, title: $title, description: $description, dateTime: $dateTime, type: $type, needsBelay: $needsBelay, offeringBelay: $offeringBelay, partnerNeedType: $partnerNeedType, gradeRange: $gradeRange, expiresAt: $expiresAt, isExpired: $isExpired, respondentIds: $respondentIds, climbingLevel: $climbingLevel, climbingGoals: $climbingGoals, lostFoundStatus: $lostFoundStatus, lostFoundCategory: $lostFoundCategory, itemName: $itemName, locationNote: $locationNote, isResolved: $isResolved, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClimbingPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.cragId, cragId) || other.cragId == cragId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.needsBelay, needsBelay) ||
                other.needsBelay == needsBelay) &&
            (identical(other.offeringBelay, offeringBelay) ||
                other.offeringBelay == offeringBelay) &&
            (identical(other.partnerNeedType, partnerNeedType) ||
                other.partnerNeedType == partnerNeedType) &&
            (identical(other.gradeRange, gradeRange) ||
                other.gradeRange == gradeRange) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            const DeepCollectionEquality()
                .equals(other._respondentIds, _respondentIds) &&
            (identical(other.climbingLevel, climbingLevel) ||
                other.climbingLevel == climbingLevel) &&
            const DeepCollectionEquality()
                .equals(other._climbingGoals, _climbingGoals) &&
            (identical(other.lostFoundStatus, lostFoundStatus) ||
                other.lostFoundStatus == lostFoundStatus) &&
            (identical(other.lostFoundCategory, lostFoundCategory) ||
                other.lostFoundCategory == lostFoundCategory) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.locationNote, locationNote) ||
                other.locationNote == locationNote) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        cragId,
        title,
        description,
        dateTime,
        type,
        needsBelay,
        offeringBelay,
        partnerNeedType,
        gradeRange,
        expiresAt,
        isExpired,
        const DeepCollectionEquality().hash(_respondentIds),
        climbingLevel,
        const DeepCollectionEquality().hash(_climbingGoals),
        lostFoundStatus,
        lostFoundCategory,
        itemName,
        locationNote,
        isResolved,
        createdAt
      ]);

  /// Create a copy of ClimbingPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClimbingPostImplCopyWith<_$ClimbingPostImpl> get copyWith =>
      __$$ClimbingPostImplCopyWithImpl<_$ClimbingPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClimbingPostImplToJson(
      this,
    );
  }
}

abstract class _ClimbingPost implements ClimbingPost {
  const factory _ClimbingPost(
      {required final String id,
      required final String userId,
      required final String cragId,
      required final String title,
      final String? description,
      required final DateTime dateTime,
      final PostType type,
      final bool needsBelay,
      final bool offeringBelay,
      final PartnerNeedType partnerNeedType,
      final String? gradeRange,
      final DateTime? expiresAt,
      final bool isExpired,
      final List<String> respondentIds,
      final String? climbingLevel,
      final List<String> climbingGoals,
      final LostFoundStatus? lostFoundStatus,
      final LostFoundCategory? lostFoundCategory,
      final String? itemName,
      final String? locationNote,
      final bool isResolved,
      final DateTime? createdAt}) = _$ClimbingPostImpl;

  factory _ClimbingPost.fromJson(Map<String, dynamic> json) =
      _$ClimbingPostImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get cragId;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get dateTime;
  @override
  PostType get type; // Partner request fields
  @override
  bool get needsBelay;
  @override
  bool get offeringBelay;
  @override
  PartnerNeedType get partnerNeedType;
  @override
  String? get gradeRange;
  @override
  DateTime? get expiresAt;
  @override
  bool get isExpired;
  @override
  List<String> get respondentIds; // Introduction fields
  @override
  String? get climbingLevel;
  @override
  List<String> get climbingGoals; // Lost & Found fields
  @override
  LostFoundStatus? get lostFoundStatus;
  @override
  LostFoundCategory? get lostFoundCategory;
  @override
  String? get itemName;
  @override
  String? get locationNote;
  @override
  bool get isResolved;
  @override
  DateTime? get createdAt;

  /// Create a copy of ClimbingPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClimbingPostImplCopyWith<_$ClimbingPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
