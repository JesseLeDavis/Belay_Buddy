// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  ExperienceLevel get experienceLevel => throw _privateConstructorUsedError;
  List<String> get climbingTags => throw _privateConstructorUsedError;
  List<String> get favoriteCragIds => throw _privateConstructorUsedError;
  List<String> get favoriteGymIds => throw _privateConstructorUsedError;
  List<String> get connectionIds => throw _privateConstructorUsedError;
  List<String> get pendingConnectionIds => throw _privateConstructorUsedError;
  String? get homeGymId => throw _privateConstructorUsedError;
  String? get homeCragId => throw _privateConstructorUsedError;
  bool get isHomeVisible => throw _privateConstructorUsedError;
  bool get notifyHomeCatch => throw _privateConstructorUsedError;
  bool get notifyHomeConnections => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastActive => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String displayName,
      String? photoUrl,
      String? bio,
      ExperienceLevel experienceLevel,
      List<String> climbingTags,
      List<String> favoriteCragIds,
      List<String> favoriteGymIds,
      List<String> connectionIds,
      List<String> pendingConnectionIds,
      String? homeGymId,
      String? homeCragId,
      bool isHomeVisible,
      bool notifyHomeCatch,
      bool notifyHomeConnections,
      DateTime? createdAt,
      DateTime? lastActive});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? experienceLevel = null,
    Object? climbingTags = null,
    Object? favoriteCragIds = null,
    Object? favoriteGymIds = null,
    Object? connectionIds = null,
    Object? pendingConnectionIds = null,
    Object? homeGymId = freezed,
    Object? homeCragId = freezed,
    Object? isHomeVisible = null,
    Object? notifyHomeCatch = null,
    Object? notifyHomeConnections = null,
    Object? createdAt = freezed,
    Object? lastActive = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
      climbingTags: null == climbingTags
          ? _value.climbingTags
          : climbingTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      favoriteCragIds: null == favoriteCragIds
          ? _value.favoriteCragIds
          : favoriteCragIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      favoriteGymIds: null == favoriteGymIds
          ? _value.favoriteGymIds
          : favoriteGymIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      connectionIds: null == connectionIds
          ? _value.connectionIds
          : connectionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingConnectionIds: null == pendingConnectionIds
          ? _value.pendingConnectionIds
          : pendingConnectionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      homeGymId: freezed == homeGymId
          ? _value.homeGymId
          : homeGymId // ignore: cast_nullable_to_non_nullable
              as String?,
      homeCragId: freezed == homeCragId
          ? _value.homeCragId
          : homeCragId // ignore: cast_nullable_to_non_nullable
              as String?,
      isHomeVisible: null == isHomeVisible
          ? _value.isHomeVisible
          : isHomeVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyHomeCatch: null == notifyHomeCatch
          ? _value.notifyHomeCatch
          : notifyHomeCatch // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyHomeConnections: null == notifyHomeConnections
          ? _value.notifyHomeConnections
          : notifyHomeConnections // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
          _$AppUserImpl value, $Res Function(_$AppUserImpl) then) =
      __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String displayName,
      String? photoUrl,
      String? bio,
      ExperienceLevel experienceLevel,
      List<String> climbingTags,
      List<String> favoriteCragIds,
      List<String> favoriteGymIds,
      List<String> connectionIds,
      List<String> pendingConnectionIds,
      String? homeGymId,
      String? homeCragId,
      bool isHomeVisible,
      bool notifyHomeCatch,
      bool notifyHomeConnections,
      DateTime? createdAt,
      DateTime? lastActive});
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
      _$AppUserImpl _value, $Res Function(_$AppUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? bio = freezed,
    Object? experienceLevel = null,
    Object? climbingTags = null,
    Object? favoriteCragIds = null,
    Object? favoriteGymIds = null,
    Object? connectionIds = null,
    Object? pendingConnectionIds = null,
    Object? homeGymId = freezed,
    Object? homeCragId = freezed,
    Object? isHomeVisible = null,
    Object? notifyHomeCatch = null,
    Object? notifyHomeConnections = null,
    Object? createdAt = freezed,
    Object? lastActive = freezed,
  }) {
    return _then(_$AppUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
      climbingTags: null == climbingTags
          ? _value._climbingTags
          : climbingTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      favoriteCragIds: null == favoriteCragIds
          ? _value._favoriteCragIds
          : favoriteCragIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      favoriteGymIds: null == favoriteGymIds
          ? _value._favoriteGymIds
          : favoriteGymIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      connectionIds: null == connectionIds
          ? _value._connectionIds
          : connectionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pendingConnectionIds: null == pendingConnectionIds
          ? _value._pendingConnectionIds
          : pendingConnectionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      homeGymId: freezed == homeGymId
          ? _value.homeGymId
          : homeGymId // ignore: cast_nullable_to_non_nullable
              as String?,
      homeCragId: freezed == homeCragId
          ? _value.homeCragId
          : homeCragId // ignore: cast_nullable_to_non_nullable
              as String?,
      isHomeVisible: null == isHomeVisible
          ? _value.isHomeVisible
          : isHomeVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyHomeCatch: null == notifyHomeCatch
          ? _value.notifyHomeCatch
          : notifyHomeCatch // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyHomeConnections: null == notifyHomeConnections
          ? _value.notifyHomeConnections
          : notifyHomeConnections // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl(
      {required this.uid,
      required this.email,
      required this.displayName,
      this.photoUrl,
      this.bio,
      this.experienceLevel = ExperienceLevel.intermediate,
      final List<String> climbingTags = const [],
      final List<String> favoriteCragIds = const [],
      final List<String> favoriteGymIds = const [],
      final List<String> connectionIds = const [],
      final List<String> pendingConnectionIds = const [],
      this.homeGymId,
      this.homeCragId,
      this.isHomeVisible = true,
      this.notifyHomeCatch = true,
      this.notifyHomeConnections = false,
      this.createdAt,
      this.lastActive})
      : _climbingTags = climbingTags,
        _favoriteCragIds = favoriteCragIds,
        _favoriteGymIds = favoriteGymIds,
        _connectionIds = connectionIds,
        _pendingConnectionIds = pendingConnectionIds;

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String? photoUrl;
  @override
  final String? bio;
  @override
  @JsonKey()
  final ExperienceLevel experienceLevel;
  final List<String> _climbingTags;
  @override
  @JsonKey()
  List<String> get climbingTags {
    if (_climbingTags is EqualUnmodifiableListView) return _climbingTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_climbingTags);
  }

  final List<String> _favoriteCragIds;
  @override
  @JsonKey()
  List<String> get favoriteCragIds {
    if (_favoriteCragIds is EqualUnmodifiableListView) return _favoriteCragIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteCragIds);
  }

  final List<String> _favoriteGymIds;
  @override
  @JsonKey()
  List<String> get favoriteGymIds {
    if (_favoriteGymIds is EqualUnmodifiableListView) return _favoriteGymIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteGymIds);
  }

  final List<String> _connectionIds;
  @override
  @JsonKey()
  List<String> get connectionIds {
    if (_connectionIds is EqualUnmodifiableListView) return _connectionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connectionIds);
  }

  final List<String> _pendingConnectionIds;
  @override
  @JsonKey()
  List<String> get pendingConnectionIds {
    if (_pendingConnectionIds is EqualUnmodifiableListView)
      return _pendingConnectionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingConnectionIds);
  }

  @override
  final String? homeGymId;
  @override
  final String? homeCragId;
  @override
  @JsonKey()
  final bool isHomeVisible;
  @override
  @JsonKey()
  final bool notifyHomeCatch;
  @override
  @JsonKey()
  final bool notifyHomeConnections;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastActive;

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, bio: $bio, experienceLevel: $experienceLevel, climbingTags: $climbingTags, favoriteCragIds: $favoriteCragIds, favoriteGymIds: $favoriteGymIds, connectionIds: $connectionIds, pendingConnectionIds: $pendingConnectionIds, homeGymId: $homeGymId, homeCragId: $homeCragId, isHomeVisible: $isHomeVisible, notifyHomeCatch: $notifyHomeCatch, notifyHomeConnections: $notifyHomeConnections, createdAt: $createdAt, lastActive: $lastActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel) &&
            const DeepCollectionEquality()
                .equals(other._climbingTags, _climbingTags) &&
            const DeepCollectionEquality()
                .equals(other._favoriteCragIds, _favoriteCragIds) &&
            const DeepCollectionEquality()
                .equals(other._favoriteGymIds, _favoriteGymIds) &&
            const DeepCollectionEquality()
                .equals(other._connectionIds, _connectionIds) &&
            const DeepCollectionEquality()
                .equals(other._pendingConnectionIds, _pendingConnectionIds) &&
            (identical(other.homeGymId, homeGymId) ||
                other.homeGymId == homeGymId) &&
            (identical(other.homeCragId, homeCragId) ||
                other.homeCragId == homeCragId) &&
            (identical(other.isHomeVisible, isHomeVisible) ||
                other.isHomeVisible == isHomeVisible) &&
            (identical(other.notifyHomeCatch, notifyHomeCatch) ||
                other.notifyHomeCatch == notifyHomeCatch) &&
            (identical(other.notifyHomeConnections, notifyHomeConnections) ||
                other.notifyHomeConnections == notifyHomeConnections) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      displayName,
      photoUrl,
      bio,
      experienceLevel,
      const DeepCollectionEquality().hash(_climbingTags),
      const DeepCollectionEquality().hash(_favoriteCragIds),
      const DeepCollectionEquality().hash(_favoriteGymIds),
      const DeepCollectionEquality().hash(_connectionIds),
      const DeepCollectionEquality().hash(_pendingConnectionIds),
      homeGymId,
      homeCragId,
      isHomeVisible,
      notifyHomeCatch,
      notifyHomeConnections,
      createdAt,
      lastActive);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(
      this,
    );
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser(
      {required final String uid,
      required final String email,
      required final String displayName,
      final String? photoUrl,
      final String? bio,
      final ExperienceLevel experienceLevel,
      final List<String> climbingTags,
      final List<String> favoriteCragIds,
      final List<String> favoriteGymIds,
      final List<String> connectionIds,
      final List<String> pendingConnectionIds,
      final String? homeGymId,
      final String? homeCragId,
      final bool isHomeVisible,
      final bool notifyHomeCatch,
      final bool notifyHomeConnections,
      final DateTime? createdAt,
      final DateTime? lastActive}) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String? get photoUrl;
  @override
  String? get bio;
  @override
  ExperienceLevel get experienceLevel;
  @override
  List<String> get climbingTags;
  @override
  List<String> get favoriteCragIds;
  @override
  List<String> get favoriteGymIds;
  @override
  List<String> get connectionIds;
  @override
  List<String> get pendingConnectionIds;
  @override
  String? get homeGymId;
  @override
  String? get homeCragId;
  @override
  bool get isHomeVisible;
  @override
  bool get notifyHomeCatch;
  @override
  bool get notifyHomeConnections;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastActive;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
