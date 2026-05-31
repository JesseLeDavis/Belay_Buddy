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

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                ref.read(favoritesProvider.notifier).toggleFavorite(crag.id),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isFav ? c.ink : c.canvas,
                border: Border.all(color: c.ink, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFav ? Icons.star : Icons.star_outline,
                    size: 16,
                    color: isFav ? c.canvas : c.ink,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFav ? 'favorited' : 'favorite',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isFav ? c.canvas : c.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showVenueNotifySheet(context, crag),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.canvas,
              border: Border.all(color: c.ink, width: 1.5),
            ),
            child: Icon(
              hasNotifications
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_none,
              size: 18,
              color: c.ink,
            ),
          ),
        ),
      ],
    );
  }

  void _showVenueNotifySheet(BuildContext context, Crag crag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
    final label = crag.isGym ? 'gym' : 'crag';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
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
                'Notify me about ${crag.name}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
            ),
            if (!isFav) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Favorite this $label to enable notifications.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: c.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => favNotifier.toggleFavorite(crag.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: c.ink,
                          border: Border.all(color: c.ink, width: 1.5),
                        ),
                        child: Text(
                          'favorite',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: c.canvas,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'Get notified about activity at this $label, '
                  'even if it’s not your home $label.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: c.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            Container(height: 1.5, color: c.borderColor),
            SheetTile(
              icon: Icons.pan_tool_outlined,
              title: 'Catch needed',
              subtitle:
                  'When someone at this $label needs a belay partner',
              enabled: isFav,
              trailing: Switch(
                value: notifyPrefs.notifyCatch,
                activeColor: c.ink,
                onChanged: isFav
                    ? (_) => favNotifier.toggleNotifyCatch(crag.id)
                    : null,
              ),
            ),
            Container(height: 1.5, color: c.borderColor),
            SheetTile(
              icon: Icons.person_add_outlined,
              title: 'New members',
              subtitle: 'When someone new joins this $label',
              enabled: isFav,
              trailing: Switch(
                value: notifyPrefs.notifyConnections,
                activeColor: c.ink,
                onChanged: isFav
                    ? (_) => favNotifier.toggleNotifyConnections(crag.id)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
