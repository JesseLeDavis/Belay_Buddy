import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/features/notifications/presentation/notifications_screen.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/widgets/route_line_trace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectionsCard extends StatelessWidget {
  final AppUser user;
  final WidgetRef ref;
  const ConnectionsCard({super.key, required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final connectionsAsync = ref.watch(connectionsProvider);
    final pendingAsync = ref.watch(pendingConnectionRequestsProvider);
    final connections = connectionsAsync.valueOrNull ?? [];
    final pending = pendingAsync.valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Connections',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${connections.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: c.textDisabled,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
        if (pending.isNotEmpty) ...[
          const SizedBox(height: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const NotificationsScreen(),
            )),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: c.ink,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${pending.length} pending request${pending.length > 1 ? 's' : ''}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: c.ink,
                    ),
                  ),
                ),
                Text(
                  'review  →',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: c.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        if (connections.isEmpty)
          Text(
            'No connections yet. Climb with someone and tap "again?" to form one.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: c.textSecondary,
              height: 1.4,
            ),
          )
        else
          ...connections.map((conn) => _ConnectionRow(user: conn)),
      ],
    );
  }
}

class _ConnectionRow extends StatelessWidget {
  final AppUser user;
  const _ConnectionRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/profile/${user.uid}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c.canvas,
                shape: BoxShape.circle,
                border: Border.all(color: c.ink, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toLowerCase()
                    : '?',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.displayName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                ),
              ),
            ),
            // The Route Line trace — persistent record of the climb that
            // formed this connection. Each climber's pattern stays stable
            // across rebuilds (seeded by userId.hashCode).
            RouteLineTrace(seed: user.uid.hashCode),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right, size: 18, color: c.textDisabled),
          ],
        ),
      ),
    );
  }
}
