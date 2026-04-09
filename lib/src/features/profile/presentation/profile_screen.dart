import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/notifications/data/notifications_repository.dart';
import 'package:belay_buddy/src/features/connections/presentation/find_climbers_screen.dart';
import 'package:belay_buddy/src/features/notifications/presentation/notifications_screen.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/profile_widgets.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/sticker_tags_card.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/favorites_card.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/connections_card.dart';
import 'package:belay_buddy/src/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/theme/theme_mode_provider.dart';
import 'package:belay_buddy/src/common/widgets/retro_button.dart';
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
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: GoogleFonts.spaceMono(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.borderColor,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined,
                    color: c.borderColor),
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
                      color: c.dullOrange,
                      border:
                          Border.all(color: c.borderColor, width: 1.5),
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
                    color: c.error),
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
              color: c.textSecondary,
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: GoogleFonts.cabin(fontSize: 16, color: c.error),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, WidgetRef ref, AppUser user) {
    final c = context.appColors;
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
                // Avatar with edit badge
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: c.dullOrange,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: c.borderColor, width: 3),
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _openEditSheet(context, ref, user),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c.accentBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: c.borderColor, width: 2),
                          ),
                          child: const Icon(Icons.edit,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  user.displayName,
                  style: GoogleFonts.spaceMono(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user.email,
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Stats card — yellow header
          ProfileCard(
            title: 'USER INFO',
            stripColor: c.amber,
            titleColor: const Color(0xFF0F0F0F),
            children: [
              StatLine(
                  label: 'NAME',
                  value: user.displayName),
              StatLine(
                  label: 'EMAIL',
                  value: user.email),
              if (user.bio != null)
                StatLine(label: 'BIO', value: user.bio!),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Sticker tags
          if (user.climbingTags.isNotEmpty) ...[
            StickerTagsCard(tags: user.climbingTags),
            const SizedBox(height: AppSpacing.md),
          ],

          // Favorites — orange header
          FavoritesCard(ref: ref),
          const SizedBox(height: AppSpacing.md),

          // Connections — blue header
          ConnectionsCard(user: user, ref: ref),
          const SizedBox(height: AppSpacing.lg),

          // Find climbers button
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const FindClimbersScreen(),
            )),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: c.accentBlue,
                border: Border.fromBorderSide(
                    BorderSide(color: c.borderColor, width: 2.5)),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(4, 4),
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
          const SizedBox(height: AppSpacing.md),

          // Theme mode toggle
          _ThemeModeToggle(),
          const SizedBox(height: AppSpacing.lg),

          // Sign out — ink fill, orange shadow
          Center(
            child: RetroButton(
              label: 'Sign Out',
              icon: Icons.logout,
              color: c.borderColor,
              shadowColor: c.dullOrange,
              textColor: c.background,
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
}

class _ThemeModeToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final mode = ref.watch(themeModeProvider);

    const modes = [
      (ThemeMode.light, Icons.light_mode, 'LIGHT'),
      (ThemeMode.dark, Icons.dark_mode, 'DARK'),
      (ThemeMode.system, Icons.settings_brightness, 'AUTO'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
            color: c.shadowColor,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 4, vertical: 10),
            color: c.borderColor,
            child: Text(
              'APPEARANCE',
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.background,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: modes.map((entry) {
                final (value, icon, label) = entry;
                final isSelected = mode == value;
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: GestureDetector(
                      onTap: () {
                        final notifier =
                            ref.read(themeModeProvider.notifier);
                        switch (value) {
                          case ThemeMode.light:
                            notifier.setLight();
                          case ThemeMode.dark:
                            notifier.setDark();
                          case ThemeMode.system:
                            notifier.setSystem();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? c.dullOrange : c.chipBg,
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: isSelected
                                ? c.borderColor
                                : c.darkGrey,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(icon,
                                size: 20,
                                color: isSelected
                                    ? Colors.white
                                    : c.textSecondary),
                            const SizedBox(height: 4),
                            Text(
                              label,
                              style: GoogleFonts.spaceMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
