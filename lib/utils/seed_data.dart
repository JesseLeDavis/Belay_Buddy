import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/services/firestore_service.dart';

/// Helper to seed Firebase with popular climbing crags
/// Run this once from a debug screen or main.dart
Future<void> seedInitialCrags(FirestoreService firestoreService) async {
  final crags = [
    const Crag(
      id: 'red-rock-canyon',
      name: 'Red Rock Canyon',
      location: CragLocation(latitude: 36.1357, longitude: -115.4269),
      description:
          'World-class sport and trad climbing just outside Las Vegas. Over 2,000 routes across stunning red sandstone formations.',
      types: [CragType.sport, CragType.trad],
      region: 'Nevada',
      country: 'USA',
    ),
    const Crag(
      id: 'yosemite-valley',
      name: 'Yosemite Valley',
      location: CragLocation(latitude: 37.7459, longitude: -119.5332),
      description:
          'Legendary big wall climbing destination with iconic routes like El Capitan and Half Dome.',
      types: [CragType.trad, CragType.sport],
      region: 'California',
      country: 'USA',
    ),
    const Crag(
      id: 'joshua-tree',
      name: 'Joshua Tree National Park',
      location: CragLocation(latitude: 33.8734, longitude: -115.9010),
      description:
          'Desert wonderland with endless crack climbing and bouldering opportunities.',
      types: [CragType.trad, CragType.boulder],
      region: 'California',
      country: 'USA',
    ),
    const Crag(
      id: 'smith-rock',
      name: 'Smith Rock State Park',
      location: CragLocation(latitude: 44.3672, longitude: -121.1411),
      description:
          'Birthplace of American sport climbing with over 1,800 routes on welded tuff.',
      types: [CragType.sport, CragType.trad],
      region: 'Oregon',
      country: 'USA',
    ),
    const Crag(
      id: 'red-river-gorge',
      name: 'Red River Gorge',
      location: CragLocation(latitude: 37.7661, longitude: -83.6828),
      description:
          'Dense concentration of sport climbing routes on steep sandstone. Home to thousands of routes.',
      types: [CragType.sport],
      region: 'Kentucky',
      country: 'USA',
    ),
    const Crag(
      id: 'hueco-tanks',
      name: 'Hueco Tanks',
      location: CragLocation(latitude: 31.9164, longitude: -106.0431),
      description:
          'World-renowned bouldering destination with classic problems on volcanic rock.',
      types: [CragType.boulder],
      region: 'Texas',
      country: 'USA',
    ),
    const Crag(
      id: 'new-river-gorge',
      name: 'New River Gorge',
      location: CragLocation(latitude: 38.0690, longitude: -81.0780),
      description:
          'East Coast sport climbing paradise with over 1,400 routes on solid sandstone.',
      types: [CragType.sport, CragType.trad],
      region: 'West Virginia',
      country: 'USA',
    ),
    const Crag(
      id: 'bishop',
      name: 'Bishop Buttermilks',
      location: CragLocation(latitude: 37.3733, longitude: -118.5517),
      description:
          'Premier bouldering area with stunning Sierra Nevada backdrop. High-quality volcanic rock.',
      types: [CragType.boulder],
      region: 'California',
      country: 'USA',
    ),
  ];

  for (final crag in crags) {
    try {
      await firestoreService.createCrag(crag);
      // ignore: avoid_print
      print('✓ Seeded ${crag.name}');
    } catch (e) {
      // ignore: avoid_print
      print('✗ Error seeding ${crag.name}: $e');
    }
  }
  // ignore: avoid_print
  print('\n✓ Seeding complete! ${crags.length} crags added.');
}
