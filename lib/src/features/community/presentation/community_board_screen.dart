import 'package:belay_buddy/src/features/auth/data/auth_repository.dart';
import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/connections/data/connections_repository.dart';
import 'package:belay_buddy/src/features/posts/data/posts_repository.dart';
import 'package:belay_buddy/src/features/posts/domain/climbing_post.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CommunityBoardScreen extends ConsumerWidget {
  final String cragId;
  const CommunityBoardScreen({super.key, required this.cragId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final cragAsync = ref.watch(cragProvider(cragId));
    final posts = ref.watch(filteredPostsAtCragProvider(cragId));
    final filter = ref.watch(communityFilterProvider);
    final typeCounts = ref.watch(postTypeCountsProvider(cragId));

    final cragName = cragAsync.valueOrNull?.name ?? 'Community';

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.dullOrange,
        title: Text(
          '$cragName BOARD',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: c.textOnPrimary,
          ),
        ),
        iconTheme: IconThemeData(color: c.textOnPrimary),
        shape: Border(
          bottom: BorderSide(color: c.borderColor, width: 3),
        ),
      ),
      body: Column(
        children: [
          // Filter tabs
          _FilterBar(
            selected: filter,
            typeCounts: typeCounts,
            onChanged: (type) =>
                ref.read(communityFilterProvider.notifier).state = type,
          ),

          // Post list
          Expanded(
            child: posts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.forum_outlined, size: 48, color: c.textDisabled),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'NO POSTS YET',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.sm, AppSpacing.md, 100),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _CommunityPostCard(post: post),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: cragAsync.when(
        data: (crag) {
          if (crag == null) return null;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: [
                BoxShadow(
                    color: c.shadowColor,
                    offset: const Offset(4, 4),
                    blurRadius: 0),
              ],
            ),
            child: FloatingActionButton.extended(
              heroTag: 'community_post_fab',
              backgroundColor: c.dullOrange,
              foregroundColor: c.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(Radius.circular(AppRadius.sm)),
                side: BorderSide(color: c.borderColor, width: 2.5),
              ),
              onPressed: () => context.push(
                '/crag/${crag.id}/post',
                extra: {
                  'crag': crag,
                  'postType': switch (filter) {
                    PostType.introduction => 'introduction',
                    PostType.lostFound => 'lostFound',
                    PostType.partnerRequest => 'partnerRequest',
                    null => 'partnerRequest',
                  },
                },
              ),
              icon: const Icon(Icons.add),
              label: Text(
                'POST',
                style: GoogleFonts.spaceMono(
                    fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}

// ── Filter bar ──────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final PostType? selected;
  final Map<PostType, int> typeCounts;
  final ValueChanged<PostType?> onChanged;

  const _FilterBar({
    required this.selected,
    required this.typeCounts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final total = typeCounts.values.fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.borderColor, width: 2)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'ALL',
              count: total,
              color: c.dullOrange,
              isSelected: selected == null,
              onTap: () => onChanged(null),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'MEET',
              count: typeCounts[PostType.introduction] ?? 0,
              color: c.accentBlue,
              isSelected: selected == PostType.introduction,
              onTap: () => onChanged(PostType.introduction),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'PARTNER',
              count: typeCounts[PostType.partnerRequest] ?? 0,
              color: c.dullOrange,
              isSelected: selected == PostType.partnerRequest,
              onTap: () => onChanged(PostType.partnerRequest),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterChip(
              label: 'LOST & FOUND',
              count: typeCounts[PostType.lostFound] ?? 0,
              color: c.amber,
              isSelected: selected == PostType.lostFound,
              onTap: () => onChanged(PostType.lostFound),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : c.surface,
          border: Border.all(
            color: c.borderColor,
            width: isSelected ? 2.5 : 2,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(3, 3),
                      blurRadius: 0),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? (color == c.amber ? c.textOnTertiary : c.textOnPrimary)
                    : c.textPrimary,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? c.surface.withAlpha(60)
                      : c.borderColor,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.spaceMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? (color == c.amber
                            ? c.textOnTertiary
                            : c.textOnPrimary)
                        : c.background,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Post card ───────────────────────────────────────────────────────────────

class _CommunityPostCard extends ConsumerWidget {
  final ClimbingPost post;
  const _CommunityPostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (post.type) {
      case PostType.introduction:
        return _IntroductionCard(post: post);
      case PostType.partnerRequest:
        return _PartnerRequestCard(post: post);
      case PostType.lostFound:
        return _LostFoundCard(post: post);
    }
  }
}

// ── Introduction card ───────────────────────────────────────────────────────

class _IntroductionCard extends ConsumerWidget {
  final ClimbingPost post;
  const _IntroductionCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(userByIdProvider(post.userId));
    final currentUserId = ref.watch(currentUserIdSyncProvider);
    final isOwnPost = post.userId == currentUserId;
    final isConnected = ref.watch(isConnectedProvider(post.userId));

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
              color: c.shadowColor,
              offset: const Offset(5, 5),
              blurRadius: 0),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 10),
            color: c.accentBlue,
            child: Row(
              children: [
                Icon(Icons.person_add, size: 14, color: c.textOnPrimary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'MEET · INTRODUCTION',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: c.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User row
                userAsync.when(
                  data: (user) => _UserRow(user: user, post: post),
                  loading: () => const SizedBox(height: 40),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title
                Text(
                  post.title,
                  style: GoogleFonts.cabin(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),

                // Description
                if (post.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    post.description!,
                    style: GoogleFonts.cabin(
                        fontSize: 14, color: c.textSecondary, height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Climbing level + goals
                if (post.climbingLevel != null ||
                    post.climbingGoals.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (post.climbingLevel != null)
                        _TagChip(
                            label: post.climbingLevel!, color: c.accentBlue),
                      ...post.climbingGoals
                          .map((g) => _TagChip(label: g, color: c.oliveGreen)),
                    ],
                  ),
                ],

                // Action button
                if (!isOwnPost) ...[
                  const SizedBox(height: AppSpacing.md),
                  _ConnectButton(
                    userId: post.userId,
                    isConnected: isConnected,
                    userName: userAsync.valueOrNull?.displayName ?? 'Climber',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Partner request card ────────────────────────────────────────────────────

class _PartnerRequestCard extends ConsumerWidget {
  final ClimbingPost post;
  const _PartnerRequestCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(userByIdProvider(post.userId));
    final currentUserId = ref.watch(currentUserIdSyncProvider);
    final isOwnPost = post.userId == currentUserId;
    final isInterested = ref.watch(userInterestedInProvider(post.id));
    final isExpired = post.isExpired ||
        (post.expiresAt != null && post.expiresAt!.isBefore(DateTime.now()));

    return Opacity(
      opacity: isExpired ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.borderColor, width: 2.5),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isExpired
              ? []
              : [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(5, 5),
                      blurRadius: 0),
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 10),
              color: c.dullOrange,
              child: Row(
                children: [
                  Icon(Icons.group, size: 14, color: c.textOnPrimary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'PARTNER · ${_partnerNeedLabel(post.partnerNeedType).toUpperCase()}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.textOnPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (isExpired)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: c.error,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        'EXPIRED',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: c.textOnPrimary,
                        ),
                      ),
                    )
                  else if (post.respondentIds.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: c.surface.withAlpha(60),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        '${post.respondentIds.length} INTERESTED',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: c.textOnPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date badge + title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DateBadge(dateTime: post.dateTime),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: GoogleFonts.cabin(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: c.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            userAsync.when(
                              data: (user) => GestureDetector(
                                onTap: user != null
                                    ? () =>
                                        context.push('/profile/${user.uid}')
                                    : null,
                                child: Text(
                                  user?.displayName ?? 'Unknown',
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 10,
                                    color: c.accentBlue,
                                  ),
                                ),
                              ),
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (post.description != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      post.description!,
                      style: GoogleFonts.cabin(
                          fontSize: 14, color: c.textSecondary, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Tags
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (post.gradeRange != null)
                        _TagChip(label: post.gradeRange!, color: c.dullOrange),
                      if (post.needsBelay)
                        _TagChip(label: 'NEED BELAY', color: c.accentBlue),
                      if (post.offeringBelay)
                        _TagChip(label: 'CAN BELAY', color: c.oliveGreen),
                    ],
                  ),

                  // Action
                  if (!isOwnPost && !isExpired) ...[
                    const SizedBox(height: AppSpacing.md),
                    _InterestButton(
                      postId: post.id,
                      isInterested: isInterested,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _partnerNeedLabel(PartnerNeedType type) {
    switch (type) {
      case PartnerNeedType.belay:
        return 'Belay';
      case PartnerNeedType.ropedPartner:
        return 'Roped';
      case PartnerNeedType.boulderingBuddy:
        return 'Boulder';
    }
  }
}

// ── Lost & Found card ───────────────────────────────────────────────────────

class _LostFoundCard extends ConsumerWidget {
  final ClimbingPost post;
  const _LostFoundCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final userAsync = ref.watch(userByIdProvider(post.userId));
    final currentUserId = ref.watch(currentUserIdSyncProvider);
    final isOwnPost = post.userId == currentUserId;
    final isLost = post.lostFoundStatus == LostFoundStatus.lost;

    return Opacity(
      opacity: post.isResolved ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.borderColor, width: 2.5),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: post.isResolved
              ? []
              : [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(5, 5),
                      blurRadius: 0),
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 10),
              color: c.amber,
              child: Row(
                children: [
                  Icon(
                    isLost ? Icons.search : Icons.inventory_2,
                    size: 14,
                    color: c.textOnTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${isLost ? 'LOST' : 'FOUND'} · ${_categoryLabel(post.lostFoundCategory)}',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.textOnTertiary,
                    ),
                  ),
                  const Spacer(),
                  if (post.isResolved)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: c.oliveGreen,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        'RESOLVED',
                        style: GoogleFonts.spaceMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: c.textOnPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge + item name
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLost ? c.dullOrange : c.oliveGreen,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                          border:
                              Border.all(color: c.borderColor, width: 1.5),
                        ),
                        child: Text(
                          isLost ? 'LOST' : 'FOUND',
                          style: GoogleFonts.spaceMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: c.textOnPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          post.itemName ?? post.title,
                          style: GoogleFonts.cabin(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (post.description != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      post.description!,
                      style: GoogleFonts.cabin(
                          fontSize: 14, color: c.textSecondary, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Location
                  if (post.locationNote != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: c.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          post.locationNote!,
                          style: GoogleFonts.spaceMono(
                              fontSize: 11, color: c.textSecondary),
                        ),
                      ],
                    ),
                  ],

                  // Posted by + time
                  const SizedBox(height: AppSpacing.sm),
                  userAsync.when(
                    data: (user) => Row(
                      children: [
                        Text(
                          'Posted by ${user?.displayName ?? 'Unknown'}',
                          style: GoogleFonts.spaceMono(
                              fontSize: 10, color: c.textDisabled),
                        ),
                        const Spacer(),
                        Text(
                          _timeAgo(post.createdAt),
                          style: GoogleFonts.spaceMono(
                              fontSize: 10, color: c.textDisabled),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  // Action
                  if (!isOwnPost && !post.isResolved) ...[
                    const SizedBox(height: AppSpacing.md),
                    _LostFoundActionButton(post: post),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(LostFoundCategory? cat) {
    if (cat == null) return 'ITEM';
    switch (cat) {
      case LostFoundCategory.gear:
        return 'GEAR';
      case LostFoundCategory.clothing:
        return 'CLOTHING';
      case LostFoundCategory.personalItem:
        return 'PERSONAL';
      case LostFoundCategory.rope:
        return 'ROPE';
      case LostFoundCategory.other:
        return 'OTHER';
    }
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _UserRow extends StatelessWidget {
  final AppUser? user;
  final ClimbingPost post;
  const _UserRow({required this.user, required this.post});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: user != null ? () => context.push('/profile/${user!.uid}') : null,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.accentBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user?.displayName.isNotEmpty == true
                    ? user!.displayName[0].toUpperCase()
                    : '?',
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.textOnPrimary,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                if (user?.experienceLevel != null)
                  Text(
                    user!.experienceLevel.name.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      color: c.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            _timeAgo(post.createdAt),
            style:
                GoogleFonts.spaceMono(fontSize: 10, color: c.textDisabled),
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
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  final DateTime dateTime;
  const _DateBadge({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final now = DateTime.now();
    final diff = dateTime.difference(now);
    final isNow = diff.inMinutes <= 0;

    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isNow ? c.dullOrange : c.chipBg,
        border: Border.all(color: c.borderColor, width: 2),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Column(
        children: [
          Text(
            isNow ? 'NOW' : DateFormat('MMM').format(dateTime).toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: isNow ? c.textOnPrimary : c.textSecondary,
            ),
          ),
          if (!isNow)
            Text(
              DateFormat('d').format(dateTime),
              style: GoogleFonts.spaceMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Interaction buttons ─────────────────────────────────────────────────────

class _ConnectButton extends ConsumerStatefulWidget {
  final String userId;
  final bool isConnected;
  final String userName;

  const _ConnectButton({
    required this.userId,
    required this.isConnected,
    required this.userName,
  });

  @override
  ConsumerState<_ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends ConsumerState<_ConnectButton> {
  bool _requestSent = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    if (widget.isConnected) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: c.oliveGreen,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, size: 16, color: c.textOnPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'CONNECTED',
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.textOnPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _requestSent
          ? null
          : () {
              setState(() => _requestSent = true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Connection request sent to ${widget.userName}',
                  style: GoogleFonts.cabin(
                      color: c.textOnPrimary, fontSize: 14),
                ),
                backgroundColor: c.accentBlue,
              ));
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _requestSent ? c.chipBg : c.accentBlue,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
          boxShadow: _requestSent
              ? []
              : [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(3, 3),
                      blurRadius: 0),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _requestSent ? Icons.hourglass_empty : Icons.person_add,
              size: 16,
              color: _requestSent ? c.textSecondary : c.textOnPrimary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              _requestSent ? 'REQUEST SENT' : 'CONNECT',
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _requestSent ? c.textSecondary : c.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestButton extends ConsumerStatefulWidget {
  final String postId;
  final bool isInterested;

  const _InterestButton({
    required this.postId,
    required this.isInterested,
  });

  @override
  ConsumerState<_InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends ConsumerState<_InterestButton> {
  late bool _interested;

  @override
  void initState() {
    super.initState();
    _interested = widget.isInterested;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return GestureDetector(
      onTap: _interested
          ? null
          : () {
              setState(() => _interested = true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Interest sent! The poster will be notified.',
                  style: GoogleFonts.cabin(
                      color: c.textOnPrimary, fontSize: 14),
                ),
                backgroundColor: c.oliveGreen,
              ));
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _interested ? c.chipBg : c.dullOrange,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
          boxShadow: _interested
              ? []
              : [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(3, 3),
                      blurRadius: 0),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _interested ? Icons.check : Icons.emoji_people,
              size: 16,
              color: _interested ? c.textSecondary : c.textOnPrimary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              _interested ? 'INTEREST SENT' : "I'M INTERESTED",
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _interested ? c.textSecondary : c.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LostFoundActionButton extends StatefulWidget {
  final ClimbingPost post;
  const _LostFoundActionButton({required this.post});

  @override
  State<_LostFoundActionButton> createState() => _LostFoundActionButtonState();
}

class _LostFoundActionButtonState extends State<_LostFoundActionButton> {
  bool _claimed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isLost = widget.post.lostFoundStatus == LostFoundStatus.lost;

    return GestureDetector(
      onTap: _claimed
          ? null
          : () {
              setState(() => _claimed = true);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  isLost
                      ? 'You\'ll be connected with the poster!'
                      : 'Claim sent! The finder will be notified.',
                  style: GoogleFonts.cabin(
                      color: c.textOnPrimary, fontSize: 14),
                ),
                backgroundColor: c.amber,
              ));
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _claimed ? c.chipBg : c.amber,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.borderColor, width: 2),
          boxShadow: _claimed
              ? []
              : [
                  BoxShadow(
                      color: c.shadowColor,
                      offset: const Offset(3, 3),
                      blurRadius: 0),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _claimed
                  ? Icons.check
                  : (isLost ? Icons.visibility : Icons.back_hand),
              size: 16,
              color: _claimed ? c.textSecondary : c.textOnTertiary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              _claimed
                  ? 'CONTACTED'
                  : (isLost ? 'I FOUND THIS' : 'THIS IS MINE'),
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _claimed ? c.textSecondary : c.textOnTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
