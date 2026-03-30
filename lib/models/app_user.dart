import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum ExperienceLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum ClimbingStyle {
  sport,
  trad,
  boulder,
  all,
}

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    String? bio,
    @Default(ExperienceLevel.intermediate) ExperienceLevel experienceLevel,
    @Default([ClimbingStyle.all]) List<ClimbingStyle> climbingStyles,
    @Default([]) List<String> favoriteCragIds,
    @Default([]) List<String> favoriteGymIds,
    @Default([]) List<String> connectionIds,
    @Default([]) List<String> pendingConnectionIds,
    String? homeGymId,
    String? homeCragId,
    @Default(true) bool isHomeVisible,
    @Default(true) bool notifyHomeCatch,
    @Default(false) bool notifyHomeConnections,
    DateTime? createdAt,
    DateTime? lastActive,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
