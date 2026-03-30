import 'package:belay_buddy/mock/mock_data.dart';
import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/models/climbing_notification.dart';
import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/models/lost_found_item.dart';
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

// ============ LOST & FOUND ============

/// Lost & found items at a specific crag.
final lostFoundAtCragProvider =
    StreamProvider.family<List<LostFoundItem>, String>((ref, cragId) {
  return Stream.value(MockData.getLostFoundForCrag(cragId));
});

// ============ CONNECTIONS ============

/// Current user's confirmed connections.
final connectionsProvider = StreamProvider<List<AppUser>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getConnectionsForUser(userId));
});

/// Incoming connection requests (users who have requested to connect with current user).
final pendingConnectionRequestsProvider = StreamProvider<List<AppUser>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getPendingRequestsForUser(userId));
});

/// All users available to browse/connect with.
final discoverableUsersProvider = StreamProvider<List<AppUser>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getDiscoverableUsers(userId));
});

/// Whether the current user is connected to a given userId.
final isConnectedProvider = Provider.family<bool, String>((ref, targetUserId) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull;
  if (currentUser == null) return false;
  return currentUser.connectionIds.contains(targetUserId);
});

/// Whether the current user has a pending request from a given userId.
final hasPendingRequestFromProvider =
    Provider.family<bool, String>((ref, targetUserId) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull;
  if (currentUser == null) return false;
  return currentUser.pendingConnectionIds.contains(targetUserId);
});

// ============ NOTIFICATIONS ============

/// All notifications for the current user.
final notificationsProvider =
    StreamProvider<List<ClimbingNotification>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getNotificationsForUser(userId));
});

/// Unread notification count (used for badge).
final unreadNotificationCountProvider = Provider<int>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return 0;
  return MockData.getUnreadNotificationCount(userId);
});

// ============ HOME BASE ============

/// Mutable home settings for the current session — mirrors what would be
/// saved to Firestore in production. Seeded from mock current user.
class HomeSettings {
  final String? homeCragId;
  final String? homeGymId;
  final bool isHomeVisible;
  final bool notifyHomeCatch;
  final bool notifyHomeConnections;

  const HomeSettings({
    this.homeCragId,
    this.homeGymId,
    this.isHomeVisible = true,
    this.notifyHomeCatch = true,
    this.notifyHomeConnections = false,
  });

  HomeSettings copyWith({
    Object? homeCragId = _sentinel,
    Object? homeGymId = _sentinel,
    bool? isHomeVisible,
    bool? notifyHomeCatch,
    bool? notifyHomeConnections,
  }) {
    return HomeSettings(
      homeCragId: homeCragId == _sentinel
          ? this.homeCragId
          : homeCragId as String?,
      homeGymId:
          homeGymId == _sentinel ? this.homeGymId : homeGymId as String?,
      isHomeVisible: isHomeVisible ?? this.isHomeVisible,
      notifyHomeCatch: notifyHomeCatch ?? this.notifyHomeCatch,
      notifyHomeConnections:
          notifyHomeConnections ?? this.notifyHomeConnections,
    );
  }
}

const _sentinel = Object();

class HomeSettingsNotifier extends StateNotifier<HomeSettings> {
  HomeSettingsNotifier()
      : super(() {
          final user = MockData.getUserById(mockCurrentUserId);
          return HomeSettings(
            homeCragId: user?.homeCragId,
            homeGymId: user?.homeGymId,
            isHomeVisible: user?.isHomeVisible ?? true,
            notifyHomeCatch: user?.notifyHomeCatch ?? true,
            notifyHomeConnections: user?.notifyHomeConnections ?? false,
          );
        }());

  void toggleVisibility() =>
      state = state.copyWith(isHomeVisible: !state.isHomeVisible);

  void toggleNotifyHomeCatch() =>
      state = state.copyWith(notifyHomeCatch: !state.notifyHomeCatch);

  void toggleNotifyHomeConnections() =>
      state = state.copyWith(
          notifyHomeConnections: !state.notifyHomeConnections);

  void setHomeCragDirect(String? cragId) =>
      state = state.copyWith(homeCragId: cragId);

  void setHomeGymDirect(String? gymId) =>
      state = state.copyWith(homeGymId: gymId);
}

final homeSettingsProvider =
    StateNotifierProvider<HomeSettingsNotifier, HomeSettings>(
  (ref) => HomeSettingsNotifier(),
);

/// Member count for a crag/gym — base count from mock data adjusted by
/// whether the current user has this as their home location.
final homeMemberCountProvider =
    Provider.family<int, String>((ref, cragId) {
  final settings = ref.watch(homeSettingsProvider);
  final baseCount = MockData.getHomeMemberCount(cragId);

  // Get what mock data says about current user's home
  final mockUser = MockData.getUserById(mockCurrentUserId);
  final wasHome = mockUser?.homeCragId == cragId || mockUser?.homeGymId == cragId;
  final isHome = settings.homeCragId == cragId || settings.homeGymId == cragId;

  if (wasHome == isHome) return baseCount;
  if (isHome) return baseCount + 1;
  return (baseCount - 1).clamp(0, 9999);
});

// ============ FAVORITES ============

/// Whether the current user has favorited a given crag.
final isFavoriteCragProvider = Provider.family<bool, String>((ref, cragId) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull;
  if (currentUser == null) return false;
  return currentUser.favoriteCragIds.contains(cragId);
});

/// Whether the current user has favorited a given gym.
final isFavoriteGymProvider = Provider.family<bool, String>((ref, gymId) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull;
  if (currentUser == null) return false;
  return currentUser.favoriteGymIds.contains(gymId);
});

// ============ HEATMAP ============

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
