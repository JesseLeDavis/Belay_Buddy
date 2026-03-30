import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ USERS ============

  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromJson({...doc.data()!, 'uid': doc.id});
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Stream<AppUser?> userStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromJson({...doc.data()!, 'uid': doc.id});
    });
  }

  // ============ CRAGS ============

  Future<void> createCrag(Crag crag) async {
    await _firestore.collection('crags').doc(crag.id).set(crag.toJson());
  }

  Future<Crag?> getCrag(String cragId) async {
    final doc = await _firestore.collection('crags').doc(cragId).get();
    if (!doc.exists) return null;
    return Crag.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<List<Crag>> getAllCrags() async {
    final snapshot = await _firestore.collection('crags').get();
    return snapshot.docs
        .map((doc) => Crag.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Stream<List<Crag>> cragsStream() {
    return _firestore.collection('crags').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Crag.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get crags within a bounding box (for map view)
  Future<List<Crag>> getCragsInBounds({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    final snapshot = await _firestore
        .collection('crags')
        .where('location.latitude', isGreaterThanOrEqualTo: minLat)
        .where('location.latitude', isLessThanOrEqualTo: maxLat)
        .get();

    // Filter by longitude in memory (Firestore limitation)
    return snapshot.docs
        .map((doc) => Crag.fromJson({...doc.data(), 'id': doc.id}))
        .where((crag) =>
            crag.location.longitude >= minLng &&
            crag.location.longitude <= maxLng)
        .toList();
  }

  // ============ POSTS ============

  Future<String> createPost(ClimbingPost post) async {
    final docRef =
        await _firestore.collection('posts').add(post.toJson());
    return docRef.id;
  }

  Future<ClimbingPost?> getPost(String postId) async {
    final doc = await _firestore.collection('posts').doc(postId).get();
    if (!doc.exists) return null;
    return ClimbingPost.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _firestore.collection('posts').doc(postId).update(data);
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  // Get posts at a specific crag
  Stream<List<ClimbingPost>> postsAtCragStream(String cragId) {
    return _firestore
        .collection('posts')
        .where('cragId', isEqualTo: cragId)
        .where('expiresAt', isGreaterThan: DateTime.now())
        .orderBy('expiresAt')
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  ClimbingPost.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get all active posts
  Stream<List<ClimbingPost>> activePostsStream() {
    return _firestore
        .collection('posts')
        .where('expiresAt', isGreaterThan: DateTime.now())
        .orderBy('expiresAt')
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  ClimbingPost.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get user's posts
  Stream<List<ClimbingPost>> userPostsStream(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  ClimbingPost.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // ============ MESSAGES ============

  Future<String> createConversation(Conversation conversation) async {
    final docRef = await _firestore
        .collection('conversations')
        .add(conversation.toJson());
    return docRef.id;
  }

  Future<Conversation?> getConversation(String conversationId) async {
    final doc = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .get();
    if (!doc.exists) return null;
    return Conversation.fromJson({...doc.data()!, 'id': doc.id});
  }

  // Get or create conversation between two users
  Future<String> getOrCreateConversation(
      String user1Id, String user2Id) async {
    final participants = [user1Id, user2Id]..sort();

    final existing = await _firestore
        .collection('conversations')
        .where('participantIds', isEqualTo: participants)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id;
    }

    final conversation = Conversation(
      id: '',
      participantIds: participants,
      isReadByUser: {user1Id: true, user2Id: true},
      createdAt: DateTime.now(),
    );

    return await createConversation(conversation);
  }

  Stream<List<Conversation>> userConversationsStream(String userId) {
    return _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) =>
                  Conversation.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  Future<void> sendMessage(String conversationId, Message message) async {
    final batch = _firestore.batch();

    // Add message
    final messageRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(message.id);
    batch.set(messageRef, message.toJson());

    // Update conversation
    final convRef =
        _firestore.collection('conversations').doc(conversationId);
    batch.update(convRef, {
      'lastMessage': message.text,
      'lastMessageTime': message.timestamp,
      'isReadByUser.${message.senderId}': true,
    });

    await batch.commit();
  }

  Stream<List<Message>> messagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  Future<void> markConversationAsRead(
      String conversationId, String userId) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'isReadByUser.$userId': true,
    });
  }
}
