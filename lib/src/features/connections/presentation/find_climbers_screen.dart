import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FindClimbersScreen extends ConsumerWidget {
  const FindClimbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final usersAsync = ref.watch(discoverableUsersProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.accentBlue,
        title: Text(
          'FIND CLIMBERS',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
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
                  color: c.textDisabled,
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

class _ClimberCard extends ConsumerStatefulWidget {
  final AppUser user;
  const _ClimberCard({required this.user});

  @override
  ConsumerState<_ClimberCard> createState() => _ClimberCardState();
}

class _ClimberCardState extends ConsumerState<_ClimberCard> {
  bool _requestSent = false;

  static const _styleLabels = {
    ClimbingStyle.sport: 'SPORT',
    ClimbingStyle.trad: 'TRAD',
    ClimbingStyle.boulder: 'BOULDER',
    ClimbingStyle.all: 'ALL',
  };

  Map<ClimbingStyle, Color> _disciplineColors(AppColorsExtension c) => {
    ClimbingStyle.sport: c.accentBlue,
    ClimbingStyle.trad: c.dullOrange,
    ClimbingStyle.boulder: c.oliveGreen,
    ClimbingStyle.all: c.amber,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isConnected = ref.watch(isConnectedProvider(widget.user.uid));
    final hasPending = ref.watch(hasPendingRequestFromProvider(widget.user.uid));
    final discColors = _disciplineColors(c);

    return GestureDetector(
      onTap: () => context.push('/profile/${widget.user.uid}'),
      child: Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: c.borderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
              color: c.shadowColor, offset: const Offset(4, 4), blurRadius: 0)
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
                    color: _avatarColor(c, widget.user.uid),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: c.borderColor, width: 2),
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
                          color: c.textPrimary,
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
                            color: discColors[s] ?? c.textDisabled,
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
                _buildConnectionButton(c, isConnected, hasPending),
              ],
            ),
          ),

          // Bio
          if (widget.user.bio != null) ...[
            Divider(height: 1, thickness: 1, color: c.darkGrey),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Text(
                widget.user.bio!,
                style: GoogleFonts.cabin(
                    fontSize: 13, color: c.textSecondary, height: 1.4),
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
                    border: Border.all(color: c.borderColor, width: 1.5),
                  ),
                  child: Text(
                    _styleLabels[s] ?? s.name.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
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

  Widget _buildConnectionButton(AppColorsExtension c, bool isConnected, bool hasPending) {
    if (isConnected) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: c.oliveGreen,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
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
          color: c.chipBg,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
        ),
        child: Text(
          'PENDING',
          style: GoogleFonts.spaceMono(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: c.textSecondary,
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
          backgroundColor: c.accentBlue,
        ));
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        decoration: BoxDecoration(
          color: c.accentBlue,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
          boxShadow: [
            BoxShadow(
                color: c.shadowColor, offset: const Offset(2, 2), blurRadius: 0)
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
