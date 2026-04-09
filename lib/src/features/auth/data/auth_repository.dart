import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
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

/// Mutable current user profile — allows in-session edits (name, bio, styles).
class CurrentUserNotifier extends StateNotifier<AppUser?> {
  CurrentUserNotifier() : super(MockData.getUserById(mockCurrentUserId));

  void updateProfile({
    String? displayName,
    String? bio,
    List<String>? climbingTags,
  }) {
    final user = state;
    if (user == null) return;
    state = user.copyWith(
      displayName: displayName ?? user.displayName,
      bio: bio,
      climbingTags: climbingTags ?? user.climbingTags,
    );
  }
}

final currentUserNotifierProvider =
    StateNotifierProvider<CurrentUserNotifier, AppUser?>(
  (ref) => CurrentUserNotifier(),
);

/// Current user profile — reads from the mutable notifier.
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final user = ref.watch(currentUserNotifierProvider);
  return Stream.value(user);
});

/// Look up any user by ID.
final userByIdProvider =
    FutureProvider.family<AppUser?, String>((ref, userId) async {
  return MockData.getUserById(userId);
});
