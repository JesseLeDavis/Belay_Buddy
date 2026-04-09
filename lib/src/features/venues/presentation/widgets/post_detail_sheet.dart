import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/lost_found/presentation/lost_found_screen.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PostDetailSheet extends ConsumerWidget {
  final ClimbingPost post;
  const PostDetailSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(userByIdProvider(post.userId));

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: c.surface,
            border:
                Border(top: BorderSide(color: c.borderColor, width: 3)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.sm,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        color: c.borderColor.withAlpha(80)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: post.type == PostType.immediate
                              ? c.dullOrange
                              : c.oliveGreen,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: c.borderColor, width: 2),
                        ),
                        child: Text(
                          post.type == PostType.immediate
                              ? '● NOW'
                              : '◆ SCHEDULED',
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: c.textOnPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          post.title,
                          style: GoogleFonts.spaceMono(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (post.description != null &&
                      post.description!.isNotEmpty) ...[
                    Text(
                      post.description!,
                      style: GoogleFonts.cabin(
                          fontSize: 14,
                          color: c.textSecondary,
                          height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 16, color: c.amber),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _formatFullDateTime(post.dateTime),
                        style: GoogleFonts.spaceMono(
                            fontSize: 12, color: c.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      if (post.needsBelay)
                        _detailChip(context, 'NEED BELAY', c.accentBlue),
                      if (post.offeringBelay)
                        _detailChip(context, 'CAN BELAY', c.oliveGreen),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Divider(color: c.borderColor, thickness: 1),
                  const SizedBox(height: AppSpacing.sm),
                  userAsync.when(
                    data: (user) => GestureDetector(
                      onTap: user != null
                          ? () {
                              Navigator.of(context).pop();
                              context.push('/profile/${user.uid}');
                            }
                          : null,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: c.borderColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user?.displayName.isNotEmpty == true
                                    ? user!.displayName[0].toUpperCase()
                                    : '?',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: c.background,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? 'Unknown Climber',
                                  style: GoogleFonts.cabin(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: c.textPrimary,
                                  ),
                                ),
                                if (user != null)
                                  Text(
                                    user.climbingStyles
                                        .map(_styleName)
                                        .join(' · '),
                                    style: GoogleFonts.spaceMono(
                                        fontSize: 11,
                                        color: c.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox(height: 40),
                    error: (_, __) => Text('Unknown Climber',
                        style: GoogleFonts.cabin(
                            fontSize: 16, color: c.textDisabled)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PostActionButtons(post: post, userAsync: userAsync),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailChip(BuildContext context, String label, Color color) {
    final c = context.appColors;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
          color: color),
      child: Text(label,
          style: GoogleFonts.spaceMono(
              fontSize: 11, fontWeight: FontWeight.w700, color: c.textOnPrimary)),
    );
  }

  String _formatFullDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.isNegative) {
      final f = dt.difference(now);
      if (f.inMinutes < 60) return 'in ${f.inMinutes}m';
      if (f.inHours < 24) return 'in ${f.inHours}h';
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dt);
    } else {
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dt);
    }
  }

  String _styleName(dynamic style) {
    const names = {
      'sport': 'Sport',
      'trad': 'Trad',
      'boulder': 'Boulder',
      'all': 'All Styles',
    };
    return names[style.toString().split('.').last] ?? style.toString();
  }
}

class _PostActionButtons extends ConsumerStatefulWidget {
  final ClimbingPost post;
  final AsyncValue<AppUser?> userAsync;

  const _PostActionButtons({required this.post, required this.userAsync});

  @override
  ConsumerState<_PostActionButtons> createState() => _PostActionButtonsState();
}

class _PostActionButtonsState extends ConsumerState<_PostActionButtons> {
  bool _connectRequestSent = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final currentUserId = ref.watch(currentUserIdSyncProvider);
    final isOwnPost = widget.post.userId == currentUserId;
    final isConnected = ref.watch(isConnectedProvider(widget.post.userId));
    final posterName = widget.userAsync.asData?.value?.displayName ?? 'CLIMBER';

    if (isOwnPost) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: c.borderColor,
            foregroundColor: c.background,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: c.borderColor, width: 2.5)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Message sent to $posterName',
                style: GoogleFonts.cabin(color: c.textOnPrimary, fontSize: 14),
              ),
            ));
          },
          icon: const Icon(Icons.chat_bubble_outline),
          label: Text(
            'MESSAGE ${posterName.toUpperCase()}',
            style: GoogleFonts.spaceMono(
                fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (!isConnected)
          GestureDetector(
            onTap: _connectRequestSent
                ? null
                : () {
                    setState(() => _connectRequestSent = true);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Connection request sent to $posterName',
                        style: GoogleFonts.cabin(
                            color: c.textOnPrimary, fontSize: 14),
                      ),
                      backgroundColor: c.accentBlue,
                    ));
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _connectRequestSent
                    ? c.chipBg
                    : c.accentBlue,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: c.borderColor, width: 2.5),
                boxShadow: _connectRequestSent
                    ? null
                    : [
                        BoxShadow(
                            color: c.shadowColor,
                            offset: const Offset(4, 4),
                            blurRadius: 0)
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _connectRequestSent
                        ? Icons.hourglass_empty
                        : Icons.person_add_outlined,
                    size: 16,
                    color: _connectRequestSent
                        ? c.textSecondary
                        : c.textOnPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _connectRequestSent
                        ? 'REQUEST SENT'
                        : 'CONNECT WITH ${posterName.toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _connectRequestSent
                          ? c.textSecondary
                          : c.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: c.oliveGreen,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: c.borderColor, width: 2.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 16, color: c.textOnPrimary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'CONNECTED WITH ${posterName.toUpperCase()}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PostTypeSheet extends StatelessWidget {
  final Crag crag;
  const PostTypeSheet({super.key, required this.crag});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.borderColor, width: 3)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
                width: 40, height: 4, color: c.borderColor.withAlpha(80)),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'WHAT DO YOU WANT TO POST?',
              style: GoogleFonts.spaceMono(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PostTypeOption(
            accentColor: c.oliveGreen,
            icon: Icons.group_outlined,
            title: 'PARTNER SESSION',
            subtitle: 'Find someone to climb with on a specific day',
            onTap: () {
              Navigator.of(context).pop();
              context.push('/crag/${crag.id}/post', extra: crag);
            },
          ),
          if (!crag.isGym) ...[
            Divider(height: 1, thickness: 1, color: c.borderColor),
            _PostTypeOption(
              accentColor: c.amber,
              icon: Icons.inventory_2_outlined,
              title: 'LOST & FOUND',
              subtitle: 'Report a found item or post a lookout request',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LostFoundScreen(cragId: crag.id),
                ));
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PostTypeOption extends StatelessWidget {
  final Color accentColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PostTypeOption({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(width: 4, height: 48, color: accentColor),
            const SizedBox(width: AppSpacing.md),
            Icon(icon, size: 24, color: accentColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.cabin(
                        fontSize: 13, color: c.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: c.textPrimary),
          ],
        ),
      ),
    );
  }
}
