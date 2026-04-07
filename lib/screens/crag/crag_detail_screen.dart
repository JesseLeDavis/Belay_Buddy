import 'package:belay_buddy/models/app_user.dart';
import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/models/lost_found_item.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/screens/crag/crag_schedule_screen.dart';
import 'package:belay_buddy/screens/crag/lost_found_screen.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:belay_buddy/utils/climbing_tags.dart';
import 'package:belay_buddy/widgets/collage_header.dart';
import 'package:belay_buddy/widgets/heatmap_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
          _MembersPreviewRow(cragId: crag.id, crag: crag),

          const SizedBox(height: AppSpacing.sm),

          // Favorite + notification row
          _FavoriteNotifyRow(crag: crag),

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
      builder: (_) => _HomeBaseSheet(crag: crag),
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
                  _CountBadge(
                      label: '$foundCount FOUND', color: AppColors.oliveGreen),
                  const SizedBox(width: 6),
                ],
                if (lostCount > 0)
                  _CountBadge(
                      label: '$lostCount LOST', color: AppColors.dullOrange),
              ],
            ),
          ),

          // Content
          if (preview.isEmpty)
            _emptyPanelRow('NOTHING POSTED YET', Icons.backpack_outlined)
          else
            ...preview.map((item) => _LostFoundPreviewRow(item: item)),

          // Footer
          _PanelFooter(
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
                _CountBadge(
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
            ...preview.map((post) => _PostPreviewRow(
                  post: post,
                  onTap: () => _showPostDetail(context, ref, post),
                )),

          // Footer
          _PanelFooter(
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
      builder: (_) => _PostTypeSheet(crag: crag),
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

// ── Shared small widgets ───────────────────────────────────────────────────────

class _CountBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _CountBadge({
    required this.label,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.darkNavy, width: 2),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _PanelFooter extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PanelFooter({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.chipBg,
          border: Border(top: BorderSide(color: AppColors.darkNavy, width: 1)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.darkNavy,
          ),
        ),
      ),
    );
  }
}

class _LostFoundPreviewRow extends StatelessWidget {
  final LostFoundItem item;
  const _LostFoundPreviewRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final isFound = item.status == LostFoundStatus.found;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.darkGrey, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isFound ? AppColors.oliveGreen : AppColors.dullOrange,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.darkNavy, width: 1.5),
            ),
            child: Text(
              isFound ? 'FOUND' : 'LOST',
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: GoogleFonts.cabin(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                Text(
                  _categoryName(item.category),
                  style: GoogleFonts.spaceMono(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            _timeAgo(item.createdAt),
            style: GoogleFonts.spaceMono(
                fontSize: 10, color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _categoryName(LostFoundCategory cat) {
    switch (cat) {
      case LostFoundCategory.gear:
        return 'Gear';
      case LostFoundCategory.clothing:
        return 'Clothing';
      case LostFoundCategory.personalItem:
        return 'Personal Item';
      case LostFoundCategory.rope:
        return 'Rope';
      case LostFoundCategory.other:
        return 'Other';
    }
  }
}

class _PostPreviewRow extends ConsumerWidget {
  final ClimbingPost post;
  final VoidCallback onTap;
  const _PostPreviewRow({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(post.userId));
    final isNow = post.type == PostType.immediate;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColors.darkGrey, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              color: isNow ? AppColors.dullOrange : AppColors.oliveGreen,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  userAsync.when(
                    data: (user) => Text(
                      user?.displayName ?? 'Unknown',
                      style: GoogleFonts.spaceMono(
                          fontSize: 10, color: AppColors.textSecondary),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(post.dateTime),
                  style: GoogleFonts.spaceMono(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                if (post.needsBelay)
                  Text('NEED BELAY',
                      style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentBlue)),
                if (post.offeringBelay)
                  Text('CAN BELAY',
                      style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.oliveGreen)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = dt.difference(DateTime.now());
    if (diff.inMinutes < 0) return 'NOW';
    if (diff.inMinutes < 60) return 'in ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'in ${diff.inHours}h';
    return DateFormat('EEE MMM d').format(dt);
  }
}

// ── Post type chooser sheet ───────────────────────────────────────────────────

class _PostTypeSheet extends StatelessWidget {
  final Crag crag;
  const _PostTypeSheet({required this.crag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.darkNavy, width: 3)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
                width: 40, height: 4, color: AppColors.darkNavy.withAlpha(80)),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'WHAT DO YOU WANT TO POST?',
              style: GoogleFonts.spaceMono(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.darkNavy,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PostTypeOption(
            accentColor: AppColors.oliveGreen,
            icon: Icons.group_outlined,
            title: 'PARTNER SESSION',
            subtitle: 'Find someone to climb with on a specific day',
            onTap: () {
              Navigator.of(context).pop();
              context.push('/crag/${crag.id}/post', extra: crag);
            },
          ),
          if (!crag.isGym) ...[
            const Divider(height: 1, thickness: 1, color: AppColors.darkNavy),
            _PostTypeOption(
              accentColor: AppColors.amber,
              icon: Icons.inventory_2_outlined,
              title: 'LOST & FOUND',
              subtitle: 'Report a found item or post a lookout request',
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LostFoundScreen(cragId: crag.id),
                ));
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PostTypeOption extends StatelessWidget {
  final Color accentColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PostTypeOption({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(width: 4, height: 48, color: accentColor),
            const SizedBox(width: AppSpacing.md),
            Icon(icon, size: 24, color: accentColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.cabin(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.darkNavy),
          ],
        ),
      ),
    );
  }
}

// ── Post detail bottom sheet ──────────────────────────────────────────────────

class PostDetailSheet extends ConsumerWidget {
  final ClimbingPost post;
  const PostDetailSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(post.userId));

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border:
                Border(top: BorderSide(color: AppColors.darkNavy, width: 3)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.sm,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        color: AppColors.darkNavy.withAlpha(80)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: post.type == PostType.immediate
                              ? AppColors.dullOrange
                              : AppColors.oliveGreen,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: AppColors.darkNavy, width: 2),
                        ),
                        child: Text(
                          post.type == PostType.immediate
                              ? '● NOW'
                              : '◆ SCHEDULED',
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          post.title,
                          style: GoogleFonts.spaceMono(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkNavy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (post.description != null &&
                      post.description!.isNotEmpty) ...[
                    Text(
                      post.description!,
                      style: GoogleFonts.cabin(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 16, color: AppColors.amber),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _formatFullDateTime(post.dateTime),
                        style: GoogleFonts.spaceMono(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      if (post.needsBelay)
                        _detailChip('NEED BELAY', AppColors.accentBlue),
                      if (post.offeringBelay)
                        _detailChip('CAN BELAY', AppColors.oliveGreen),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(color: AppColors.darkNavy, thickness: 1),
                  const SizedBox(height: AppSpacing.sm),
                  userAsync.when(
                    data: (user) => GestureDetector(
                      onTap: user != null
                          ? () {
                              Navigator.of(context).pop();
                              context.push('/profile/${user.uid}');
                            }
                          : null,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.darkNavy,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                user?.displayName.isNotEmpty == true
                                    ? user!.displayName[0].toUpperCase()
                                    : '?',
                                style: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? 'Unknown Climber',
                                  style: GoogleFonts.cabin(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkNavy,
                                  ),
                                ),
                                if (user != null)
                                  Text(
                                    user.climbingStyles
                                        .map(_styleName)
                                        .join(' · '),
                                    style: GoogleFonts.spaceMono(
                                        fontSize: 11,
                                        color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox(height: 40),
                    error: (_, __) => Text('Unknown Climber',
                        style: GoogleFonts.cabin(
                            fontSize: 16, color: AppColors.textDisabled)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PostActionButtons(post: post, userAsync: userAsync),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailChip(String label, Color color) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.darkNavy, width: 2),
          color: color),
      child: Text(label,
          style: GoogleFonts.spaceMono(
              fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }

  String _formatFullDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.isNegative) {
      final f = dt.difference(now);
      if (f.inMinutes < 60) return 'in ${f.inMinutes}m';
      if (f.inHours < 24) return 'in ${f.inHours}h';
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dt);
    } else {
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dt);
    }
  }

  String _styleName(dynamic style) {
    const names = {
      'sport': 'Sport',
      'trad': 'Trad',
      'boulder': 'Boulder',
      'all': 'All Styles',
    };
    return names[style.toString().split('.').last] ?? style.toString();
  }
}

// ── Post action buttons (Message + Connect) ───────────────────────────────────

class _PostActionButtons extends ConsumerStatefulWidget {
  final ClimbingPost post;
  final AsyncValue<AppUser?> userAsync;

  const _PostActionButtons({required this.post, required this.userAsync});

  @override
  ConsumerState<_PostActionButtons> createState() => _PostActionButtonsState();
}

class _PostActionButtonsState extends ConsumerState<_PostActionButtons> {
  bool _connectRequestSent = false;

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserIdSyncProvider);
    final isOwnPost = widget.post.userId == currentUserId;
    final isConnected = ref.watch(isConnectedProvider(widget.post.userId));
    final posterName = widget.userAsync.asData?.value?.displayName ?? 'CLIMBER';

    if (isOwnPost) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Message button
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkNavy,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: AppColors.darkNavy, width: 2.5)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Message sent to $posterName',
                style: GoogleFonts.cabin(color: Colors.white, fontSize: 14),
              ),
            ));
          },
          icon: const Icon(Icons.chat_bubble_outline),
          label: Text(
            'MESSAGE ${posterName.toUpperCase()}',
            style: GoogleFonts.spaceMono(
                fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Connect button — hidden if already connected or own post
        if (!isConnected)
          GestureDetector(
            onTap: _connectRequestSent
                ? null
                : () {
                    setState(() => _connectRequestSent = true);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Connection request sent to $posterName',
                        style: GoogleFonts.cabin(
                            color: Colors.white, fontSize: 14),
                      ),
                      backgroundColor: AppColors.accentBlue,
                    ));
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _connectRequestSent
                    ? AppColors.chipBg
                    : AppColors.accentBlue,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.darkNavy, width: 2.5),
                boxShadow: _connectRequestSent
                    ? null
                    : const [
                        BoxShadow(
                            color: AppColors.darkNavy,
                            offset: Offset(3, 3),
                            blurRadius: 0)
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _connectRequestSent
                        ? Icons.hourglass_empty
                        : Icons.person_add_outlined,
                    size: 16,
                    color: _connectRequestSent
                        ? AppColors.textSecondary
                        : Colors.white,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _connectRequestSent
                        ? 'REQUEST SENT'
                        : 'CONNECT WITH ${posterName.toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _connectRequestSent
                          ? AppColors.textSecondary
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.oliveGreen,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.darkNavy, width: 2.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'CONNECTED WITH ${posterName.toUpperCase()}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Favorite + Notify row ────────────────────────────────────────────────────

class _FavoriteNotifyRow extends ConsumerWidget {
  final Crag crag;
  const _FavoriteNotifyRow({required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(crag.id));
    final notifyPrefs = ref.watch(venueNotifyPrefsProvider(crag.id));
    final hasNotifications =
        notifyPrefs.notifyCatch || notifyPrefs.notifyConnections;
    final accentColor =
        crag.isGym ? AppColors.accentBlue : AppColors.oliveGreen;

    return Row(
      children: [
        // Favorite button
        Expanded(
          child: GestureDetector(
            onTap: () =>
                ref.read(favoritesProvider.notifier).toggleFavorite(crag.id),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 8),
              decoration: BoxDecoration(
                color: isFav
                    ? AppColors.accentBlue.withAlpha(25)
                    : AppColors.chipBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: isFav ? AppColors.accentBlue : AppColors.darkGrey,
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
                        isFav ? AppColors.accentBlue : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    isFav ? 'FAVORITED' : 'FAVORITE',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isFav
                          ? AppColors.accentBlue
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Notification bell — opens venue notify sheet
        GestureDetector(
          onTap: () => _showVenueNotifySheet(context, crag),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: hasNotifications
                  ? accentColor.withAlpha(20)
                  : AppColors.chipBg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: hasNotifications ? accentColor : AppColors.darkGrey,
                width: 2,
              ),
            ),
            child: Icon(
              hasNotifications
                  ? Icons.notifications_active
                  : Icons.notifications_none,
              size: 18,
              color: hasNotifications ? accentColor : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  void _showVenueNotifySheet(BuildContext context, Crag crag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => _VenueNotifySheet(crag: crag),
    );
  }
}

// ── Venue notification sheet ─────────────────────────────────────────────────

class _VenueNotifySheet extends ConsumerWidget {
  final Crag crag;
  const _VenueNotifySheet({required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(crag.id));
    final notifyPrefs = ref.watch(venueNotifyPrefsProvider(crag.id));
    final favNotifier = ref.read(favoritesProvider.notifier);
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
          // Header
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

          // Favorite required hint
          if (!isFav) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.amber.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.amber, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_outline,
                        size: 18, color: AppColors.amber),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Favorite this $label to enable notifications',
                        style: GoogleFonts.cabin(
                          fontSize: 13,
                          color: AppColors.textSecondary,
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
                          color: AppColors.amber,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: AppColors.darkNavy, width: 2),
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
                    fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Catch needed toggle
          _SheetTile(
            icon: Icons.pan_tool_outlined,
            iconColor: AppColors.dullOrange,
            title: 'CATCH / BELAY NEEDED',
            subtitle:
                'Alert when someone at this ${label.toLowerCase()} needs a partner',
            enabled: isFav,
            trailing: Switch(
              value: notifyPrefs.notifyCatch,
              activeColor: AppColors.dullOrange,
              onChanged:
                  isFav ? (_) => favNotifier.toggleNotifyCatch(crag.id) : null,
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),

          // New connections toggle
          _SheetTile(
            icon: Icons.person_add_outlined,
            iconColor: AppColors.accentBlue,
            title: 'NEW MEMBERS',
            subtitle:
                'Alert when someone new joins this ${label.toLowerCase()}',
            enabled: isFav,
            trailing: Switch(
              value: notifyPrefs.notifyConnections,
              activeColor: AppColors.accentBlue,
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

// ── Home base sheet ───────────────────────────────────────────────────────────

// ── Members preview row ──────────────────────────────────────────────────────

class _MembersPreviewRow extends ConsumerWidget {
  final String cragId;
  final Crag crag;
  const _MembersPreviewRow({required this.cragId, required this.crag});

  static const _avatarColors = [
    AppColors.dullOrange,
    AppColors.accentBlue,
    AppColors.oliveGreen,
    AppColors.amber,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleHomeMembersProvider(cragId));
    final memberCount = ref.watch(homeMemberCountProvider(cragId));

    if (memberCount == 0) return const SizedBox.shrink();

    // Show up to 4 random-ish avatars
    final preview = List<AppUser>.from(visible)..shuffle();
    final shown = preview.take(4).toList();
    final extra = memberCount - shown.length;

    return GestureDetector(
      onTap: () => _showMembersCarousel(context, cragId, crag),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.chipBg,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.darkGrey, width: 2),
        ),
        child: Row(
          children: [
            // Stacked avatars
            SizedBox(
              width: shown.length * 24.0 + 8,
              height: 32,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < shown.length; i++)
                    Positioned(
                      left: i * 22.0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _avatarColors[
                              shown[i].uid.hashCode % _avatarColors.length],
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.surface, width: 2.5),
                        ),
                        child: Center(
                          child: Text(
                            shown[i].displayName.isNotEmpty
                                ? shown[i].displayName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.spaceMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                '$memberCount ${memberCount == 1 ? 'MEMBER' : 'MEMBERS'}',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkNavy,
                ),
              ),
            ),
            if (extra > 0)
              Text(
                '+$extra more',
                style: GoogleFonts.cabin(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'SEE ALL',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.accentBlue,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right,
                size: 14, color: AppColors.accentBlue),
          ],
        ),
      ),
    );
  }

  void _showMembersCarousel(BuildContext context, String cragId, Crag crag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MembersCarouselSheet(cragId: cragId, crag: crag),
    );
  }
}

// ── Members carousel sheet ──────────────────────────────────────────────────

class _MembersCarouselSheet extends ConsumerStatefulWidget {
  final String cragId;
  final Crag crag;
  const _MembersCarouselSheet({required this.cragId, required this.crag});

  @override
  ConsumerState<_MembersCarouselSheet> createState() =>
      _MembersCarouselSheetState();
}

class _MembersCarouselSheetState extends ConsumerState<_MembersCarouselSheet> {
  late final ScrollController _scrollCtrl;
  final _itemWidth = 90.0;
  final _itemGap = 12.0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  static const _avatarColors = [
    AppColors.dullOrange,
    AppColors.accentBlue,
    AppColors.oliveGreen,
    AppColors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(visibleHomeMembersProvider(widget.cragId));
    final memberCount = ref.watch(homeMemberCountProvider(widget.cragId));
    final hiddenCount = memberCount - visible.length;
    final accentColor =
        widget.crag.isGym ? AppColors.accentBlue : AppColors.oliveGreen;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        border: Border(
          top: BorderSide(color: AppColors.darkNavy, width: 3),
          left: BorderSide(color: AppColors.darkNavy, width: 3),
          right: BorderSide(color: AppColors.darkNavy, width: 3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Text(
                  'LOCALS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.darkNavy, width: 1.5),
                  ),
                  child: Text(
                    '$memberCount',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (hiddenCount > 0) ...[
                  const Spacer(),
                  Text(
                    '$hiddenCount private',
                    style: GoogleFonts.cabin(
                        fontSize: 12, color: AppColors.textDisabled),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Carousel
          SizedBox(
            height: 140,
            child: ListView.builder(
              controller: _scrollCtrl,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              // padding: EdgeInsets.symmetric(
              //     horizontal: (screenWidth - _itemWidth) / 4),
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final user = visible[i];
                final scale = _scaleFor(i, screenWidth);
                final color =
                    _avatarColors[user.uid.hashCode % _avatarColors.length];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/profile/${user.uid}');
                  },
                  child: Container(
                    width: _itemWidth + _itemGap,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                  color: AppColors.darkNavy, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withAlpha(
                                      (80 * scale).round().clamp(0, 255)),
                                  offset: Offset(3 * scale, 3 * scale),
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
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            user.displayName.split(' ').first,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (user.climbingTags.isNotEmpty)
                            Text(
                              _firstTagLabel(user.climbingTags.first),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.spaceMono(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).padding.bottom + AppSpacing.lg),
        ],
      ),
    );
  }

  double _scaleFor(int index, double screenWidth) {
    if (!_scrollCtrl.hasClients) return index == 0 ? 1.0 : 0.75;
    final scrollOffset = _scrollCtrl.offset;
    final itemCenter = index * (_itemWidth + _itemGap) + _itemWidth / 2;
    final viewCenter = scrollOffset + screenWidth / 2;
    final dist = (itemCenter - viewCenter).abs();
    // Items within ~half an item width of center are full scale
    final t = (dist / (_itemWidth + _itemGap)).clamp(0.0, 2.0);
    return 1.0 - (t * 0.25); // scale from 1.0 down to 0.5
  }

  String _firstTagLabel(String tagId) {
    final tag = ClimbingTags.getById(tagId);
    return tag?.label ?? tagId.toUpperCase();
  }
}

// ── Home base sheet ───────────────────────────────────────────────────────────

class _HomeBaseSheet extends ConsumerWidget {
  final Crag crag;
  const _HomeBaseSheet({required this.crag});

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
          // Header
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

          // Member list
          _HomeMembersList(cragId: crag.id, memberCount: memberCount),

          const Divider(height: 1, thickness: 1, color: AppColors.darkGrey),

          // Set / unset home
          _SheetTile(
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

          // Visibility
          _SheetTile(
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

          // Notify: catch needed
          _SheetTile(
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

          // Notify: new connections
          _SheetTile(
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

class _HomeMembersList extends ConsumerWidget {
  final String cragId;
  final int memberCount;
  const _HomeMembersList({required this.cragId, required this.memberCount});

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

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool enabled;

  const _SheetTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.cabin(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
