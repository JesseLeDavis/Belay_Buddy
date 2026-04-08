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
                // Avatar with edit badge
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.dullOrange,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.darkNavy, width: 3),
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
                            color: AppColors.accentBlue,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.darkNavy, width: 2),
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
          ProfileCard(
            title: 'USER INFO',
            stripColor: AppColors.amber,
            titleColor: AppColors.darkNavy,
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
}
