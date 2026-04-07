import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FindClimbersScreen extends ConsumerWidget {
  const FindClimbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(discoverableUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accentBlue,
        title: Text(
          'FIND CLIMBERS',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const Border(
          bottom: BorderSide(color: AppColors.darkNavy, width: 3),
        ),
      ),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text(
                'NO CLIMBERS FOUND',
                style: GoogleFonts.spaceMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDisabled,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: users.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ClimberCard(user: users[i]),
            ),
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

class _ClimberCard extends ConsumerStatefulWidget {
  final AppUser user;
  const _ClimberCard({required this.user});

  @override
  ConsumerState<_ClimberCard> createState() => _ClimberCardState();
}

class _ClimberCardState extends ConsumerState<_ClimberCard> {
  // Local mock state — in production this would update Firestore
  bool _requestSent = false;

  static const _styleLabels = {
    ClimbingStyle.sport: 'SPORT',
    ClimbingStyle.trad: 'TRAD',
    ClimbingStyle.boulder: 'BOULDER',
    ClimbingStyle.all: 'ALL',
  };

  static const _disciplineColors = {
    ClimbingStyle.sport: AppColors.accentBlue,
    ClimbingStyle.trad: AppColors.dullOrange,
    ClimbingStyle.boulder: AppColors.oliveGreen,
    ClimbingStyle.all: AppColors.amber,
  };

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedProvider(widget.user.uid));
    final hasPending = ref.watch(hasPendingRequestFromProvider(widget.user.uid));

    return GestureDetector(
      onTap: () => context.push('/profile/${widget.user.uid}'),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        boxShadow: const [
          BoxShadow(
              color: AppColors.darkNavy, offset: Offset(4, 4), blurRadius: 0)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _avatarColor(widget.user.uid),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.darkNavy, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      widget.user.displayName.isNotEmpty
                          ? widget.user.displayName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.spaceMono(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                        widget.user.displayName,
                        style: GoogleFonts.spaceMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.user.climbingStyles.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            color: _disciplineColors[s] ??
                                AppColors.textDisabled,
                            child: Text(
                              _styleLabels[s] ?? s.name.toUpperCase(),
                              style: GoogleFonts.spaceMono(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                _buildConnectionButton(isConnected, hasPending),
              ],
            ),
          ),

          // Bio
          if (widget.user.bio != null) ...[
            const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Text(
                widget.user.bio!,
                style: GoogleFonts.cabin(
                    fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
            ),
          ],

          // Style chips
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: widget.user.climbingStyles.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.darkNavy, width: 1.5),
                  ),
                  child: Text(
                    _styleLabels[s] ?? s.name.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildConnectionButton(bool isConnected, bool hasPending) {
    if (isConnected) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.oliveGreen,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.darkNavy, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'CONNECTED',
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (hasPending || _requestSent) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.chipBg,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.darkNavy, width: 2),
        ),
        child: Text(
          'PENDING',
          style: GoogleFonts.spaceMono(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _requestSent = true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Connection request sent to ${widget.user.displayName}',
            style: GoogleFonts.cabin(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: AppColors.accentBlue,
        ));
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accentBlue,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.darkNavy, width: 2),
          boxShadow: const [
            BoxShadow(
                color: AppColors.darkNavy, offset: Offset(2, 2), blurRadius: 0)
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_add_outlined, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'CONNECT',
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _avatarColor(String uid) {
    final colors = [
      AppColors.dullOrange,
      AppColors.accentBlue,
      AppColors.oliveGreen,
      AppColors.amber,
    ];
    return colors[uid.hashCode % colors.length];
  }
}
