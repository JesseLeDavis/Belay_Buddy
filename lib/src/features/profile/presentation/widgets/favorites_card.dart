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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Favorites',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${venues.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: c.textDisabled,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (venues.isEmpty)
          Text(
            'Star crags & gyms from the map to see them here.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: c.textSecondary,
              height: 1.4,
            ),
          )
        else
          ...venues.map((venue) => _FavoriteRow(venue: venue, ref: ref)),
      ],
    );
  }
}

class _FavoriteRow extends StatelessWidget {
  final Crag venue;
  final WidgetRef ref;
  const _FavoriteRow({required this.venue, required this.ref});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/crag/${venue.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              venue.isGym ? Icons.fitness_center : Icons.terrain,
              size: 16,
              color: c.ink,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                venue.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  ref.read(favoritesProvider.notifier).toggleFavorite(venue.id),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.star, size: 18, color: c.ink),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: c.textDisabled),
          ],
        ),
      ),
    );
  }
}
