import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/notifications/data/notifications_repository.dart';
import 'package:belay_buddy/src/features/connections/presentation/find_climbers_screen.dart';
import 'package:belay_buddy/src/features/notifications/presentation/notifications_screen.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/sticker_tags_card.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/favorites_card.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/connections_card.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _openEditSheet(BuildContext context, WidgetRef ref, AppUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileSheet(user: user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(currentUserProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: c.canvas,
      appBar: AppBar(
        backgroundColor: c.canvas,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: c.ink,
        title: Text(
          'Me',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        actions: [
          _NotificationsButton(unreadCount: unreadCount),
          const SizedBox(width: 8),
        ],
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const _UserNotFound();
          return _buildProfile(context, ref, user);
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

  Widget _buildProfile(BuildContext context, WidgetRef ref, AppUser user) {
    final c = context.appColors;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Avatar(
                  initial: user.displayName.isNotEmpty
                      ? user.displayName[0].toLowerCase()
                      : '?',
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          color: c.textSecondary,
                          letterSpacing: -0.1,
                        ),
                      ),
                      if (user.bio != null && user.bio!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.bio!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: c.ink,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: c.ink, size: 20),
                  onPressed: () => _openEditSheet(context, ref, user),
                ),
              ],
            ),
          ),

          _hairline(c),

          // ── Sticker tags ──────────────────────────────────────────────
          if (user.climbingTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: StickerTagsCard(tags: user.climbingTags),
            ),

          if (user.climbingTags.isNotEmpty) _hairline(c),

          // ── Favorites ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: FavoritesCard(ref: ref),
          ),

          _hairline(c),

          // ── Connections ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ConnectionsCard(user: user, ref: ref),
          ),

          _hairline(c),

          // ── Find climbers ─────────────────────────────────────────────
          _ListRow(
            label: 'Find climbers',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const FindClimbersScreen(),
            )),
          ),

          _hairline(c),

          // ── Theme ─────────────────────────────────────────────────────
          const _ThemeModeRow(),

          _hairline(c),

          // ── Sign out ──────────────────────────────────────────────────
          _ListRow(
            label: 'Sign out',
            onTap: () => context.go('/login'),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _hairline(AppColorsExtension c) =>
      Container(height: 1.5, color: c.borderColor);
}

// ─── Atoms ──────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initial;
  const _Avatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ListRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: c.ink),
          ],
        ),
      ),
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  final int unreadCount;
  const _NotificationsButton({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Semantics(
      label: unreadCount > 0
          ? 'Notifications, $unreadCount unread'
          : 'Notifications',
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: c.ink),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const NotificationsScreen(),
            )),
          ),
          if (unreadCount > 0)
            Positioned(
              top: 10,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: c.ink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UserNotFound extends StatelessWidget {
  const _UserNotFound();
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Center(
      child: Text(
        'user not found',
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: c.error,
        ),
      ),
    );
  }
}

class _ThemeModeRow extends ConsumerWidget {
  const _ThemeModeRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final mode = ref.watch(themeModeProvider);

    const modes = [
      (ThemeMode.light, 'light'),
      (ThemeMode.dark, 'dark'),
      (ThemeMode.system, 'auto'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Theme',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: c.ink,
              ),
            ),
          ),
          ...modes.map((entry) {
            final (value, label) = entry;
            final isSelected = mode == value;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final notifier = ref.read(themeModeProvider.notifier);
                switch (value) {
                  case ThemeMode.light:
                    notifier.setLight();
                  case ThemeMode.dark:
                    notifier.setDark();
                  case ThemeMode.system:
                    notifier.setSystem();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? c.ink : c.textDisabled,
                    decoration:
                        isSelected ? TextDecoration.underline : null,
                    decorationColor: c.ink,
                    decorationThickness: 1.5,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
