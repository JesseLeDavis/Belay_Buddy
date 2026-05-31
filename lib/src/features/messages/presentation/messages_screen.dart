import 'package:belay_buddy/src/common/data/mock_data.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/messages/data/messages_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final conversationsAsync = ref.watch(userConversationsProvider);
    final currentUserId = ref.watch(currentUserIdSyncProvider);

    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Chats',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) return _EmptyState();

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conv = conversations[index];
              final otherUserId = conv.participantIds.firstWhere(
                (id) => id != currentUserId,
                orElse: () => conv.participantIds.first,
              );
              final otherUser = MockData.getUserById(otherUserId);
              final isUnread = conv.isReadByUser[currentUserId] == false;

              return _ConversationRow(
                displayName: otherUser?.displayName ?? 'Unknown',
                lastMessage: conv.lastMessage ?? '',
                isUnread: isUnread,
                onTap: () => context.push('/messages/${conv.id}'),
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No chats yet.',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'When you say you’re coming to someone’s session, '
              'or they to yours, the conversation lands here.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: c.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationRow extends StatelessWidget {
  final String displayName;
  final String lastMessage;
  final bool isUnread;
  final VoidCallback onTap;

  const _ConversationRow({
    required this.displayName,
    required this.lastMessage,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.borderColor, width: 1.5),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _AvatarDot(
              initial: displayName.isNotEmpty
                  ? displayName[0].toLowerCase()
                  : '?',
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastMessage,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight:
                          isUnread ? FontWeight.w500 : FontWeight.w400,
                      color: isUnread ? c.ink : c.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: c.ink,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final String initial;
  const _AvatarDot({required this.initial});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}
