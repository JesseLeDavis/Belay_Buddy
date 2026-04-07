import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/messages/domain/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All conversations for the current user.
final userConversationsProvider =
    StreamProvider<List<Conversation>>((ref) {
  final userId = ref.watch(currentUserIdSyncProvider);
  if (userId == null) return Stream.value([]);
  return Stream.value(MockData.getConversationsForUser(userId));
});

/// Messages in a conversation.
final messagesProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
  return Stream.value(MockData.getMessagesForConversation(conversationId));
});
