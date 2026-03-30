import 'package:freezed_annotation/freezed_annotation.dart';

part 'crag.freezed.dart';
part 'crag.g.dart';

enum CragType {
  sport,
  trad,
  boulder,
  mixed,
}

@freezed
class CragLocation with _$CragLocation {
  const factory CragLocation({
    required double latitude,
    required double longitude,
  }) = _CragLocation;

  factory CragLocation.fromJson(Map<String, dynamic> json) =>
      _$CragLocationFromJson(json);
}

@freezed
class Crag with _$Crag {
  const factory Crag({
    required String id,
    required String name,
    required CragLocation location,
    String? description,
    @Default([]) List<CragType> types,
    String? imageUrl,
    String? region,
    String? country,
    @Default(false) bool isGym,
    @Default(0) int activeClimbersCount,
    DateTime? createdAt,
    String? createdBy, // User ID who added this crag
  }) = _Crag;

  factory Crag.fromJson(Map<String, dynamic> json) => _$CragFromJson(json);
}
