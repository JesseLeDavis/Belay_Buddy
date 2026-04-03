import 'package:belay_buddy/models/header_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches the HeaderConfig for a crag/gym.
/// Returns null when no custom config exists (use defaults).
/// Mock version always returns null — swap for Firestore fetch when ready.
final headerConfigProvider =
    FutureProvider.family<HeaderConfig?, String>((ref, cragId) async {
  // TODO: Replace with Firestore fetch when going live:
  // final doc = await FirebaseFirestore.instance
  //     .collection('headerConfigs')
  //     .doc(cragId)
  //     .get();
  // if (!doc.exists) return null;
  // return HeaderConfig.fromJson(doc.data()!);
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
