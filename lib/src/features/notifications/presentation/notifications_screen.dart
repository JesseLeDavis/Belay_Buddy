import 'package:belay_buddy/src/features/notifications/domain/climbing_notification.dart';
import 'package:belay_buddy/src/features/notifications/data/notifications_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final notifAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'Activity',
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
      body: notifAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No activity yet.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
              ),
            );
          }

          final unread = notifications.where((n) => !n.isRead).toList();
          final read = notifications.where((n) => n.isRead).toList();

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (unread.isNotEmpty) ...[
                _SectionLabel(text: 'new · ${unread.length}'),
                ...unread.map((n) => _NotifRow(notif: n)),
              ],
              if (read.isNotEmpty) ...[
                const _SectionLabel(text: 'earlier'),
                ...read.map((n) => _NotifRow(notif: n)),
              ],
              const SizedBox(height: 32),
            ],
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: c.textDisabled,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

class _NotifRow extends ConsumerWidget {
  final ClimbingNotification notif;
  const _NotifRow({required this.notif});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final (title, subtitle) = _content();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AvatarDot(
            initial: notif.fromUserName.isNotEmpty
                ? notif.fromUserName[0].toLowerCase()
                : '?',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: notif.isRead
                        ? FontWeight.w500
                        : FontWeight.w600,
                    color: c.ink,
                    height: 1.35,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: c.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _timeAgo(notif.createdAt),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: c.textDisabled,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ActionFor(notif: notif),
        ],
      ),
    );
  }

  (String, String?) _content() {
    switch (notif.type) {
      case NotificationType.catchNeeded:
        return (
          '${notif.fromUserName} needs a catch.',
          notif.cragName != null ? 'at ${notif.cragName}' : null,
        );
      case NotificationType.connectionRequest:
        return (
          '${notif.fromUserName} wants to connect.',
          null,
        );
      case NotificationType.connectionAccepted:
        return (
          '${notif.fromUserName} accepted.',
          'you’re connected.',
        );
      case NotificationType.partnerInterest:
        return (
          '${notif.fromUserName} is interested in your session.',
          notif.cragName != null ? 'at ${notif.cragName}' : null,
        );
      case NotificationType.lostFoundClaim:
        return (
          '${notif.fromUserName} responded.',
          notif.cragName,
        );
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    return DateFormat('MMM d').format(dt).toLowerCase();
  }
}

class _ActionFor extends StatelessWidget {
  final ClimbingNotification notif;
  const _ActionFor({required this.notif});

  @override
  Widget build(BuildContext context) {
    if (notif.type == NotificationType.connectionRequest) {
      return const _AcceptButton();
    }
    if (notif.type == NotificationType.catchNeeded && notif.cragId != null) {
      return _LinkAction(
        label: 'view  →',
        onTap: () {
          Navigator.of(context).pop();
          context.go('/crag/${notif.cragId}');
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _AcceptButton extends StatefulWidget {
  const _AcceptButton();

  @override
  State<_AcceptButton> createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<_AcceptButton> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _accepted ? null : () => setState(() => _accepted = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _accepted ? c.canvas : c.ink,
          border: Border.all(
            color: _accepted ? c.textDisabled : c.ink,
            width: 1.5,
          ),
        ),
        child: Text(
          _accepted ? 'connected' : 'accept',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _accepted ? c.textDisabled : c.canvas,
          ),
        ),
      ),
    );
  }
}

class _LinkAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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

class _AvatarDot extends StatelessWidget {
  final String initial;
  const _AvatarDot({required this.initial});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}
