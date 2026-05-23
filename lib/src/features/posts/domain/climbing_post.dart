import 'package:freezed_annotation/freezed_annotation.dart';

part 'climbing_post.freezed.dart';
part 'climbing_post.g.dart';

enum PostType {
  introduction,    // "Meet me" — self-intro + climbing goals
  partnerRequest,  // Looking for a climbing partner on a date
  lostFound,       // Lost or found item at the crag
}

enum PartnerNeedType {
  belay,
  ropedPartner,
  boulderingBuddy,
}

enum LostFoundStatus { lost, found }

enum LostFoundCategory { gear, clothing, personalItem, rope, other }

@freezed
class ClimbingPost with _$ClimbingPost {
  const factory ClimbingPost({
    required String id,
    required String userId,
    required String cragId,
    required String title,
    String? description,
    required DateTime dateTime,
    @Default(PostType.partnerRequest) PostType type,

    // Partner request fields
    @Default(false) bool needsBelay,
    @Default(false) bool offeringBelay,
    @Default(PartnerNeedType.belay) PartnerNeedType partnerNeedType,
    String? gradeRange,
    DateTime? expiresAt,
    @Default(false) bool isExpired,
    @Default([]) List<String> respondentIds,

    // Introduction fields
    String? climbingLevel,
    @Default([]) List<String> climbingGoals,

    // Lost & Found fields
    LostFoundStatus? lostFoundStatus,
    LostFoundCategory? lostFoundCategory,
    String? itemName,
    String? locationNote,
    @Default(false) bool isResolved,

    DateTime? createdAt,
  }) = _ClimbingPost;

  factory ClimbingPost.fromJson(Map<String, dynamic> json) =>
      _$ClimbingPostFromJson(json);
}
