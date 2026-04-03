import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/screens/profile/find_climbers_screen.dart';
import 'package:belay_buddy/screens/profile/notifications_screen.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:belay_buddy/widgets/retro_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _experienceLabels = {
    ExperienceLevel.beginner: 'BEGINNER',
    ExperienceLevel.intermediate: 'INTERMEDIATE',
    ExperienceLevel.advanced: 'ADVANCED',
    ExperienceLevel.expert: 'EXPERT',
  };

  static const _styleLabels = {
    ClimbingStyle.sport: 'SPORT',
    ClimbingStyle.trad: 'TRAD',
    ClimbingStyle.boulder: 'BOULDER',
    ClimbingStyle.all: 'ALL STYLES',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.darkNavy),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                )),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.dullOrange,
                      border:
                          Border.all(color: AppColors.darkNavy, width: 1.5),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: GoogleFonts.spaceMono(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text(
                'USER NOT FOUND',
                style: GoogleFonts.spaceMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error),
              ),
            );
          }
          return _buildProfile(context, ref, user);
        },
        loading: () => Center(
          child: Text(
            'LOADING...',
            style: GoogleFonts.spaceMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: GoogleFonts.cabin(fontSize: 16, color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, WidgetRef ref, AppUser user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                // Avatar — large circle, orange fill, white initial
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.dullOrange,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkNavy, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      user.displayName.isNotEmpty
                          ? user.displayName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.spaceMono(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  user.displayName,
                  style: GoogleFonts.spaceMono(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user.email,
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Stats card — yellow header
          _ProfileCard(
            title: 'USER INFO',
            stripColor: AppColors.amber,
            titleColor: AppColors.darkNavy,
            children: [
              _StatLine(
                  label: 'NAME',
                  value: user.displayName),
              _StatLine(
                  label: 'EMAIL',
                  value: user.email),
              _StatLine(
                  label: 'LEVEL',
                  value: _experienceLabels[user.experienceLevel] ??
                      user.experienceLevel.name.toUpperCase(),
                  valueColor: _levelColor(user.experienceLevel)),
              if (user.bio != null)
                _StatLine(label: 'BIO', value: user.bio!),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Experience level — green header
          _ProfileCard(
            title: 'EXPERIENCE',
            stripColor: AppColors.oliveGreen,
            titleColor: Colors.white,
            children: [
              _ExperienceBar(level: user.experienceLevel),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Climbing styles — blue header
          _ProfileCard(
            title: 'CLIMBING STYLES',
            stripColor: AppColors.accentBlue,
            titleColor: Colors.white,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: user.climbingStyles.map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 2,
                      vertical: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.darkNavy, width: 2),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      _styleLabels[s] ?? s.name.toUpperCase(),
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Favorite crags — orange header
          _ProfileCard(
            title: 'FAVORITE CRAGS',
            stripColor: AppColors.dullOrange,
            titleColor: Colors.white,
            children: [
              if (user.favoriteCragIds.isEmpty)
                const _StatLine(label: 'STATUS', value: 'None saved')
              else
                ...user.favoriteCragIds.map(
                  (id) => _StatLine(
                    label: '',
                    value: id
                        .replaceAll('crag_', '')
                        .toUpperCase()
                        .replaceAll('_', ' '),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Connections — blue header
          _ConnectionsCard(user: user, ref: ref),
          const SizedBox(height: AppSpacing.lg),

          // Find climbers button
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const FindClimbersScreen(),
            )),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.darkNavy, width: 2.5)),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.darkNavy,
                      offset: Offset(4, 4),
                      blurRadius: 0)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group_add_outlined,
                      color: Colors.white, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'FIND CLIMBERS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Sign out — ink fill, orange shadow
          Center(
            child: RetroButton(
              label: 'Sign Out',
              icon: Icons.logout,
              color: AppColors.darkNavy,
              shadowColor: AppColors.dullOrange,
              textColor: Colors.white,
              onPressed: () {
                context.go('/login');
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Color _levelColor(ExperienceLevel level) {
    switch (level) {
      case ExperienceLevel.beginner:
        return AppColors.oliveGreen;
      case ExperienceLevel.intermediate:
        return AppColors.amber;
      case ExperienceLevel.advanced:
        return AppColors.dullOrange;
      case ExperienceLevel.expert:
        return AppColors.error;
    }
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final Color stripColor;
  final Color titleColor;
  final List<Widget> children;

  const _ProfileCard({
    required this.title,
    required this.stripColor,
    required this.titleColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.darkNavy, width: 2.5),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: const [
            BoxShadow(
              color: AppColors.darkNavy,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored top strip — bold fill
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 4,
                vertical: 10,
              ),
              color: stripColor,
              child: Text(
                title,
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDisabled,
                ),
              ),
            ),
          if (label.isNotEmpty) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cabin(
                fontSize: 14,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionsCard extends StatelessWidget {
  final AppUser user;
  final WidgetRef ref;
  const _ConnectionsCard({required this.user, required this.ref});

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
            ...connections.map((c) => _ConnectionRow(user: c)),
        ],
      ),
    );
  }
}

class _ConnectionRow extends StatelessWidget {
  final AppUser user;
  const _ConnectionRow({required this.user});

  static const _levelColors = {
    ExperienceLevel.beginner: AppColors.oliveGreen,
    ExperienceLevel.intermediate: AppColors.amber,
    ExperienceLevel.advanced: AppColors.dullOrange,
    ExperienceLevel.expert: AppColors.error,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: _levelColors[user.experienceLevel] ?? AppColors.darkNavy,
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
        ],
      ),
    );
  }
}

/// Experience progress bar with diagonal hatching pattern.
class _ExperienceBar extends StatelessWidget {
  final ExperienceLevel level;

  const _ExperienceBar({required this.level});

  double get _progress {
    switch (level) {
      case ExperienceLevel.beginner:
        return 0.25;
      case ExperienceLevel.intermediate:
        return 0.5;
      case ExperienceLevel.advanced:
        return 0.75;
      case ExperienceLevel.expert:
        return 1.0;
    }
  }

  String get _label {
    switch (level) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.advanced:
        return 'Advanced';
      case ExperienceLevel.expert:
        return 'Expert';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label.toUpperCase(),
          style: GoogleFonts.spaceMono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.darkNavy, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Stack(
              children: [
                // Background
                Container(color: AppColors.background),
                // Filled portion with hatching
                FractionallySizedBox(
                  widthFactor: _progress,
                  child: CustomPaint(
                    painter: _HatchPainter(
                      color: AppColors.dullOrange,
                      backgroundColor: AppColors.orangeLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints diagonal hatching pattern.
class _HatchPainter extends CustomPainter {
  final Color color;
  final Color backgroundColor;

  _HatchPainter({required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = backgroundColor,
    );

    // Draw diagonal lines
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const spacing = 8.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
