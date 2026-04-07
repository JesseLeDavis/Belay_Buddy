import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/venues/domain/header_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ============ CRAGS ============

/// All crags.
final allCragsProvider = StreamProvider<List<Crag>>((ref) {
  return Stream.value(MockData.crags);
});

/// Single crag by ID.
final cragProvider = FutureProvider.family<Crag?, String>((ref, cragId) async {
  return MockData.getCragById(cragId);
});

// ============ HEADER CONFIG ============

/// Fetches the HeaderConfig for a crag/gym.
/// Returns null when no custom config exists (use defaults).
/// Mock version always returns null — swap for Firestore fetch when ready.
final headerConfigProvider =
    FutureProvider.family<HeaderConfig?, String>((ref, cragId) async {
  return null;
});

/// Default panel slide delays (stagger effect, in milliseconds).
const _defaultDelays = [0.0, 80.0, 160.0, 240.0, 320.0, 400.0];

/// Resolves header panels for a crag. Returns 6 panels with either
/// remote asset URLs (from HeaderConfig) or null (meaning use bundled defaults).
final resolvedHeaderPanelsProvider =
    Provider.family<List<HeaderPanel>, String>((ref, cragId) {
  final config = ref.watch(headerConfigProvider(cragId)).valueOrNull;

  if (config != null && config.panels.length == 6) {
    return config.panels;
  }

  // Return 6 default panels (no assetUrl = use bundled SVGs)
  return List.generate(
    6,
    (i) => HeaderPanel(index: i, slideDelay: _defaultDelays[i]),
  );
});
