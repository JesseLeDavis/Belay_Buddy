import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Visible home members for a crag/gym (those with isHomeVisible == true).
final visibleHomeMembersProvider =
    Provider.family<List<AppUser>, String>((ref, cragId) {
  return MockData.getVisibleHomeMembers(cragId);
});

/// Member count for a crag/gym — base count from mock data adjusted by
/// whether the current user has this as their home location.
/// Top community vibe tags for a crag/gym — aggregated from home members'
/// climbingTags, sorted by frequency. Returns (tagId, count) pairs.
final cragVibeTagsProvider =
    Provider.family<List<({String tagId, int count})>, String>((ref, cragId) {
  final members = MockData.getVisibleHomeMembers(cragId);
  final tally = <String, int>{};
  for (final user in members) {
    for (final tag in user.climbingTags) {
      tally[tag] = (tally[tag] ?? 0) + 1;
    }
  }
  final sorted = tally.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(5).map((e) => (tagId: e.key, count: e.value)).toList();
});

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
