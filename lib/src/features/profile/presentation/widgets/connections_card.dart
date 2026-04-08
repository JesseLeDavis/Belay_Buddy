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
    final connectionsAsync = ref.watch(connectionsProvider);
    final pendingAsync = ref.watch(pendingConnectionRequestsProvider);
    final connections = connectionsAsync.valueOrNull ?? [];
    final pending = pendingAsync.valueOrNull ?? [];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: const [
          BoxShadow(
              color: AppColors.darkNavy, offset: Offset(4, 4), blurRadius: 0)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 4, vertical: 10),
            color: AppColors.accentBlue,
            child: Row(
              children: [
                Text(
                  'CONNECTIONS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.darkNavy, width: 1.5),
                  ),
                  child: Text(
                    '${connections.length}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pending requests
          if (pending.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              color: AppColors.chipBg,
              child: Row(
                children: [
                  const Icon(Icons.person_add_outlined,
                      size: 14, color: AppColors.accentBlue),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${pending.length} PENDING REQUEST${pending.length > 1 ? 'S' : ''}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentBlue,
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
                        color: AppColors.accentBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.darkNavy),
          ],

          // Connection list
          if (connections.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'No connections yet. Find climbers to connect with!',
                style: GoogleFonts.cabin(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            )
          else
            ...connections.map((c) => ConnectionRow(user: c)),
        ],
      ),
    );
  }
}

class ConnectionRow extends StatelessWidget {
  final AppUser user;
  const ConnectionRow({super.key, required this.user});

  static const _disciplineColors = {
    ClimbingStyle.sport: AppColors.accentBlue,
    ClimbingStyle.trad: AppColors.dullOrange,
    ClimbingStyle.boulder: AppColors.oliveGreen,
    ClimbingStyle.all: AppColors.amber,
  };

  @override
  Widget build(BuildContext context) {
    final primaryStyle = user.climbingStyles.isNotEmpty
        ? user.climbingStyles.first
        : ClimbingStyle.all;

    return GestureDetector(
      onTap: () => context.push('/profile/${user.uid}'),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.darkGrey, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _disciplineColors[primaryStyle] ?? AppColors.darkNavy,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.darkNavy, width: 2),
              ),
              child: Center(
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
                  color: AppColors.darkNavy,
                ),
              ),
            ),
            Text(
              user.climbingStyles
                  .take(2)
                  .map((s) => s.name.toUpperCase())
                  .join(' · '),
              style: GoogleFonts.spaceMono(
                  fontSize: 9, color: AppColors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.chevron_right,
                size: 16, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}
