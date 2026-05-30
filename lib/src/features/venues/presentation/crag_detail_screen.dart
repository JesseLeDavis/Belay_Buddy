import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/features/posts/data/posts_repository.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/crag_widgets.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/favorite_notify_row.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/home_base_sheet.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/members_preview_row.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/post_detail_sheet.dart';
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
    final c = context.appColors;
    final cragAsync = ref.watch(cragProvider(cragId));
    final postsAsync = ref.watch(postsAtCragProvider(cragId));
    final countsByDate = ref.watch(postCountsByDateProvider(cragId));

    return Scaffold(
      backgroundColor: c.background,
      body: cragAsync.when(
        data: (crag) {
          if (crag == null) {
            return Center(
              child: Text(
                'Crag not found',
                style: GoogleFonts.spaceMono(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.error,
                ),
              ),
            );
          }
          return _buildBody(
            context,
            ref,
            crag,
            postsAsync,
            countsByDate,
          );
        },
        loading: () => Center(
          child: Text(
            'LOADING...',
            style: GoogleFonts.spaceMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: GoogleFonts.cabin(fontSize: 16, color: c.error)),
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
    Map<DateTime, int> countsByDate,
  ) {
    final posts = postsAsync.valueOrNull ?? [];

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, crag),
        SliverToBoxAdapter(child: _buildCragInfo(context, ref, crag)),
        SliverToBoxAdapter(
          child: _buildCommunityPanel(context, ref, crag, posts, countsByDate),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  SliverAppBar _buildAppBar(BuildContext context, Crag crag) {
    final c = context.appColors;
    final headerColor =
        crag.isGym ? c.accentBlue : c.oliveGreen;
    const expandedHeight = 260.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: headerColor,
      leading: BackButton(
        color: c.textOnPrimary,
        onPressed: () => context.canPop() ? context.pop() : context.go('/'),
      ),
      shape: Border(
        bottom: BorderSide(color: c.borderColor, width: 3),
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
                    color: c.textOnPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (scrollFraction < 0.7)
                  Opacity(
                    opacity: (1 - scrollFraction / 0.7).clamp(0.0, 1.0),
                    child: Text(
                      crag.region ?? 'Unknown region',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        color: c.textOnPrimary.withAlpha(204),
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
    final c = context.appColors;
    final memberCount = ref.watch(homeMemberCountProvider(crag.id));
    final settings = ref.watch(homeSettingsProvider);
    final isHome =
        settings.homeCragId == crag.id || settings.homeGymId == crag.id;

    return Container(
      color: c.background,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on,
                  size: 14, color: c.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                crag.region ?? 'Unknown region',
                style: GoogleFonts.spaceMono(
                    fontSize: 12, color: c.textSecondary),
              ),
            ],
          ),
          _buildVibeChips(context, ref, crag.id),
          if (crag.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              crag.description!,
              style: GoogleFonts.cabin(
                  fontSize: 14, color: c.textSecondary, height: 1.4),
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
                    ? (crag.isGym ? c.accentBlue : c.oliveGreen)
                        .withAlpha(20)
                    : c.chipBg,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: isHome
                      ? (crag.isGym
                          ? c.accentBlue
                          : c.oliveGreen)
                      : c.darkGrey,
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
                            ? c.accentBlue
                            : c.oliveGreen)
                        : c.textSecondary,
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
                              ? c.accentBlue
                              : c.oliveGreen)
                          : c.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: c.darkGrey,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: c.borderColor, width: 1.5),
                    ),
                    child: Text(
                      '$memberCount ${memberCount == 1 ? 'MEMBER' : 'MEMBERS'}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(Icons.chevron_right,
                      size: 16, color: c.textSecondary),
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
          Divider(color: c.borderColor, thickness: 1),
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

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMMUNITY VIBE',
            style: GoogleFonts.spaceMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: vibeTags.map((vt) {
              final tag = ClimbingTags.getById(vt.tagId);
              if (tag == null) return const SizedBox.shrink();
              final rotation = ClimbingTags.rotationFor(vt.tagId);
              return Transform.rotate(
                angle: rotation * 3.14159 / 180,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tag.color.withAlpha(30),
                    border: Border.all(color: tag.color, width: 2),
                  ),
                  child: Text(
                    vt.count > 1
                        ? '${tag.label} ×${vt.count}'
                        : tag.label,
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: tag.color,
                    ),
                  ),
                ),
              );
            }).toList(),
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
    final c = context.appColors;

    // Sort by newest first, take a mixed preview
    final sorted = [...posts]
      ..sort((a, b) => (b.createdAt ?? DateTime(2000))
          .compareTo(a.createdAt ?? DateTime(2000)));
    final preview = sorted.take(3).toList();

    // Count by type
    final introCount = posts.where((p) => p.type == PostType.introduction).length;
    final partnerCount = posts.where((p) => p.type == PostType.partnerRequest).length;
    final lfCount = posts.where((p) => p.type == PostType.lostFound).length;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: c.borderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
              color: c.shadowColor, offset: const Offset(5, 5), blurRadius: 0)
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
            decoration: BoxDecoration(
              color: c.dullOrange,
              border: Border(
                  bottom: BorderSide(color: c.borderColor, width: 2)),
            ),
            child: Row(
              children: [
                Icon(Icons.forum_outlined, size: 16, color: c.textOnPrimary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'COMMUNITY BOARD',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textOnPrimary,
                  ),
                ),
                const Spacer(),
                CountBadge(
                  label: '${posts.length} POSTS',
                  color: c.surface,
                  textColor: c.textPrimary,
                ),
              ],
            ),
          ),

          // Type summary row
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.chipBg,
              border: Border(
                  bottom: BorderSide(color: c.darkGrey, width: 1)),
            ),
            child: Row(
              children: [
                if (introCount > 0) ...[
                  _TypeBadge(label: '$introCount INTROS', color: c.accentBlue),
                  const SizedBox(width: 6),
                ],
                if (partnerCount > 0) ...[
                  _TypeBadge(label: '$partnerCount PARTNER', color: c.dullOrange),
                  const SizedBox(width: 6),
                ],
                if (lfCount > 0)
                  _TypeBadge(label: '$lfCount LOST/FOUND', color: c.amber,
                      textColor: c.textOnTertiary),
              ],
            ),
          ),

          // Heatmap strip
          HeatmapStrip(
            countsByDate: countsByDate,
            onTap: () => context.push('/crag/${crag.id}/community'),
          ),

          Divider(height: 1, thickness: 1, color: c.borderColor),

          // Post previews
          if (preview.isEmpty)
            _emptyPanelRow(context, 'NO POSTS YET', Icons.forum_outlined)
          else
            ...preview.map((post) => _CommunityPreviewRow(
                  post: post,
                  onTap: () => _showPostDetail(context, ref, post),
                )),

          // Footer — go to full community board
          PanelFooter(
            label: posts.isEmpty
                ? 'START THE CONVERSATION'
                : 'VIEW FULL COMMUNITY BOARD →',
            onTap: () => context.push('/crag/${crag.id}/community'),
          ),
        ],
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFab(BuildContext context, Crag crag) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
              color: c.shadowColor, offset: const Offset(4, 4), blurRadius: 0)
        ],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'create_post_fab',
        backgroundColor: c.dullOrange,
        foregroundColor: c.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
          side: BorderSide(color: c.borderColor, width: 2.5),
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
      builder: (_) => PostTypeSheet(crag: crag),
    );
  }

  // ── Post detail ────────────────────────────────────────────────────────────

  void _showPostDetail(BuildContext context, WidgetRef ref, ClimbingPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => PostDetailSheet(post: post),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _emptyPanelRow(BuildContext context, String message, IconData icon) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: c.textDisabled),
          const SizedBox(width: AppSpacing.sm),
          Text(
            message,
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: c.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets for community preview ────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const _TypeBadge({required this.label, required this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor ?? color,
        ),
      ),
    );
  }
}

class _CommunityPreviewRow extends ConsumerWidget {
  final ClimbingPost post;
  final VoidCallback onTap;
  const _CommunityPreviewRow({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(userByIdProvider(post.userId));

    final typeColor = switch (post.type) {
      PostType.introduction => c.accentBlue,
      PostType.partnerRequest => c.dullOrange,
      PostType.lostFound => c.amber,
    };
    final typeIcon = switch (post.type) {
      PostType.introduction => Icons.person_add,
      PostType.partnerRequest => Icons.group,
      PostType.lostFound =>
        post.lostFoundStatus == LostFoundStatus.lost
            ? Icons.search
            : Icons.inventory_2,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: c.darkGrey, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              color: typeColor,
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(typeIcon, size: 16, color: typeColor),
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
                      color: c.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  userAsync.when(
                    data: (user) => Text(
                      user?.displayName ?? 'Unknown',
                      style: GoogleFonts.spaceMono(
                          fontSize: 10, color: c.textSecondary),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
