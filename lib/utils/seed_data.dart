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

    // Gyms
    const Crag(
      id: 'movement-denver',
      name: 'Movement Denver',
      location: CragLocation(latitude: 39.7661, longitude: -104.9759),
      description: 'Premier bouldering gym with world-class setting routes and a strong community.',
      types: [CragType.boulder],
      region: 'Colorado',
      country: 'USA',
      isGym: true,
    ),
    const Crag(
      id: 'brooklyn-boulders-nyc',
      name: 'Brooklyn Boulders',
      location: CragLocation(latitude: 40.6892, longitude: -73.9442),
      description: 'NYC\'s flagship climbing gym with bouldering, top rope, and lead walls.',
      types: [CragType.boulder, CragType.sport],
      region: 'New York',
      country: 'USA',
      isGym: true,
    ),
    const Crag(
      id: 'earth-treks-columbia',
      name: 'Earth Treks Columbia',
      location: CragLocation(latitude: 39.2037, longitude: -76.8610),
      description: 'One of the largest climbing gyms on the East Coast with extensive lead and bouldering walls.',
      types: [CragType.sport, CragType.boulder],
      region: 'Maryland',
      country: 'USA',
      isGym: true,
    ),
    const Crag(
      id: 'sender-one-santa-ana',
      name: 'Sender One Santa Ana',
      location: CragLocation(latitude: 33.7175, longitude: -117.8311),
      description: 'World-class training facility and climbing gym with extensive route variety.',
      types: [CragType.sport, CragType.boulder],
      region: 'California',
      country: 'USA',
      isGym: true,
    ),
    const Crag(
      id: 'mesa-rim-san-diego',
      name: 'Mesa Rim San Diego',
      location: CragLocation(latitude: 32.8328, longitude: -117.1341),
      description: 'Modern climbing gym with top rope, lead, and bouldering in a great San Diego location.',
      types: [CragType.sport, CragType.boulder],
      region: 'California',
      country: 'USA',
      isGym: true,
    ),
    const Crag(
      id: 'planet-granite-sf',
      name: 'Planet Granite San Francisco',
      location: CragLocation(latitude: 37.7749, longitude: -122.3894),
      description: 'Bay Area institution with top rope, lead, and bouldering plus a strong training culture.',
      types: [CragType.sport, CragType.boulder, CragType.trad],
      region: 'California',
      country: 'USA',
      isGym: true,
    ),
    const Crag(
      id: 'stone-gardens-seattle',
      name: 'Stone Gardens Seattle',
      location: CragLocation(latitude: 47.6062, longitude: -122.3321),
      description: 'Seattle\'s classic climbing gym with a loyal community and strong competition history.',
      types: [CragType.sport, CragType.boulder],
      region: 'Washington',
      country: 'USA',
      isGym: true,
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
