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
    final c = context.appColors;
    final settings = ref.watch(homeSettingsProvider);
    final notifier = ref.read(homeSettingsProvider.notifier);
    final memberCount = ref.watch(homeMemberCountProvider(crag.id));
    final isHome =
        settings.homeCragId == crag.id || settings.homeGymId == crag.id;
    final label = crag.isGym ? 'gym' : 'crag';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 3,
                color: c.borderColor,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Text(
                'Home $label · ${crag.name}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: c.textSecondary,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            HomeMembersList(cragId: crag.id, memberCount: memberCount),
            Container(height: 1.5, color: c.borderColor),
            SheetTile(
              icon: isHome ? Icons.home : Icons.home_outlined,
              title: isHome ? 'This is your home $label' : 'Set as home $label',
              subtitle: isHome
                  ? 'tap to remove'
                  : 'mark this as your main climbing spot',
              trailing: Switch(
                value: isHome,
                activeColor: c.ink,
                onChanged: (_) {
                  if (crag.isGym) {
                    notifier.setHomeGymDirect(isHome ? null : crag.id);
                  } else {
                    notifier.setHomeCragDirect(isHome ? null : crag.id);
                  }
                },
              ),
            ),
            Container(height: 1.5, color: c.borderColor),
            SheetTile(
              icon: settings.isHomeVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              title: settings.isHomeVisible ? 'Visible to others' : 'Private',
              subtitle: settings.isHomeVisible
                  ? 'your name appears in the member list'
                  : 'hidden from the list — still counted in the total',
              enabled: isHome,
              trailing: Switch(
                value: settings.isHomeVisible,
                activeColor: c.ink,
                onChanged: isHome ? (_) => notifier.toggleVisibility() : null,
              ),
            ),
            Container(height: 1.5, color: c.borderColor),
            SheetTile(
              icon: Icons.pan_tool_outlined,
              title: 'Catch needed',
              subtitle: 'when someone at this $label needs a belay',
              enabled: isHome,
              trailing: Switch(
                value: settings.notifyHomeCatch,
                activeColor: c.ink,
                onChanged:
                    isHome ? (_) => notifier.toggleNotifyHomeCatch() : null,
              ),
            ),
            Container(height: 1.5, color: c.borderColor),
            SheetTile(
              icon: Icons.person_add_outlined,
              title: 'New connections',
              subtitle: 'when someone new sets this as their home $label',
              enabled: isHome,
              trailing: Switch(
                value: settings.notifyHomeConnections,
                activeColor: c.ink,
                onChanged: isHome
                    ? (_) => notifier.toggleNotifyHomeConnections()
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMembersList extends ConsumerWidget {
  final String cragId;
  final int memberCount;
  const HomeMembersList({
    super.key,
    required this.cragId,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final visible = ref.watch(visibleHomeMembersProvider(cragId));
    final hiddenCount = memberCount - visible.length;

    if (memberCount == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: Text(
          'No members yet. Be the first.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: c.textSecondary,
            height: 1.4,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ...visible.map((user) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/profile/${user.uid}');
              },
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: c.ink,
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
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: c.ink,
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.canvas,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.textDisabled, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+$hiddenCount',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: c.textDisabled,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 52,
                  child: Text(
                    'private',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: c.textDisabled,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
