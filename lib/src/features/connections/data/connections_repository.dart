import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
