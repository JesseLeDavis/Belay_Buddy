import 'package:belay_buddy/mock/mock_data.dart';
import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============ AUTH ============

/// Always returns the mock current user ID.
final currentUserIdProvider = StreamProvider<String?>((ref) {
  return Stream.value(mockCurrentUserId);
});

/// Synchronous current user ID.
final currentUserIdSyncProvider = Provider<String?>((ref) {
  return mockCurrentUserId;
});

// ============ USER ============

/// Current user profile from mock data.
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  return Stream.value(MockData.getUserById(mockCurrentUserId));
});

/// Look up any user by ID.
final userByIdProvider =
    FutureProvider.family<AppUser?, String>((ref, userId) async {
  return MockData.getUserById(userId);
});

// ============ CRAGS ============

/// All crags.
final allCragsProvider = StreamProvider<List<Crag>>((ref) {
  return Stream.value(MockData.crags);
});

/// Single crag by ID.
final cragProvider = FutureProvider.family<Crag?, String>((ref, cragId) async {
  return MockData.getCragById(cragId);
});

// ============ POSTS ============

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

// ============ CONVERSATIONS ============

/// All conversations for the current user.
final userConversationsProvider =
    StreamProvider<List<Conversation>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getConversationsForUser(userId));
});

/// Messages in a conversation.
final messagesProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
  return Stream.value(MockData.getMessagesForConversation(conversationId));
});
