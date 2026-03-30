import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/models/message.dart';

/// The mock "current user" ID used throughout the app.
const String mockCurrentUserId = 'user_1';

class MockData {
  MockData._();

  // ============ USERS ============

  static final List<AppUser> users = [
    AppUser(
      uid: 'user_1',
      email: 'alex@climbing.io',
      displayName: 'Alex Honnold Jr',
      bio: 'Weekend warrior. Sport climber trying to learn trad.',
      experienceLevel: ExperienceLevel.intermediate,
      climbingStyles: [ClimbingStyle.sport, ClimbingStyle.trad],
      favoriteCragIds: ['crag_red_rocks', 'crag_smith_rock'],
      createdAt: DateTime(2025, 1, 15),
      lastActive: DateTime.now(),
    ),
    AppUser(
      uid: 'user_2',
      email: 'maya@sends.com',
      displayName: 'Maya Sendsalot',
      bio: 'Boulder rat. Will trade spotting for snacks.',
      experienceLevel: ExperienceLevel.advanced,
      climbingStyles: [ClimbingStyle.boulder, ClimbingStyle.sport],
      favoriteCragIds: ['crag_eldorado', 'crag_rumney'],
      createdAt: DateTime(2024, 11, 3),
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppUser(
      uid: 'user_3',
      email: 'carlos@crag.net',
      displayName: 'Carlos Trad-Dad',
      bio: 'Trad dad energy. Rack jangler. Cam whisperer.',
      experienceLevel: ExperienceLevel.expert,
      climbingStyles: [ClimbingStyle.trad],
      favoriteCragIds: ['crag_yosemite', 'crag_eldorado'],
      createdAt: DateTime(2024, 6, 20),
      lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    AppUser(
      uid: 'user_4',
      email: 'priya@beta.io',
      displayName: 'Priya Betaspray',
      bio: 'New to outdoor climbing, eager to learn!',
      experienceLevel: ExperienceLevel.beginner,
      climbingStyles: [ClimbingStyle.all],
      favoriteCragIds: ['crag_red_rocks'],
      createdAt: DateTime(2025, 3, 1),
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ============ CRAGS ============

  static final List<Crag> crags = [
    Crag(
      id: 'crag_red_rocks',
      name: 'Red Rocks',
      location: const CragLocation(latitude: 36.1357, longitude: -115.4269),
      description:
          'World-class sandstone sport and trad climbing in the Mojave Desert outside Las Vegas.',
      types: [CragType.sport, CragType.trad],
      region: 'Nevada, USA',
      country: 'US',
      activeClimbersCount: 12,
      createdAt: DateTime(2024, 1, 1),
    ),
    Crag(
      id: 'crag_yosemite',
      name: 'Yosemite Valley',
      location: const CragLocation(latitude: 37.7459, longitude: -119.5332),
      description:
          'The birthplace of American big-wall climbing. Granite domes and El Capitan await.',
      types: [CragType.trad, CragType.sport, CragType.boulder],
      region: 'California, USA',
      country: 'US',
      activeClimbersCount: 8,
      createdAt: DateTime(2024, 1, 1),
    ),
    Crag(
      id: 'crag_eldorado',
      name: 'Eldorado Canyon',
      location: const CragLocation(latitude: 39.9314, longitude: -105.2830),
      description:
          'Classic Colorado sandstone with steep trad routes and stunning Front Range views.',
      types: [CragType.trad, CragType.sport],
      region: 'Colorado, USA',
      country: 'US',
      activeClimbersCount: 5,
      createdAt: DateTime(2024, 1, 1),
    ),
    Crag(
      id: 'crag_rumney',
      name: 'Rumney',
      location: const CragLocation(latitude: 43.8048, longitude: -71.8123),
      description:
          'Premier New England sport crag with pocketed schist walls and year-round climbing.',
      types: [CragType.sport],
      region: 'New Hampshire, USA',
      country: 'US',
      activeClimbersCount: 3,
      createdAt: DateTime(2024, 1, 1),
    ),
    Crag(
      id: 'crag_smith_rock',
      name: 'Smith Rock',
      location: const CragLocation(latitude: 44.3682, longitude: -121.1426),
      description:
          'Iconic Oregon welded tuff towers. The birthplace of American sport climbing.',
      types: [CragType.sport, CragType.trad, CragType.boulder],
      region: 'Oregon, USA',
      country: 'US',
      activeClimbersCount: 7,
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  // ============ POSTS ============

  static final List<ClimbingPost> posts = [
    // Red Rocks posts
    ClimbingPost(
      id: 'post_1',
      userId: 'user_1',
      cragId: 'crag_red_rocks',
      title: 'Looking for belay partner at Calico Basin',
      description: 'Planning to hit some 5.10s this afternoon. Got a 70m rope.',
      dateTime: DateTime.now().subtract(const Duration(minutes: 30)),
      type: PostType.immediate,
      needsBelay: true,
      offeringBelay: false,
      expiresAt: DateTime.now().add(const Duration(hours: 11)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ClimbingPost(
      id: 'post_2',
      userId: 'user_4',
      cragId: 'crag_red_rocks',
      title: 'Beginner seeking mentor for first outdoor lead',
      description:
          'I can top-rope 5.9 comfortably. Would love someone patient to show me the ropes (literally).',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      type: PostType.scheduled,
      needsBelay: true,
      offeringBelay: false,
      expiresAt: DateTime.now().add(const Duration(days: 2, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ClimbingPost(
      id: 'post_3',
      userId: 'user_2',
      cragId: 'crag_red_rocks',
      title: 'Free belays! Happy to help anyone',
      description: 'Resting my fingers today but happy to belay if you need it.',
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      type: PostType.immediate,
      needsBelay: false,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(hours: 10)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // Yosemite posts
    ClimbingPost(
      id: 'post_4',
      userId: 'user_3',
      cragId: 'crag_yosemite',
      title: 'Multi-pitch partner for The Nose?',
      description:
          'Looking for someone to attempt The Nose in a day. Must lead 5.12 trad comfortably.',
      dateTime: DateTime.now().add(const Duration(days: 5)),
      type: PostType.scheduled,
      needsBelay: true,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(days: 5, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    ClimbingPost(
      id: 'post_5',
      userId: 'user_1',
      cragId: 'crag_yosemite',
      title: 'Bouldering at Camp 4 today',
      description: 'Working the Midnight Lightning sit start. Come hang!',
      dateTime: DateTime.now(),
      type: PostType.immediate,
      needsBelay: false,
      offeringBelay: false,
      expiresAt: DateTime.now().add(const Duration(hours: 12)),
      createdAt: DateTime.now(),
    ),
    ClimbingPost(
      id: 'post_6',
      userId: 'user_2',
      cragId: 'crag_yosemite',
      title: 'Sport climbing at Cookie Cliff',
      description: 'Projecting Cosmic Debris. Could use a belay buddy!',
      dateTime: DateTime.now().add(const Duration(hours: 3)),
      type: PostType.scheduled,
      needsBelay: true,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(hours: 5)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // Eldorado Canyon posts
    ClimbingPost(
      id: 'post_7',
      userId: 'user_3',
      cragId: 'crag_eldorado',
      title: 'Bastille Crack this weekend',
      description: 'Classic 5.7 trad. I have a full rack. Just need a partner.',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      type: PostType.scheduled,
      needsBelay: true,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(days: 3, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    ClimbingPost(
      id: 'post_8',
      userId: 'user_4',
      cragId: 'crag_eldorado',
      title: 'Anyone top-roping Wind Tower?',
      description: 'First time at Eldo! Would love company.',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      type: PostType.scheduled,
      needsBelay: true,
      offeringBelay: false,
      expiresAt: DateTime.now().add(const Duration(days: 1, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),

    // Rumney posts
    ClimbingPost(
      id: 'post_9',
      userId: 'user_2',
      cragId: 'crag_rumney',
      title: 'Sending temps at Waimea Wall',
      description: 'Perfect fall friction. Let\'s crush some pockets!',
      dateTime: DateTime.now(),
      type: PostType.immediate,
      needsBelay: true,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(hours: 12)),
      createdAt: DateTime.now(),
    ),
    ClimbingPost(
      id: 'post_10',
      userId: 'user_1',
      cragId: 'crag_rumney',
      title: 'Weekend warrior looking for crew',
      description: 'Driving up Saturday AM. Room in the car for 2.',
      dateTime: DateTime.now().add(const Duration(days: 4)),
      type: PostType.scheduled,
      needsBelay: false,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(days: 4, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),

    // Smith Rock posts
    ClimbingPost(
      id: 'post_11',
      userId: 'user_3',
      cragId: 'crag_smith_rock',
      title: 'Chain Reaction project sesh',
      description: 'Working the crux on 5.12c. Patient belayer needed!',
      dateTime: DateTime.now().subtract(const Duration(minutes: 15)),
      type: PostType.immediate,
      needsBelay: true,
      offeringBelay: false,
      expiresAt: DateTime.now().add(const Duration(hours: 11)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ClimbingPost(
      id: 'post_12',
      userId: 'user_4',
      cragId: 'crag_smith_rock',
      title: 'Morning session at the Dihedrals',
      description: 'Easy trad and moderate sport. All levels welcome.',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      type: PostType.scheduled,
      needsBelay: true,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(days: 1, hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ClimbingPost(
      id: 'post_13',
      userId: 'user_2',
      cragId: 'crag_smith_rock',
      title: 'Bouldering at Monkey Face base',
      description: 'Warm-up boulders then maybe lead some routes. Down for anything.',
      dateTime: DateTime.now().add(const Duration(hours: 5)),
      type: PostType.scheduled,
      needsBelay: false,
      offeringBelay: true,
      expiresAt: DateTime.now().add(const Duration(hours: 7)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  // ============ CONVERSATIONS ============

  static final List<Conversation> conversations = [
    Conversation(
      id: 'conv_1',
      participantIds: ['user_1', 'user_2'],
      lastMessage: 'See you at the crag tomorrow!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      isReadByUser: {'user_1': false, 'user_2': true},
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Conversation(
      id: 'conv_2',
      participantIds: ['user_1', 'user_3'],
      lastMessage: 'I have a full trad rack we can use',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      isReadByUser: {'user_1': true, 'user_3': true},
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Conversation(
      id: 'conv_3',
      participantIds: ['user_1', 'user_4'],
      lastMessage: 'Thanks for the beta on that route!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      isReadByUser: {'user_1': true, 'user_4': false},
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // ============ MESSAGES ============

  static final List<Message> messages = [
    // Conversation 1: user_1 <-> user_2
    Message(
      id: 'msg_1_1',
      conversationId: 'conv_1',
      senderId: 'user_1',
      text: 'Hey! Saw your post about Red Rocks. I\'m heading there tomorrow.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    Message(
      id: 'msg_1_2',
      conversationId: 'conv_1',
      senderId: 'user_2',
      text: 'Awesome! What time are you thinking?',
      timestamp:
          DateTime.now().subtract(const Duration(days: 1, hours: 23)),
      isRead: true,
    ),
    Message(
      id: 'msg_1_3',
      conversationId: 'conv_1',
      senderId: 'user_1',
      text: 'Early start, maybe 7am? Beat the heat.',
      timestamp:
          DateTime.now().subtract(const Duration(days: 1, hours: 22)),
      isRead: true,
    ),
    Message(
      id: 'msg_1_4',
      conversationId: 'conv_1',
      senderId: 'user_2',
      text: 'Perfect. I\'ll bring extra water and snacks.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    Message(
      id: 'msg_1_5',
      conversationId: 'conv_1',
      senderId: 'user_2',
      text: 'See you at the crag tomorrow!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
    ),

    // Conversation 2: user_1 <-> user_3
    Message(
      id: 'msg_2_1',
      conversationId: 'conv_2',
      senderId: 'user_3',
      text: 'Yo, want to hit Bastille Crack this weekend?',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
    Message(
      id: 'msg_2_2',
      conversationId: 'conv_2',
      senderId: 'user_1',
      text: 'Dude yes! I\'ve been wanting to do that route forever.',
      timestamp:
          DateTime.now().subtract(const Duration(days: 4, hours: 20)),
      isRead: true,
    ),
    Message(
      id: 'msg_2_3',
      conversationId: 'conv_2',
      senderId: 'user_3',
      text: 'I have a full trad rack we can use',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),

    // Conversation 3: user_1 <-> user_4
    Message(
      id: 'msg_3_1',
      conversationId: 'conv_3',
      senderId: 'user_4',
      text: 'Hi! I saw you climb at Red Rocks. Any tips for a beginner?',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    Message(
      id: 'msg_3_2',
      conversationId: 'conv_3',
      senderId: 'user_1',
      text: 'Start with the 5.6-5.8 routes at Calico Basin. Great warm-ups!',
      timestamp:
          DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      isRead: true,
    ),
    Message(
      id: 'msg_3_3',
      conversationId: 'conv_3',
      senderId: 'user_4',
      text: 'Thanks for the beta on that route!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  /// Helper: get user by ID
  static AppUser? getUserById(String uid) {
    try {
      return users.firstWhere((u) => u.uid == uid);
    } catch (_) {
      return null;
    }
  }

  /// Helper: get crag by ID
  static Crag? getCragById(String id) {
    try {
      return crags.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Helper: get posts for a crag
  static List<ClimbingPost> getPostsForCrag(String cragId) {
    return posts.where((p) => p.cragId == cragId).toList();
  }

  /// Helper: get messages for a conversation
  static List<Message> getMessagesForConversation(String conversationId) {
    return messages
        .where((m) => m.conversationId == conversationId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Helper: get conversations for a user
  static List<Conversation> getConversationsForUser(String userId) {
    return conversations
        .where((c) => c.participantIds.contains(userId))
        .toList()
      ..sort((a, b) =>
          (b.lastMessageTime ?? DateTime(2000))
              .compareTo(a.lastMessageTime ?? DateTime(2000)));
  }
}
