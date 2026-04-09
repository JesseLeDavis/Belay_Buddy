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
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'MESSAGES',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.borderColor,
          ),
        ),
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: c.textDisabled,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'NO CONVERSATIONS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textDisabled,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Tap a post to start chatting',
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      color: c.textDisabled,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conv = conversations[index];
              final otherUserId = conv.participantIds.firstWhere(
                (id) => id != currentUserId,
                orElse: () => conv.participantIds.first,
              );
              final otherUser = MockData.getUserById(otherUserId);
              final isUnread =
                  conv.isReadByUser[currentUserId] == false;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ConversationCard(
                  displayName: otherUser?.displayName ?? 'Unknown',
                  lastMessage: conv.lastMessage ?? '',
                  isUnread: isUnread,
                  onTap: () {
                    context.push('/messages/${conv.id}');
                  },
                ),
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
              color: c.textSecondary,
            ),
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.cabin(fontSize: 16, color: c.error),
          ),
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final String displayName;
  final String lastMessage;
  final bool isUnread;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.displayName,
    required this.lastMessage,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: c.shadowColor,
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored top strip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
                vertical: 8,
              ),
              color: isUnread ? c.amber : c.oliveGreen,
              child: Row(
                children: [
                  Text(
                    isUnread ? '\u25CF NEW MESSAGE' : 'MESSAGE',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isUnread ? c.textPrimary : c.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.borderColor,
                      border: Border.all(
                          color: c.borderColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.spaceMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: c.background,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: GoogleFonts.cabin(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lastMessage,
                          style: GoogleFonts.cabin(
                            fontSize: 13,
                            color: c.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: c.textPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
