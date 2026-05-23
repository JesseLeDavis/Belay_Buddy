import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All post types at a specific crag.
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
/// Only counts partner request posts.
final postCountsByDateProvider =
    Provider.family<Map<DateTime, int>, String>((ref, cragId) {
  final posts = ref.watch(postsAtCragProvider(cragId)).valueOrNull ?? [];
  final counts = <DateTime, int>{};
  for (final post in posts.where((p) => p.type == PostType.partnerRequest)) {
    final date = DateTime(
        post.dateTime.year, post.dateTime.month, post.dateTime.day);
    counts[date] = (counts[date] ?? 0) + 1;
  }
  return counts;
});

// ── Community board filter ──────────────────────────────────────────────────

/// Current filter selection for community board. null = show all.
final communityFilterProvider = StateProvider<PostType?>((ref) => null);

/// Filtered posts at a crag based on selected filter.
final filteredPostsAtCragProvider =
    Provider.family<List<ClimbingPost>, String>((ref, cragId) {
  final all = ref.watch(postsAtCragProvider(cragId)).valueOrNull ?? [];
  final filter = ref.watch(communityFilterProvider);
  final filtered = filter == null ? all : all.where((p) => p.type == filter).toList();
  // Sort: newest first
  return filtered
    ..sort((a, b) => (b.createdAt ?? DateTime(2000))
        .compareTo(a.createdAt ?? DateTime(2000)));
});

/// Whether current user has expressed interest in a partner request.
final userInterestedInProvider = Provider.family<bool, String>((ref, postId) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return false;
  final posts = ref.watch(activePostsProvider).valueOrNull ?? [];
  try {
    final post = posts.firstWhere((p) => p.id == postId);
    return post.respondentIds.contains(userId);
  } catch (_) {
    return false;
  }
});

/// Count per type at a crag — used for filter tab badges.
final postTypeCountsProvider =
    Provider.family<Map<PostType, int>, String>((ref, cragId) {
  final all = ref.watch(postsAtCragProvider(cragId)).valueOrNull ?? [];
  final counts = <PostType, int>{};
  for (final post in all) {
    counts[post.type] = (counts[post.type] ?? 0) + 1;
  }
  return counts;
});
