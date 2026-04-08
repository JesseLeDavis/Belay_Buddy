import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/crag_widgets.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBaseSheet extends ConsumerWidget {
  final Crag crag;
  const HomeBaseSheet({super.key, required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(homeSettingsProvider);
    final notifier = ref.read(homeSettingsProvider.notifier);
    final memberCount = ref.watch(homeMemberCountProvider(crag.id));
    final isHome =
        settings.homeCragId == crag.id || settings.homeGymId == crag.id;
    final accentColor =
        crag.isGym ? AppColors.accentBlue : AppColors.oliveGreen;
    final label = crag.isGym ? 'GYM' : 'CRAG';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.darkNavy, width: 3)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 14),
            decoration: BoxDecoration(
              color: accentColor,
              border: const Border(
                  bottom: BorderSide(color: AppColors.darkNavy, width: 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.home, size: 18, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'HOME $label · ${crag.name.toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.darkNavy, width: 1.5),
                  ),
                  child: Text(
                    '$memberCount ${memberCount == 1 ? 'MEMBER' : 'MEMBERS'}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          HomeMembersList(cragId: crag.id, memberCount: memberCount),
          const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),
          SheetTile(
            icon: isHome ? Icons.home : Icons.home_outlined,
            iconColor: isHome ? accentColor : AppColors.textSecondary,
            title: isHome ? 'THIS IS YOUR HOME $label' : 'SET AS HOME $label',
            subtitle: isHome
                ? 'Tap to remove this as your home $label'
                : 'Mark this as your main climbing spot',
            trailing: Switch(
              value: isHome,
              activeColor: accentColor,
              onChanged: (_) {
                if (crag.isGym) {
                  notifier.setHomeGymDirect(isHome ? null : crag.id);
                } else {
                  notifier.setHomeCragDirect(isHome ? null : crag.id);
                }
              },
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),
          SheetTile(
            icon: settings.isHomeVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            iconColor: AppColors.darkNavy,
            title: settings.isHomeVisible ? 'VISIBLE TO OTHERS' : 'PRIVATE',
            subtitle: settings.isHomeVisible
                ? 'Your name appears in the member list'
                : 'Hidden from the list — still counted in the total',
            enabled: isHome,
            trailing: Switch(
              value: settings.isHomeVisible,
              activeColor: AppColors.darkNavy,
              onChanged: isHome ? (_) => notifier.toggleVisibility() : null,
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),
          SheetTile(
            icon: Icons.pan_tool_outlined,
            iconColor: AppColors.dullOrange,
            title: 'NOTIFY: CATCH NEEDED',
            subtitle:
                'Alert when someone at this ${label.toLowerCase()} needs a belay',
            enabled: isHome,
            trailing: Switch(
              value: settings.notifyHomeCatch,
              activeColor: AppColors.dullOrange,
              onChanged:
                  isHome ? (_) => notifier.toggleNotifyHomeCatch() : null,
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),
          SheetTile(
            icon: Icons.person_add_outlined,
            iconColor: AppColors.accentBlue,
            title: 'NOTIFY: NEW CONNECTIONS',
            subtitle:
                'Alert when someone new sets this as their home ${label.toLowerCase()}',
            enabled: isHome,
            trailing: Switch(
              value: settings.notifyHomeConnections,
              activeColor: AppColors.accentBlue,
              onChanged:
                  isHome ? (_) => notifier.toggleNotifyHomeConnections() : null,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMembersList extends ConsumerWidget {
  final String cragId;
  final int memberCount;
  const HomeMembersList({super.key, required this.cragId, required this.memberCount});

  static const _avatarColors = [
    AppColors.dullOrange,
    AppColors.accentBlue,
    AppColors.oliveGreen,
    AppColors.amber,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleHomeMembersProvider(cragId));
    final hiddenCount = memberCount - visible.length;

    if (memberCount == 0) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          'No members yet. Be the first!',
          style:
              GoogleFonts.cabin(fontSize: 13, color: AppColors.textSecondary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOCALS',
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ...visible.map((user) {
                final color =
                    _avatarColors[user.uid.hashCode % _avatarColors.length];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/profile/${user.uid}');
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: AppColors.darkNavy, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.darkNavy,
                              offset: Offset(2, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.spaceMono(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 52,
                        child: Text(
                          user.displayName.split(' ').first,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cabin(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (hiddenCount > 0)
                Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: AppColors.darkGrey, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '+$hiddenCount',
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 52,
                      child: Text(
                        'private',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cabin(
                          fontSize: 10,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
