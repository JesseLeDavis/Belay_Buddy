import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/lost_found/domain/lost_found_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lost & found items at a specific crag.
final lostFoundAtCragProvider =
    StreamProvider.family<List<LostFoundItem>, String>((ref, cragId) {
  return Stream.value(MockData.getLostFoundForCrag(cragId));
});
