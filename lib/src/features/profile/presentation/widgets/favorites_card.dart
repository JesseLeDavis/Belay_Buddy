import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/favorites/data/favorites_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesCard extends StatelessWidget {
  final WidgetRef ref;
  const FavoritesCard({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final favoritesAsync = ref.watch(favoriteCragsProvider);
    final venues = favoritesAsync.valueOrNull ?? [];

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
            color: c.dullOrange,
            child: Row(
              children: [
                Text(
                  'FAVORITES',
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
                    border: Border.all(color: c.borderColor, width: 1.5),
                  ),
                  child: Text(
                    '${venues.length}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: c.dullOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (venues.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.explore_outlined,
                      size: 16, color: c.textDisabled),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Star crags & gyms from the map to see them here.',
                      style: GoogleFonts.cabin(
                          fontSize: 13, color: c.textSecondary),
                    ),
                  ),
                ],
              ),
            )
          else
            ...venues.map((venue) => FavoriteRow(venue: venue, ref: ref)),
        ],
      ),
    );
  }
}

class FavoriteRow extends StatelessWidget {
  final Crag venue;
  final WidgetRef ref;
  const FavoriteRow({super.key, required this.venue, required this.ref});

  static const _cragTypeLabels = {
    CragType.sport: 'SPORT',
    CragType.trad: 'TRAD',
    CragType.boulder: 'BOULDER',
    CragType.mixed: 'MIXED',
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final cragTypeColors = {
      CragType.sport: c.accentBlue,
      CragType.trad: c.dullOrange,
      CragType.boulder: c.oliveGreen,
      CragType.mixed: c.amber,
    };

    return GestureDetector(
      onTap: () => context.push('/crag/${venue.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: c.darkGrey, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: venue.isGym
                    ? c.accentBlue.withAlpha(25)
                    : c.oliveGreen.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: venue.isGym ? c.accentBlue : c.oliveGreen,
                  width: 2,
                ),
              ),
              child: Icon(
                venue.isGym ? Icons.fitness_center : Icons.terrain,
                size: 16,
                color: venue.isGym ? c.accentBlue : c.oliveGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (venue.types.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 4,
                      children: venue.types.map((t) {
                        final color =
                            cragTypeColors[t] ?? c.textDisabled;
                        return Text(
                          _cragTypeLabels[t] ?? t.name.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  ref.read(favoritesProvider.notifier).toggleFavorite(venue.id),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.star, size: 20, color: c.dullOrange),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.chevron_right,
                size: 18, color: c.textDisabled),
          ],
        ),
      ),
    );
  }
}
