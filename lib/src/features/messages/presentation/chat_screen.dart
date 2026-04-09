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
    final c = context.appColors;
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));
    final currentUserId = ref.watch(currentUserIdSyncProvider);

    // Figure out the other user's name for the title
    final conversation = MockData.conversations.where(
      (conv) => conv.id == widget.conversationId,
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
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          otherName.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.borderColor,
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
                        color: c.textDisabled,
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
                      color: c.textSecondary),
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Error: $error',
                  style: GoogleFonts.cabin(
                      fontSize: 16, color: c.error),
                ),
              ),
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.chipBg,
              border: Border(
                top: BorderSide(color: c.borderColor, width: 3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      color: c.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.cabin(
                        fontSize: 14,
                        color: c.textDisabled,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: BorderSide(
                            color: c.borderColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: BorderSide(
                            color: c.borderColor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: BorderSide(
                            color: c.dullOrange, width: 2.5),
                      ),
                      filled: true,
                      fillColor: c.surface,
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
                    color: c.dullOrange,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                        color: c.borderColor, width: 2),
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
    final c = context.appColors;
    final bubbleColor = isMe ? c.dullOrange : c.surface;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md + 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Shadow layer (hard offset, drawn behind)
              Positioned(
                top: 3,
                left: 3,
                right: -3,
                bottom: -3,
                child: Container(color: c.shadowColor),
              ),

              // Tail — behind the bubble so the bottom border hides the seam
              Positioned(
                bottom: -10,
                left: isMe ? null : 12,
                right: isMe ? 12 : null,
                child: CustomPaint(
                  size: const Size(16, 12),
                  painter: _TailPainter(
                    isMe: isMe,
                    color: bubbleColor,
                    borderColor: c.borderColor,
                    shadowColor: c.shadowColor,
                  ),
                ),
              ),

              // Bubble
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.md),
                    topRight: const Radius.circular(AppRadius.md),
                    bottomLeft: Radius.circular(isMe ? AppRadius.md : AppRadius.xs),
                    bottomRight: Radius.circular(isMe ? AppRadius.xs : AppRadius.md),
                  ),
                  border: Border.all(color: c.borderColor, width: 2),
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
                            : c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: GoogleFonts.cabin(
                        fontSize: 14,
                        color: isMe ? Colors.white : c.textPrimary,
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
                            : c.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TailPainter extends CustomPainter {
  final bool isMe;
  final Color color;
  final Color borderColor;
  final Color shadowColor;

  const _TailPainter({
    required this.isMe,
    required this.color,
    required this.borderColor,
    required this.shadowColor,
  });

  Path _buildTailPath(Size size, {double dx = 0, double dy = 0}) {
    final path = Path();
    if (isMe) {
      path.moveTo(dx, dy);
      path.lineTo(size.width + dx, dy);
      path.lineTo(size.width + dx, size.height + dy);
      path.close();
    } else {
      path.moveTo(dx, dy);
      path.lineTo(size.width + dx, dy);
      path.lineTo(dx, size.height + dy);
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Hard-offset shadow (matches bubble shadow)
    canvas.drawPath(
      _buildTailPath(size, dx: 3, dy: 3),
      Paint()
        ..color = shadowColor
        ..style = PaintingStyle.fill,
    );

    // Fill
    canvas.drawPath(
      _buildTailPath(size),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // Border — only the two outer edges (top edge hidden by bubble)
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.miter;

    final outerPath = Path();
    if (isMe) {
      outerPath.moveTo(0, 0);
      outerPath.lineTo(size.width, size.height);
      outerPath.lineTo(size.width, 0);
    } else {
      outerPath.moveTo(size.width, 0);
      outerPath.lineTo(0, size.height);
      outerPath.lineTo(0, 0);
    }
    canvas.drawPath(outerPath, borderPaint);
  }

  @override
  bool shouldRepaint(_TailPainter old) =>
      old.isMe != isMe || old.color != color || old.borderColor != borderColor;
}
