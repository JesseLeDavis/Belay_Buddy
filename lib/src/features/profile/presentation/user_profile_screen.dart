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
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'Profile',
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
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text(
                'user not found',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: c.error,
                ),
              ),
            );
          }
          return _UserProfileBody(user: user);
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
        error: (e, _) => Center(
          child: Text(
            'error: $e',
            style: GoogleFonts.inter(fontSize: 14, color: c.error),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Avatar(
                  initial: user.displayName.isNotEmpty
                      ? user.displayName[0].toLowerCase()
                      : '?',
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                          height: 1.1,
                        ),
                      ),
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          user.bio!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: c.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Action row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Row(
              children: [
                Expanded(
                  child: _ConnectionButton(
                    displayName: user.displayName,
                    isConnected: isConnected,
                    hasPending: hasPending || _requestSent,
                    onConnect: () {
                      setState(() => _requestSent = true);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'connection request sent to ${user.displayName}',
                          style: GoogleFonts.inter(
                            color: c.canvas,
                            fontSize: 14,
                          ),
                        ),
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SecondaryButton(
                    label: 'message',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'messaging coming soon',
                          style: GoogleFonts.inter(
                            color: c.canvas,
                            fontSize: 14,
                          ),
                        ),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(height: 1.5, color: c.borderColor),

          // ── Vibes ─────────────────────────────────────────────────────
          if (user.climbingTags.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: _VibesSection(tags: user.climbingTags),
            ),
            Container(height: 1.5, color: c.borderColor),
          ],

          // ── Mutual connections ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: _MutualConnections(userId: user.uid),
          ),
        ],
      ),
    );
  }
}

// ─── Atoms ──────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initial;
  const _Avatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}

class _ConnectionButton extends StatelessWidget {
  final String displayName;
  final bool isConnected;
  final bool hasPending;
  final VoidCallback onConnect;

  const _ConnectionButton({
    required this.displayName,
    required this.isConnected,
    required this.hasPending,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    late final Color fill;
    late final Color textColor;
    late final Color borderColor;
    late final String label;
    late final VoidCallback? onTap;

    if (isConnected) {
      fill = c.canvas;
      textColor = c.textSecondary;
      borderColor = c.textDisabled;
      label = 'connected';
      onTap = null;
    } else if (hasPending) {
      fill = c.canvas;
      textColor = c.textDisabled;
      borderColor = c.textDisabled;
      label = 'pending';
      onTap = null;
    } else {
      fill = c.ink;
      textColor = c.canvas;
      borderColor = c.ink;
      label = 'connect';
      onTap = onConnect;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.canvas,
          border: Border.all(color: c.ink, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: c.ink,
          ),
        ),
      ),
    );
  }
}

class _VibesSection extends StatelessWidget {
  final List<String> tags;
  const _VibesSection({required this.tags});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vibes',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tags.map((tagId) {
            final tag = ClimbingTags.getById(tagId);
            if (tag == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: c.canvas,
                border: Border.all(color: c.ink, width: 1.5),
              ),
              child: Text(
                tag.label.toLowerCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                  letterSpacing: -0.1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MutualConnections extends ConsumerWidget {
  final String userId;
  const _MutualConnections({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final myConnections = ref.watch(connectionsProvider).valueOrNull ?? [];
    final targetUser = ref.watch(userByIdProvider(userId)).valueOrNull;
    if (targetUser == null) return const SizedBox.shrink();

    final mutual = myConnections
        .where((conn) => targetUser.connectionIds.contains(conn.uid))
        .toList();

    if (mutual.isEmpty) {
      return Text(
        'No mutual connections.',
        style: GoogleFonts.inter(
          fontSize: 13,
          color: c.textSecondary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mutual connections',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: mutual.map((u) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: c.canvas,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.ink, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    u.displayName.isNotEmpty
                        ? u.displayName[0].toLowerCase()
                        : '?',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: c.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  u.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: c.ink,
                  ),
                ),
                const SizedBox(width: 6),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
