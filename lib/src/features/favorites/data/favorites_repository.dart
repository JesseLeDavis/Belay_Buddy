import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Per-venue notification preferences.
class VenueNotifyPrefs {
  final bool notifyCatch;
  final bool notifyConnections;

  const VenueNotifyPrefs({
    this.notifyCatch = false,
    this.notifyConnections = false,
  });

  VenueNotifyPrefs copyWith({bool? notifyCatch, bool? notifyConnections}) {
    return VenueNotifyPrefs(
      notifyCatch: notifyCatch ?? this.notifyCatch,
      notifyConnections: notifyConnections ?? this.notifyConnections,
    );
  }
}

/// Mutable favorites + per-venue notification state.
class FavoritesState {
  final Set<String> favoriteIds; // combined crag + gym IDs
  final Map<String, VenueNotifyPrefs> notifyPrefs;

  const FavoritesState({
    this.favoriteIds = const {},
    this.notifyPrefs = const {},
  });

  FavoritesState copyWith({
    Set<String>? favoriteIds,
    Map<String, VenueNotifyPrefs>? notifyPrefs,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      notifyPrefs: notifyPrefs ?? this.notifyPrefs,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier()
      : super(() {
          final user = MockData.getUserById(mockCurrentUserId);
          final ids = <String>{
            ...?user?.favoriteCragIds,
            ...?user?.favoriteGymIds,
          };
          return FavoritesState(favoriteIds: ids);
        }());

  void toggleFavorite(String venueId) {
    final updated = Set<String>.from(state.favoriteIds);
    if (updated.contains(venueId)) {
      updated.remove(venueId);
      // Also clear notification prefs when unfavoriting
      final prefs = Map<String, VenueNotifyPrefs>.from(state.notifyPrefs)
        ..remove(venueId);
      state = state.copyWith(favoriteIds: updated, notifyPrefs: prefs);
    } else {
      updated.add(venueId);
      state = state.copyWith(favoriteIds: updated);
    }
  }

  void toggleNotifyCatch(String venueId) {
    final prefs = Map<String, VenueNotifyPrefs>.from(state.notifyPrefs);
    final current = prefs[venueId] ?? const VenueNotifyPrefs();
    prefs[venueId] = current.copyWith(notifyCatch: !current.notifyCatch);
    state = state.copyWith(notifyPrefs: prefs);
  }

  void toggleNotifyConnections(String venueId) {
    final prefs = Map<String, VenueNotifyPrefs>.from(state.notifyPrefs);
    final current = prefs[venueId] ?? const VenueNotifyPrefs();
    prefs[venueId] =
        current.copyWith(notifyConnections: !current.notifyConnections);
    state = state.copyWith(notifyPrefs: prefs);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
  (ref) => FavoritesNotifier(),
);

/// Whether the current user has favorited a given venue (crag or gym).
final isFavoriteProvider = Provider.family<bool, String>((ref, venueId) {
  return ref.watch(favoritesProvider).favoriteIds.contains(venueId);
});

/// Notification prefs for a specific venue.
final venueNotifyPrefsProvider =
    Provider.family<VenueNotifyPrefs, String>((ref, venueId) {
  return ref.watch(favoritesProvider).notifyPrefs[venueId] ??
      const VenueNotifyPrefs();
});

/// Whether the current user has favorited a given crag.
final isFavoriteCragProvider = Provider.family<bool, String>((ref, cragId) {
  return ref.watch(isFavoriteProvider(cragId));
});

/// Whether the current user has favorited a given gym.
final isFavoriteGymProvider = Provider.family<bool, String>((ref, gymId) {
  return ref.watch(isFavoriteProvider(gymId));
});

/// All crags and gyms the current user has favorited.
final favoriteCragsProvider = StreamProvider<List<Crag>>((ref) {
  final ids = ref.watch(favoritesProvider).favoriteIds;
  if (ids.isEmpty) return Stream.value([]);
  return Stream.value(
    MockData.crags.where((c) => ids.contains(c.id)).toList(),
  );
});
