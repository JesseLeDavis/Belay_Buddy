import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
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
            color: c.canvas,
            border: Border(
              top: BorderSide(color: c.borderColor, width: 1.5),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 3,
                    color: c.borderColor,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  post.title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                    height: 1.25,
                  ),
                ),
                if (post.description != null &&
                    post.description!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    post.description!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: c.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      _formatFullDateTime(post.dateTime).toLowerCase(),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: c.textSecondary,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
                if (post.needsBelay || post.offeringBelay) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (post.needsBelay)
                        const _Chip(label: 'needs belay'),
                      if (post.offeringBelay)
                        const _Chip(label: 'can belay'),
                    ],
                  ),
                ],
                const SizedBox(height: 22),
                Container(height: 1.5, color: c.borderColor),
                const SizedBox(height: 14),
                userAsync.when(
                  data: (user) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
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
                            color: c.canvas,
                            shape: BoxShape.circle,
                            border: Border.all(color: c.ink, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            user?.displayName.isNotEmpty == true
                                ? user!.displayName[0].toLowerCase()
                                : '?',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: c.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user?.displayName ?? 'Unknown climber',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: c.ink,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 18, color: c.ink),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox(height: 40),
                  error: (_, __) => Text(
                    'Unknown climber',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: c.textDisabled,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _PostActionButtons(post: post, userAsync: userAsync),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatFullDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.isNegative) {
      final f = dt.difference(now);
      if (f.inMinutes < 60) return 'in ${f.inMinutes}m';
      if (f.inHours < 24) return 'in ${f.inHours}h';
      return DateFormat('EEE, MMM d · h:mm a').format(dt);
    } else {
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return DateFormat('EEE, MMM d · h:mm a').format(dt);
    }
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.canvas,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: c.ink,
          letterSpacing: -0.1,
        ),
      ),
    );
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
    final posterName =
        widget.userAsync.asData?.value?.displayName.split(' ').first ?? 'them';

    if (isOwnPost) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SecondaryButton(
          label: 'message $posterName',
          icon: Icons.chat_bubble_outline,
          onTap: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'messaging coming soon',
                style: GoogleFonts.inter(color: c.canvas, fontSize: 14),
              ),
            ));
          },
        ),
        const SizedBox(height: 8),
        if (!isConnected)
          _PrimaryButton(
            label: _connectRequestSent
                ? 'request sent'
                : 'connect with $posterName',
            icon: _connectRequestSent
                ? Icons.hourglass_empty
                : Icons.person_add_outlined,
            enabled: !_connectRequestSent,
            onTap: () {
              setState(() => _connectRequestSent = true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'connection request sent to $posterName',
                  style: GoogleFonts.inter(color: c.canvas, fontSize: 14),
                ),
              ));
            },
          )
        else
          _PrimaryButton(
            label: 'connected with $posterName',
            icon: Icons.check,
            enabled: false,
            onTap: () {},
          ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: c.canvas,
          border: Border.all(color: c.ink, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: c.ink),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: enabled ? c.ink : c.canvas,
          border: Border.all(
            color: enabled ? c.ink : c.textDisabled,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: enabled ? c.canvas : c.textDisabled,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: enabled ? c.canvas : c.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
