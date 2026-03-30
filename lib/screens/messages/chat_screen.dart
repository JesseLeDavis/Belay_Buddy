import 'package:belay_buddy/mock/mock_data.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Message sent',
          style: GoogleFonts.cabin(color: Colors.white, fontSize: 14),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));
    final currentUserId = ref.watch(currentUserIdSyncProvider);

    // Figure out the other user's name for the title
    final conversation = MockData.conversations.where(
      (c) => c.id == widget.conversationId,
    );
    String otherName = 'Chat';
    if (conversation.isNotEmpty) {
      final otherUserId = conversation.first.participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => conversation.first.participantIds.first,
      );
      otherName = MockData.getUserById(otherUserId)?.displayName ?? 'Chat';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          otherName.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'NO MESSAGES YET',
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;
                    final senderUser =
                        MockData.getUserById(msg.senderId);
                    final senderName =
                        senderUser?.displayName ?? 'Unknown';

                    return _ChatBubble(
                      senderName: senderName,
                      text: msg.text,
                      timestamp: msg.timestamp,
                      isMe: isMe,
                    );
                  },
                );
              },
              loading: () => Center(
                child: Text(
                  'LOADING...',
                  style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary),
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Error: $error',
                  style: GoogleFonts.cabin(
                      fontSize: 16, color: AppColors.error),
                ),
              ),
            ),
          ),

          // Input bar — cream background, 3px ink top border
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.chipBg,
              border: Border(
                top: BorderSide(color: AppColors.darkNavy, width: 3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.cabin(
                        fontSize: 14,
                        color: AppColors.textDisabled,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                            color: AppColors.darkNavy, width: 2),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                            color: AppColors.darkNavy, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                            color: AppColors.dullOrange, width: 2.5),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.dullOrange,
                    border: Border.all(
                        color: AppColors.darkNavy, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  const _ChatBubble({
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe ? AppColors.dullOrange : AppColors.surface,
              border: Border.all(
                color: AppColors.darkNavy,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.darkNavy,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppSpacing.sm + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName.toUpperCase(),
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isMe
                        ? Colors.white.withAlpha(200)
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.cabin(
                    fontSize: 14,
                    color: isMe ? Colors.white : AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(timestamp),
                  style: GoogleFonts.spaceMono(
                    fontSize: 9,
                    color: isMe
                        ? Colors.white.withAlpha(150)
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
