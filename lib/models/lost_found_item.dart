import 'package:freezed_annotation/freezed_annotation.dart';

part 'lost_found_item.freezed.dart';
part 'lost_found_item.g.dart';

enum LostFoundStatus { found, lost }

enum LostFoundCategory { gear, clothing, personalItem, rope, other }

@freezed
class LostFoundItem with _$LostFoundItem {
  const factory LostFoundItem({
    required String id,
    required String cragId,
    required String userId,
    required LostFoundStatus status,
    required LostFoundCategory category,
    required String itemName,
    String? description,
    String? locationNote,
    @Default(false) bool isResolved,
    DateTime? createdAt,
  }) = _LostFoundItem;

  factory LostFoundItem.fromJson(Map<String, dynamic> json) =>
      _$LostFoundItemFromJson(json);
}
