import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/lost_found/domain/lost_found_item.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/features/posts/data/posts_repository.dart';
import 'package:belay_buddy/src/features/lost_found/data/lost_found_repository.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/features/venues/presentation/crag_schedule_screen.dart';
import 'package:belay_buddy/src/features/lost_found/presentation/lost_found_screen.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/crag_widgets.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/favorite_notify_row.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/home_base_sheet.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/lost_found_preview_row.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/members_preview_row.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/post_detail_sheet.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/post_preview_row.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/widgets/collage_header.dart';
import 'package:belay_buddy/src/common/widgets/heatmap_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CragDetailScreen extends ConsumerWidget {
  final String cragId;
  const CragDetailScreen({super.key, required this.cragId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cragAsync = ref.watch(cragProvider(cragId));
    final postsAsync = ref.watch(postsAtCragProvider(cragId));
    final lostFoundAsync = ref.watch(lostFoundAtCragProvider(cragId));
    final countsByDate = ref.watch(postCountsByDateProvider(cragId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: cragAsync.when(
        data: (crag) {
          if (crag == null) {
            return Center(
              child: Text(
                'Crag not found',
                style: GoogleFonts.spaceMono(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            );
          }
          return _buildBody(
            context,
            ref,
            crag,
            postsAsync,
            lostFoundAsync,
            countsByDate,
          );
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
          child: Text('Error: $e',
              style: GoogleFonts.cabin(fontSize: 16, color: AppColors.error)),
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

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    Crag crag,
    AsyncValue<List<ClimbingPost>> postsAsync,
    AsyncValue<List<LostFoundItem>> lostFoundAsync,
    Map<DateTime, int> countsByDate,
  ) {
    final posts = postsAsync.valueOrNull ?? [];
    final lostFound = lostFoundAsync.valueOrNull ?? [];

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, crag),
        SliverToBoxAdapter(child: _buildCragInfo(context, ref, crag)),
        if (!crag.isGym)
          SliverToBoxAdapter(
            child: _buildLostFoundPanel(context, crag, lostFound),
          ),
        SliverToBoxAdapter(
          child: _buildCommunityPanel(context, ref, crag, posts, countsByDate),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  SliverAppBar _buildAppBar(BuildContext context, Crag crag) {
    final headerColor =
        crag.isGym ? AppColors.accentBlue : AppColors.oliveGreen;
    const expandedHeight = 260.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: headerColor,
      leading: BackButton(
        color: Colors.white,
        onPressed: () => context.canPop() ? context.pop() : context.go('/'),
      ),
      shape: const Border(
        bottom: BorderSide(color: AppColors.darkNavy, width: 3),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final topPadding = MediaQuery.of(context).padding.top;
          final collapsedHeight = kToolbarHeight + topPadding;
          final scrollFraction = (1 -
                  (constraints.maxHeight - collapsedHeight) /
                      (expandedHeight - collapsedHeight + topPadding))
              .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.only(bottom: 16),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  crag.name,
                  style: GoogleFonts.spaceMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (scrollFraction < 0.7)
                  Opacity(
                    opacity: (1 - scrollFraction / 0.7).clamp(0.0, 1.0),
                    child: Text(
                      '${crag.region ?? 'Unknown region'} / ${crag.types.map((t) => t.name.toUpperCase()).join(', ')}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ),
              ],
            ),
            background: CollageHeader(
              cragId: crag.id,
              isGym: crag.isGym,
              scrollFraction: scrollFraction,
            ),
          );
        },
      ),
    );
  }

  // ── Crag info ──────────────────────────────────────────────────────────────

  Widget _buildCragInfo(BuildContext context, WidgetRef ref, Crag crag) {
    final memberCount = ref.watch(homeMemberCountProvider(crag.id));
    final settings = ref.watch(homeSettingsProvider);
    final isHome =
        settings.homeCragId == crag.id || settings.homeGymId == crag.id;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                crag.region ?? 'Unknown region',
                style: GoogleFonts.spaceMono(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const Spacer(),
              ...crag.types.map((t) => Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.xs),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm, vertical: 3),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.darkNavy, width: 2),
                          borderRadius: BorderRadius.circular(AppRadius.sm)),
                      child: Text(
                        t.name.toUpperCase(),
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkNavy,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          if (crag.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              crag.description!,
              style: GoogleFonts.cabin(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),

          // Home base row
          GestureDetector(
            onTap: () => _showHomeBaseSheet(context, ref, crag),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 8),
              decoration: BoxDecoration(
                color: isHome
                    ? (crag.isGym ? AppColors.accentBlue : AppColors.oliveGreen)
                        .withAlpha(20)
                    : AppColors.chipBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: isHome
                      ? (crag.isGym
                          ? AppColors.accentBlue
                          : AppColors.oliveGreen)
                      : AppColors.darkGrey,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isHome ? Icons.home : Icons.home_outlined,
                    size: 16,
                    color: isHome
                        ? (crag.isGym
                            ? AppColors.accentBlue
                            : AppColors.oliveGreen)
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    isHome
                        ? 'YOUR HOME ${crag.isGym ? 'GYM' : 'CRAG'}'
                        : 'SET AS HOME ${crag.isGym ? 'GYM' : 'CRAG'}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isHome
                          ? (crag.isGym
                              ? AppColors.accentBlue
                              : AppColors.oliveGreen)
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.darkNavy,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColors.darkNavy, width: 1.5),
                    ),
                    child: Text(
                      '$memberCount ${memberCount == 1 ? 'MEMBER' : 'MEMBERS'}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.chevron_right,
                      size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Members preview row
          MembersPreviewRow(cragId: crag.id, crag: crag),

          const SizedBox(height: AppSpacing.sm),

          // Favorite + notification row
          FavoriteNotifyRow(crag: crag),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.darkNavy, thickness: 1),
        ],
      ),
    );
  }

  void _showHomeBaseSheet(BuildContext context, WidgetRef ref, Crag crag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (_) => HomeBaseSheet(crag: crag),
    );
  }

  // ── Lost & Found panel ─────────────────────────────────────────────────────

  Widget _buildLostFoundPanel(
      BuildContext context, Crag crag, List<LostFoundItem> items) {
    final foundCount =
        items.where((i) => i.status == LostFoundStatus.found).length;
    final lostCount =
        items.where((i) => i.status == LostFoundStatus.lost).length;
    final preview = items.take(2).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        boxShadow: const [
          BoxShadow(
              color: AppColors.darkNavy, offset: Offset(5, 5), blurRadius: 0)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.amber,
              border: Border(
                  bottom: BorderSide(color: AppColors.darkNavy, width: 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 16, color: AppColors.darkNavy),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'LOST & FOUND BIN',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const Spacer(),
                if (foundCount > 0) ...[
                  CountBadge(
                      label: '$foundCount FOUND', color: AppColors.oliveGreen),
                  const SizedBox(width: 6),
                ],
                if (lostCount > 0)
                  CountBadge(
                      label: '$lostCount LOST', color: AppColors.dullOrange),
              ],
            ),
          ),

          // Content
          if (preview.isEmpty)
            _emptyPanelRow('NOTHING POSTED YET', Icons.backpack_outlined)
          else
            ...preview.map((item) => LostFoundPreviewRow(item: item)),

          // Footer
          PanelFooter(
            label: items.isEmpty
                ? 'POST AN ITEM'
                : 'VIEW ALL ${items.length} ITEMS →',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LostFoundScreen(cragId: crag.id),
            )),
          ),
        ],
      ),
    );
  }

  // ── Community Board panel ──────────────────────────────────────────────────

  Widget _buildCommunityPanel(
    BuildContext context,
    WidgetRef ref,
    Crag crag,
    List<ClimbingPost> posts,
    Map<DateTime, int> countsByDate,
  ) {
    final upcoming = posts
        .where((p) =>
            !p.isExpired &&
            p.dateTime
                .isAfter(DateTime.now().subtract(const Duration(hours: 1))))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final preview = upcoming.take(2).toList();

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        boxShadow: const [
          BoxShadow(
              color: AppColors.darkNavy, offset: Offset(5, 5), blurRadius: 0)
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.dullOrange,
              border: Border(
                  bottom: BorderSide(color: AppColors.darkNavy, width: 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.group_outlined, size: 16, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'COMMUNITY BOARD',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                CountBadge(
                  label: '${upcoming.length} THIS WEEK',
                  color: AppColors.surface,
                  textColor: AppColors.darkNavy,
                ),
              ],
            ),
          ),

          // Heatmap strip
          HeatmapStrip(
            countsByDate: countsByDate,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CragScheduleScreen(cragId: crag.id),
            )),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.darkNavy),

          // Post previews
          if (preview.isEmpty)
            _emptyPanelRow('NO SESSIONS POSTED', Icons.event_available_outlined)
          else
            ...preview.map((post) => PostPreviewRow(
                  post: post,
                  onTap: () => _showPostDetail(context, ref, post),
                )),

          // Footer
          PanelFooter(
            label: posts.isEmpty ? 'POST A SESSION' : 'VIEW FULL SCHEDULE →',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CragScheduleScreen(cragId: crag.id),
            )),
          ),
        ],
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFab(BuildContext context, Crag crag) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: const [
          BoxShadow(
              color: AppColors.darkNavy, offset: Offset(4, 4), blurRadius: 0)
        ],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'create_post_fab',
        backgroundColor: AppColors.dullOrange,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
          side: BorderSide(color: AppColors.darkNavy, width: 2.5),
        ),
        onPressed: () => _showPostTypeSheet(context, crag),
        icon: const Icon(Icons.add),
        label: Text(
          'POST',
          style:
              GoogleFonts.spaceMono(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showPostTypeSheet(BuildContext context, Crag crag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (_) => PostTypeSheet(crag: crag),
    );
  }

  // ── Post detail ────────────────────────────────────────────────────────────

  void _showPostDetail(BuildContext context, WidgetRef ref, ClimbingPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
      builder: (_) => PostDetailSheet(post: post),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _emptyPanelRow(String message, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.textDisabled),
          const SizedBox(width: AppSpacing.sm),
          Text(
            message,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
