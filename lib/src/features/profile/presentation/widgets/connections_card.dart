import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/features/notifications/presentation/notifications_screen.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
              color: c.shadowColor, offset: const Offset(4, 4), blurRadius: 0)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: 10),
            color: c.accentBlue,
            child: Row(
              children: [
                Text(
                  'CONNECTIONS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: c.textOnPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: c.borderColor, width: 1.5),
                  ),
                  child: Text(
                    '${connections.length}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: c.accentBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (pending.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              color: c.chipBg,
              child: Row(
                children: [
                  Icon(Icons.person_add_outlined,
                      size: 14, color: c.accentBlue),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${pending.length} PENDING REQUEST${pending.length > 1 ? 'S' : ''}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: c.accentBlue,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    )),
                    child: Text(
                      'REVIEW →',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: c.accentBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: c.borderColor),
          ],
          if (connections.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'No connections yet. Find climbers to connect with!',
                style: GoogleFonts.cabin(
                    fontSize: 13, color: c.textSecondary),
              ),
            )
          else
            ...connections.map((conn) => ConnectionRow(user: conn)),
        ],
      ),
    );
  }
}

class ConnectionRow extends StatelessWidget {
  final AppUser user;
  const ConnectionRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return GestureDetector(
      onTap: () => context.push('/profile/${user.uid}'),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: c.darkGrey, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c.borderColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: c.borderColor, width: 2),
              ),
              child: Center(
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.textOnPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                user.displayName,
                style: GoogleFonts.cabin(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 16, color: c.textDisabled),
          ],
        ),
      ),
    );
  }
}
