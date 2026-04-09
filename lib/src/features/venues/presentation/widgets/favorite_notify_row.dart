import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/favorites/data/favorites_repository.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/crag_widgets.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteNotifyRow extends ConsumerWidget {
  final Crag crag;
  const FavoriteNotifyRow({super.key, required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final isFav = ref.watch(isFavoriteProvider(crag.id));
    final notifyPrefs = ref.watch(venueNotifyPrefsProvider(crag.id));
    final hasNotifications =
        notifyPrefs.notifyCatch || notifyPrefs.notifyConnections;
    final accentColor =
        crag.isGym ? c.accentBlue : c.oliveGreen;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () =>
                ref.read(favoritesProvider.notifier).toggleFavorite(crag.id),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 8),
              decoration: BoxDecoration(
                color: isFav
                    ? c.accentBlue.withAlpha(25)
                    : c.chipBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: isFav ? c.accentBlue : c.darkGrey,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFav ? Icons.star : Icons.star_outline,
                    size: 16,
                    color:
                        isFav ? c.accentBlue : c.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    isFav ? 'FAVORITED' : 'FAVORITE',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isFav
                          ? c.accentBlue
                          : c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        GestureDetector(
          onTap: () => _showVenueNotifySheet(context, crag),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: hasNotifications
                  ? accentColor.withAlpha(20)
                  : c.chipBg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: hasNotifications ? accentColor : c.darkGrey,
                width: 2,
              ),
            ),
            child: Icon(
              hasNotifications
                  ? Icons.notifications_active
                  : Icons.notifications_none,
              size: 18,
              color: hasNotifications ? accentColor : c.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  void _showVenueNotifySheet(BuildContext context, Crag crag) {
    final c = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: c.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => VenueNotifySheet(crag: crag),
    );
  }
}

class VenueNotifySheet extends ConsumerWidget {
  final Crag crag;
  const VenueNotifySheet({super.key, required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final isFav = ref.watch(isFavoriteProvider(crag.id));
    final notifyPrefs = ref.watch(venueNotifyPrefsProvider(crag.id));
    final favNotifier = ref.read(favoritesProvider.notifier);
    final accentColor =
        crag.isGym ? c.accentBlue : c.oliveGreen;
    final label = crag.isGym ? 'GYM' : 'CRAG';

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.borderColor, width: 3)),
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
              border: Border(
                  bottom: BorderSide(color: c.borderColor, width: 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications, size: 18, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'NOTIFICATIONS · ${crag.name.toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (!isFav) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: c.amber.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: c.amber, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_outline,
                        size: 18, color: c.amber),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Favorite this $label to enable notifications',
                        style: GoogleFonts.cabin(
                          fontSize: 13,
                          color: c.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => favNotifier.toggleFavorite(crag.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.amber,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: c.borderColor, width: 2),
                        ),
                        child: Text(
                          'FAVORITE',
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Text(
                'Get notified about activity at this ${label.toLowerCase()}, '
                'even if it\'s not your home ${label.toLowerCase()}.',
                style: GoogleFonts.cabin(
                    fontSize: 13, color: c.textSecondary, height: 1.4),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          SheetTile(
            icon: Icons.pan_tool_outlined,
            iconColor: c.dullOrange,
            title: 'CATCH / BELAY NEEDED',
            subtitle:
                'Alert when someone at this ${label.toLowerCase()} needs a partner',
            enabled: isFav,
            trailing: Switch(
              value: notifyPrefs.notifyCatch,
              activeColor: c.dullOrange,
              onChanged:
                  isFav ? (_) => favNotifier.toggleNotifyCatch(crag.id) : null,
            ),
          ),
          Divider(height: 1, thickness: 1, color: c.darkGrey),
          SheetTile(
            icon: Icons.person_add_outlined,
            iconColor: c.accentBlue,
            title: 'NEW MEMBERS',
            subtitle:
                'Alert when someone new joins this ${label.toLowerCase()}',
            enabled: isFav,
            trailing: Switch(
              value: notifyPrefs.notifyConnections,
              activeColor: c.accentBlue,
              onChanged: isFav
                  ? (_) => favNotifier.toggleNotifyConnections(crag.id)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
