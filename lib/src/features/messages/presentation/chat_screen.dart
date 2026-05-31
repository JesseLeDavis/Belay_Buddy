import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/messages/data/messages_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
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
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

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
          'sending coming soon',
          style: GoogleFonts.inter(
            color: context.appColors.canvas,
            fontSize: 14,
          ),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));
    final currentUserId = ref.watch(currentUserIdSyncProvider);

    final conversation =
        MockData.conversations.where((conv) => conv.id == widget.conversationId);
    String otherName = 'Chat';
    if (conversation.isNotEmpty) {
      final otherUserId = conversation.first.participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => conversation.first.participantIds.first,
      );
      otherName = MockData.getUserById(otherUserId)?.displayName ?? 'Chat';
    }

    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          otherName,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'no messages yet',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: c.textDisabled,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;
                    return _ChatBubble(
                      text: msg.text,
                      timestamp: msg.timestamp,
                      isMe: isMe,
                    );
                  },
                );
              },
              loading: () => Center(
                child: Text(
                  'loading…',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'error: $error',
                  style: GoogleFonts.inter(fontSize: 14, color: c.error),
                ),
              ),
            ),
          ),
          _InputBar(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final DateTime timestamp;
  final bool isMe;

  const _ChatBubble({
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.74,
            ),
            decoration: BoxDecoration(
              color: isMe ? c.ink : c.canvas,
              border: Border.all(color: c.ink, width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isMe ? c.canvas : c.ink,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('h:mm a').format(timestamp).toLowerCase(),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: c.textDisabled,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final hasText = controller.text.trim().isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: c.canvas,
        border: Border(
          top: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 16),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.inter(fontSize: 14, color: c.ink),
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'message…',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: c.textDisabled,
                  ),
                  filled: true,
                  fillColor: c.canvas,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(color: c.borderColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(color: c.borderColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(color: c.borderColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: hasText ? onSend : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: hasText ? c.ink : c.canvas,
                  border: Border.all(
                    color: hasText ? c.ink : c.textDisabled,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_upward,
                  size: 18,
                  color: hasText ? c.canvas : c.textDisabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
