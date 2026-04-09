import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(userByIdProvider(userId));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.borderColor,
          ),
        ),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text(
                'USER NOT FOUND',
                style: GoogleFonts.spaceMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.error),
              ),
            );
          }
          return _UserProfileBody(user: user);
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
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: GoogleFonts.cabin(fontSize: 16, color: c.error),
          ),
        ),
      ),
    );
  }
}

class _UserProfileBody extends ConsumerStatefulWidget {
  final AppUser user;
  const _UserProfileBody({required this.user});

  @override
  ConsumerState<_UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends ConsumerState<_UserProfileBody> {
  bool _requestSent = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final user = widget.user;
    final isConnected = ref.watch(isConnectedProvider(user.uid));
    final hasPending = ref.watch(hasPendingRequestFromProvider(user.uid));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: _avatarColor(c, user.uid),
                    shape: BoxShape.circle,
                    border: Border.all(color: c.borderColor, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      user.displayName.isNotEmpty
                          ? user.displayName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.spaceMono(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: c.textOnPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  user.displayName,
                  style: GoogleFonts.spaceMono(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                if (user.bio != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    user.bio!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      color: c.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildConnectionButton(
                    context, c, user, isConnected, hasPending),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Messaging coming soon!',
                        style:
                            GoogleFonts.cabin(color: c.textOnPrimary, fontSize: 14),
                      ),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: c.surface,
                      border: Border.all(color: c.borderColor, width: 2.5),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      boxShadow: [
                        BoxShadow(
                          color: c.shadowColor,
                          offset: const Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 16, color: c.textPrimary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'MESSAGE',
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Sticker tags
          if (user.climbingTags.isNotEmpty) ...[
            _StickerTagsSection(tags: user.climbingTags),
            const SizedBox(height: AppSpacing.md),
          ],

          // Mutual connections
          _MutualConnectionsSection(userId: user.uid),
        ],
      ),
    );
  }

  Widget _buildConnectionButton(
      BuildContext context, AppColorsExtension c, AppUser user, bool isConnected, bool hasPending) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;
    VoidCallback? onTap;

    if (isConnected) {
      bgColor = c.oliveGreen;
      textColor = c.textOnPrimary;
      label = 'CONNECTED';
      icon = Icons.check;
      onTap = null;
    } else if (hasPending || _requestSent) {
      bgColor = c.chipBg;
      textColor = c.textSecondary;
      label = 'PENDING';
      icon = Icons.schedule;
      onTap = null;
    } else {
      bgColor = c.accentBlue;
      textColor = c.textOnPrimary;
      label = 'CONNECT';
      icon = Icons.person_add_outlined;
      onTap = () {
        setState(() => _requestSent = true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Connection request sent to ${user.displayName}',
            style: GoogleFonts.cabin(color: c.textOnPrimary, fontSize: 14),
          ),
          backgroundColor: c.accentBlue,
        ));
      };
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: c.borderColor, width: 2.5),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: c.shadowColor,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _avatarColor(AppColorsExtension c, String uid) {
    final colors = [
      c.dullOrange,
      c.accentBlue,
      c.oliveGreen,
      c.amber,
    ];
    return colors[uid.hashCode % colors.length];
  }
}

// ── Sticker tags section ────────────────────────────────────────────────────

class _StickerTagsSection extends StatelessWidget {
  final List<String> tags;
  const _StickerTagsSection({required this.tags});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
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
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: 10),
            color: c.oliveGreen,
            child: Text(
              'VIBE CHECK',
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.textOnPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm + 2,
              children: tags.map((tagId) {
                final tag = ClimbingTags.getById(tagId);
                if (tag == null) return const SizedBox.shrink();
                final rotation = ClimbingTags.rotationFor(tagId);
                return Transform.rotate(
                  angle: rotation * 3.14159 / 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.smMd,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: tag.color,
                      border: Border.all(color: c.borderColor, width: 2),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      boxShadow: [
                        BoxShadow(
                          color: tag.color.withAlpha(80),
                          offset: const Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      tag.label,
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: tag.color.computeLuminance() > 0.4
                            ? c.textPrimary
                            : c.textOnPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mutual connections ──────────────────────────────────────────────────────

class _MutualConnectionsSection extends ConsumerWidget {
  final String userId;
  const _MutualConnectionsSection({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final myConnections =
        ref.watch(connectionsProvider).valueOrNull ?? [];
    final targetUserAsync = ref.watch(userByIdProvider(userId));
    final targetUser = targetUserAsync.valueOrNull;
    if (targetUser == null) return const SizedBox.shrink();

    final mutual = myConnections
        .where((conn) => targetUser.connectionIds.contains(conn.uid))
        .toList();

    if (mutual.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MUTUAL CONNECTIONS',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: mutual.map((u) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2, vertical: AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: c.chipBg,
                border: Border.all(color: c.borderColor, width: 2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: c.accentBlue,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(color: c.borderColor, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        u.displayName.isNotEmpty
                            ? u.displayName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: c.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    u.displayName,
                    style: GoogleFonts.cabin(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
