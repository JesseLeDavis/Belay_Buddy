import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Posts at a specific crag.
final postsAtCragProvider =
    StreamProvider.family<List<ClimbingPost>, String>((ref, cragId) {
  return Stream.value(MockData.getPostsForCrag(cragId));
});

/// All active posts.
final activePostsProvider = StreamProvider<List<ClimbingPost>>((ref) {
  return Stream.value(MockData.posts);
});

/// Current user's posts.
final userPostsProvider = StreamProvider<List<ClimbingPost>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(
    MockData.posts.where((p) => p.userId == userId).toList(),
  );
});

/// Post counts keyed by date (midnight) for a crag — used by the heatmap strip.
final postCountsByDateProvider =
    Provider.family<Map<DateTime, int>, String>((ref, cragId) {
  final posts = ref.watch(postsAtCragProvider(cragId)).valueOrNull ?? [];
  final counts = <DateTime, int>{};
  for (final post in posts) {
    final date = DateTime(
        post.dateTime.year, post.dateTime.month, post.dateTime.day);
    counts[date] = (counts[date] ?? 0) + 1;
  }
  return counts;
});
