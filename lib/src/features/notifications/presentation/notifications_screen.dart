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
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.borderColor,
        title: Text(
          'NOTIFICATIONS',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.background,
          ),
        ),
        iconTheme: IconThemeData(color: c.background),
        shape: Border(
          bottom: BorderSide(color: c.dullOrange, width: 3),
        ),
      ),
      body: notifAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64, color: c.textDisabled),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'NO NOTIFICATIONS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textDisabled,
                    ),
                  ),
                ],
              ),
            );
          }

          final unread =
              notifications.where((n) => !n.isRead).toList();
          final read =
              notifications.where((n) => n.isRead).toList();

          return ListView(
            children: [
              if (unread.isNotEmpty) ...[
                _SectionHeader(label: 'NEW · ${unread.length}'),
                ...unread.map((n) => _NotifTile(notif: n)),
              ],
              if (read.isNotEmpty) ...[
                const _SectionHeader(label: 'EARLIER'),
                ...read.map((n) => _NotifTile(notif: n)),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
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
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: GoogleFonts.cabin(fontSize: 16, color: c.error)),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.chipBg,
        border: Border(
          bottom: BorderSide(color: c.borderColor, width: 1),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c.textDisabled,
        ),
      ),
    );
  }
}

class _NotifTile extends ConsumerWidget {
  final ClimbingNotification notif;
  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final (icon, accentColor, title, subtitle) = _content(c);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          bottom: BorderSide(color: c.darkGrey, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread indicator
          Container(
            width: 4,
            height: 72,
            color: notif.isRead ? Colors.transparent : accentColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          // Icon
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor,
                border: Border.all(color: c.borderColor, width: 2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, size: 18, color: c.textOnPrimary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
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
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notif.createdAt),
                    style: GoogleFonts.spaceMono(
                        fontSize: 10, color: c.textDisabled),
                  ),
                ],
              ),
            ),
          ),
          // Action
          if (notif.type == NotificationType.connectionRequest)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: _AcceptButton(notif: notif),
            )
          else if (notif.type == NotificationType.catchNeeded &&
              notif.cragId != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/crag/${notif.cragId}');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.dullOrange,
                    border:
                        Border.all(color: c.borderColor, width: 2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: [
                      BoxShadow(
                          color: c.shadowColor,
                          offset: const Offset(4, 4),
                          blurRadius: 0)
                    ],
                  ),
                  child: Text(
                    'VIEW',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: c.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  (IconData, Color, String, String) _content(AppColorsExtension c) {
    switch (notif.type) {
      case NotificationType.catchNeeded:
        return (
          Icons.pan_tool_outlined,
          c.dullOrange,
          '${notif.fromUserName} needs a catch',
          notif.cragName != null
              ? 'Posted at ${notif.cragName}'
              : 'Posted a session',
        );
      case NotificationType.connectionRequest:
        return (
          Icons.person_add_outlined,
          c.accentBlue,
          '${notif.fromUserName} wants to connect',
          'Tap to accept or view their profile',
        );
      case NotificationType.connectionAccepted:
        return (
          Icons.handshake_outlined,
          c.oliveGreen,
          '${notif.fromUserName} accepted your request',
          'You\'re now connected',
        );
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'yesterday';
    return DateFormat('MMM d').format(dt);
  }
}

class _AcceptButton extends StatefulWidget {
  final ClimbingNotification notif;
  const _AcceptButton({required this.notif});

  @override
  State<_AcceptButton> createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<_AcceptButton> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    if (_accepted) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: c.oliveGreen,
          border: Border.all(color: c.borderColor, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          'CONNECTED',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: c.textOnPrimary,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _accepted = true),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: c.accentBlue,
          border: Border.all(color: c.borderColor, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: [
            BoxShadow(
                color: c.shadowColor,
                offset: const Offset(4, 4),
                blurRadius: 0)
          ],
        ),
        child: Text(
          'ACCEPT',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: c.textOnPrimary,
          ),
        ),
      ),
    );
  }
}
