import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/favorite_notify_row.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/home_base_sheet.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/members_preview_row.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CragDetailScreen extends ConsumerWidget {
  final String cragId;
  const CragDetailScreen({super.key, required this.cragId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final cragAsync = ref.watch(cragProvider(cragId));

    return Scaffold(
      backgroundColor: c.canvas,
      body: cragAsync.when(
        data: (crag) {
          if (crag == null) {
            return Center(
              child: Text(
                'crag not found',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: c.error,
                ),
              ),
            );
          }
          return _buildBody(context, ref, crag);
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
      floatingActionButton: cragAsync.when(
        data: (crag) => crag == null ? null : _buildFab(context, crag),
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, WidgetRef ref, Crag crag) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, crag),
        SliverToBoxAdapter(child: _buildCragInfo(context, ref, crag)),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  // ── App bar — flat canvas, hairline divider, ink title.
  SliverAppBar _buildAppBar(BuildContext context, Crag crag) {
    final c = context.appColors;
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: c.canvas,
      foregroundColor: c.ink,
      surfaceTintColor: Colors.transparent,
      leading: BackButton(
        color: c.ink,
        onPressed: () => context.canPop() ? context.pop() : context.go('/'),
      ),
      shape: Border(
        bottom: BorderSide(color: c.borderColor, width: 1.5),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            crag.name,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: c.ink,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (crag.region != null)
            Text(
              crag.region!,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: c.textSecondary,
                letterSpacing: -0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  // ── Crag info ──────────────────────────────────────────────────────────────

  Widget _buildCragInfo(BuildContext context, WidgetRef ref, Crag crag) {
    final c = context.appColors;
    final settings = ref.watch(homeSettingsProvider);
    final isHome =
        settings.homeCragId == crag.id || settings.homeGymId == crag.id;
    final label = crag.isGym ? 'gym' : 'crag';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (crag.description != null) ...[
            Text(
              crag.description!,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: c.ink,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Vibes
          _buildVibeChips(context, ref, crag.id),

          const SizedBox(height: 14),

          // Home base row
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _showHomeBaseSheet(context, ref, crag),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isHome ? c.ink : c.canvas,
                border: Border.all(color: c.ink, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(
                    isHome ? Icons.home : Icons.home_outlined,
                    size: 16,
                    color: isHome ? c.canvas : c.ink,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHome ? 'your home $label' : 'set as home $label',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isHome ? c.canvas : c.ink,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: isHome ? c.canvas : c.ink,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Members preview row
          MembersPreviewRow(cragId: crag.id, crag: crag),

          const SizedBox(height: 10),

          // Favorite + notification row
          FavoriteNotifyRow(crag: crag),

          const SizedBox(height: 18),
          Container(height: 1.5, color: c.borderColor),
        ],
      ),
    );
  }

  void _showHomeBaseSheet(BuildContext context, WidgetRef ref, Crag crag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => HomeBaseSheet(crag: crag),
    );
  }

  // ── Vibe chips ─────────────────────────────────────────────────────────────

  Widget _buildVibeChips(BuildContext context, WidgetRef ref, String cragId) {
    final vibeTags = ref.watch(cragVibeTagsProvider(cragId));
    if (vibeTags.isEmpty) return const SizedBox.shrink();
    final c = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vibes',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: vibeTags.map((vt) {
            final tag = ClimbingTags.getById(vt.tagId);
            if (tag == null) return const SizedBox.shrink();
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: c.canvas,
                border: Border.all(color: c.ink, width: 1.5),
              ),
              child: Text(
                vt.count > 1
                    ? '${tag.label.toLowerCase()} ×${vt.count}'
                    : tag.label.toLowerCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                  letterSpacing: -0.1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFab(BuildContext context, Crag crag) {
    final c = context.appColors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/crag/${crag.id}/post', extra: crag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: c.ink,
          border: Border.all(color: c.ink, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18, color: c.canvas),
            const SizedBox(width: 8),
            Text(
              'post',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.canvas,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
