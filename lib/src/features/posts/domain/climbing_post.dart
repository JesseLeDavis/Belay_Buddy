import 'package:freezed_annotation/freezed_annotation.dart';

part 'climbing_post.freezed.dart';
part 'climbing_post.g.dart';

enum PartnerNeedType {
  belay,
  ropedPartner,
  boulderingBuddy,
}

@freezed
class ClimbingPost with _$ClimbingPost {
  const factory ClimbingPost({
    required String id,
    required String userId,
    required String cragId,
    required String title,
    String? description,
    required DateTime dateTime,
    @Default(false) bool needsBelay,
    @Default(false) bool offeringBelay,
    @Default(PartnerNeedType.belay) PartnerNeedType partnerNeedType,
    String? gradeRange,
    DateTime? expiresAt,
    @Default(false) bool isExpired,
    @Default([]) List<String> respondentIds,
    DateTime? createdAt,
  }) = _ClimbingPost;

  factory ClimbingPost.fromJson(Map<String, dynamic> json) =>
      _$ClimbingPostFromJson(json);
}
