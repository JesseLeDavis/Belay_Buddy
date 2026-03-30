import 'package:belay_buddy/models/climbing_notification.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkNavy,
        title: Text(
          'NOTIFICATIONS',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const Border(
          bottom: BorderSide(color: AppColors.dullOrange, width: 3),
        ),
      ),
      body: notifAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none,
                      size: 64, color: AppColors.textDisabled),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'NO NOTIFICATIONS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDisabled,
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
                _SectionHeader(label: 'EARLIER'),
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
                color: AppColors.textSecondary),
          ),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: GoogleFonts.cabin(fontSize: 16, color: AppColors.error)),
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
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.chipBg,
        border: Border(
          bottom: BorderSide(color: AppColors.darkNavy, width: 1),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textDisabled,
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
    final (icon, accentColor, title, subtitle) = _content();

    return Container(
      decoration: BoxDecoration(
        color: notif.isRead ? AppColors.surface : AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.darkGrey, width: 1),
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
                border: Border.all(color: AppColors.darkNavy, width: 2),
              ),
              child: Icon(icon, size: 18, color: Colors.white),
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
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.cabin(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _timeAgo(notif.createdAt),
                    style: GoogleFonts.spaceMono(
                        fontSize: 10, color: AppColors.textDisabled),
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
                    color: AppColors.dullOrange,
                    border:
                        Border.all(color: AppColors.darkNavy, width: 2),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.darkNavy,
                          offset: Offset(2, 2),
                          blurRadius: 0)
                    ],
                  ),
                  child: Text(
                    'VIEW',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  (IconData, Color, String, String) _content() {
    switch (notif.type) {
      case NotificationType.catchNeeded:
        return (
          Icons.pan_tool_outlined,
          AppColors.dullOrange,
          '${notif.fromUserName} needs a catch',
          notif.cragName != null
              ? 'Posted at ${notif.cragName}'
              : 'Posted a session',
        );
      case NotificationType.connectionRequest:
        return (
          Icons.person_add_outlined,
          AppColors.accentBlue,
          '${notif.fromUserName} wants to connect',
          'Tap to accept or view their profile',
        );
      case NotificationType.connectionAccepted:
        return (
          Icons.handshake_outlined,
          AppColors.oliveGreen,
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
    if (_accepted) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.oliveGreen,
          border: Border.all(color: AppColors.darkNavy, width: 2),
        ),
        child: Text(
          'CONNECTED',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
          color: AppColors.accentBlue,
          border: Border.all(color: AppColors.darkNavy, width: 2),
          boxShadow: const [
            BoxShadow(
                color: AppColors.darkNavy,
                offset: Offset(2, 2),
                blurRadius: 0)
          ],
        ),
        child: Text(
          'ACCEPT',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
