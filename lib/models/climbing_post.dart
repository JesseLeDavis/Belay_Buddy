import 'package:freezed_annotation/freezed_annotation.dart';

part 'climbing_post.freezed.dart';
part 'climbing_post.g.dart';

enum PostType {
  immediate, // "Climbing now" or "going today"
  scheduled, // Future date/time
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
    @Default(PostType.scheduled) PostType type,
    @Default(false) bool needsBelay,
    @Default(false) bool offeringBelay,
    DateTime? expiresAt,
    DateTime? createdAt,
    @Default(false) bool isExpired,
  }) = _ClimbingPost;

  factory ClimbingPost.fromJson(Map<String, dynamic> json) =>
      _$ClimbingPostFromJson(json);
}
