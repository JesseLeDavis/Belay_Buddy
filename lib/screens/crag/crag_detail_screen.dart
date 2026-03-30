import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/models/crag.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:belay_buddy/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CragDetailScreen extends ConsumerWidget {
  final String cragId;

  const CragDetailScreen({
    super.key,
    required this.cragId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cragAsync = ref.watch(cragProvider(cragId));
    final postsAsync = ref.watch(postsAtCragProvider(cragId));

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
          return _buildCragDetail(context, ref, crag, postsAsync);
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
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.cabin(fontSize: 16, color: AppColors.error),
          ),
        ),
      ),
      floatingActionButton: cragAsync.when(
        data: (crag) {
          if (crag == null) return null;
          return Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkNavy,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              heroTag: 'create_post_fab',
              backgroundColor: AppColors.dullOrange,
              foregroundColor: Colors.white,
              onPressed: () {
                context.push('/crag/$cragId/post', extra: crag);
              },
              icon: const Icon(Icons.edit),
              label: Text(
                'POST',
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  Widget _buildCragDetail(
    BuildContext context,
    WidgetRef ref,
    Crag crag,
    AsyncValue<List<ClimbingPost>> postsAsync,
  ) {
    return CustomScrollView(
      slivers: [
        // App bar — bold green header
        SliverAppBar(
          expandedHeight: 140,
          pinned: true,
          backgroundColor: AppColors.oliveGreen,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          shape: const Border(
            bottom: BorderSide(color: AppColors.darkNavy, width: 3),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              crag.name,
              style: GoogleFonts.spaceMono(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            background: Container(
              color: AppColors.oliveGreen,
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                bottom: 50,
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                '${crag.region ?? 'Unknown region'} / ${crag.types.map((t) => t.name.toUpperCase()).join(', ')}',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  color: Colors.white.withAlpha(204),
                ),
              ),
            ),
          ),
        ),

        // Crag info section
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.background,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Region + type chips
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      crag.region ?? 'Unknown region',
                      style: GoogleFonts.spaceMono(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    ...crag.types.map(
                      (type) => Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.xs),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.darkNavy, width: 2),
                          ),
                          child: Text(
                            type.name.toUpperCase(),
                            style: GoogleFonts.spaceMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkNavy,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (crag.description != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    crag.description!,
                    style: GoogleFonts.cabin(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                const Divider(color: AppColors.darkNavy, thickness: 1),
              ],
            ),
          ),
        ),

        // Community Board header — bold color block
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 4,
            ),
            decoration: const BoxDecoration(
              color: AppColors.amber,
              border: Border(
                top: BorderSide(color: AppColors.darkNavy, width: 3),
                bottom: BorderSide(color: AppColors.darkNavy, width: 3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'COMMUNITY BOARD',
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavy,
                  ),
                ),
                const Spacer(),
                postsAsync.when(
                  data: (posts) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.darkNavy, width: 2),
                      color: AppColors.surface,
                    ),
                    child: Text(
                      '${posts.length} POSTS',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavy,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
        ),

        // Posts list
        postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.note_add_outlined,
                        size: 64,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'NO POSTS YET',
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDisabled,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Be the first to post!',
                        style: GoogleFonts.cabin(
                          fontSize: 14,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: 100,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      onTap: () => _showPostDetail(context, ref, post),
                    );
                  },
                  childCount: posts.length,
                ),
              ),
            );
          },
          loading: () => SliverFillRemaining(
            child: Center(
              child: Text(
                'LOADING POSTS...',
                style: GoogleFonts.spaceMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          error: (error, stack) => SliverFillRemaining(
            child: Center(
              child: Text(
                'Error: $error',
                style: GoogleFonts.cabin(fontSize: 16, color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPostDetail(
      BuildContext context, WidgetRef ref, ClimbingPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) => PostDetailSheet(post: post),
    );
  }
}

// ============================================================
// Post detail bottom sheet
// ============================================================

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
            border: Border(
              top: BorderSide(color: AppColors.darkNavy, width: 3),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.sm,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      color: AppColors.darkNavy.withAlpha(80),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Type badge + title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: post.type == PostType.immediate
                              ? AppColors.dullOrange
                              : AppColors.oliveGreen,
                          border: Border.all(
                              color: AppColors.darkNavy, width: 2),
                        ),
                        child: Text(
                          post.type == PostType.immediate
                              ? '\u25CF NOW'
                              : '\u25C6 SCHEDULED',
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
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Date/time
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 16, color: AppColors.amber),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _formatFullDateTime(post.dateTime),
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Belay chips
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

                  // Author
                  userAsync.when(
                    data: (user) => Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.darkNavy,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.darkNavy, width: 2),
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
                                  '${_experienceName(user.experienceLevel)} / ${user.climbingStyles.map((s) => _styleName(s)).join(', ')}',
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    loading: () => Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.darkNavy,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.darkNavy, width: 2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Loading...',
                            style: GoogleFonts.spaceMono(
                              fontSize: 12,
                              color: AppColors.textDisabled,
                            )),
                      ],
                    ),
                    error: (_, __) => Text(
                      'Unknown Climber',
                      style: GoogleFonts.cabin(
                          fontSize: 16, color: AppColors.textDisabled),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Message button
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.darkNavy,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: AppColors.darkNavy, width: 2.5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Message sent to ${userAsync.asData?.value?.displayName ?? 'climber'}',
                            style: GoogleFonts.cabin(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(
                      'MESSAGE ${(userAsync.asData?.value?.displayName ?? 'CLIMBER').toUpperCase()}',
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
        border: Border.all(color: AppColors.darkNavy, width: 2),
        color: color,
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatFullDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.isNegative) {
      final futureDiff = dt.difference(now);
      if (futureDiff.inMinutes < 60) return 'in ${futureDiff.inMinutes}m';
      if (futureDiff.inHours < 24) return 'in ${futureDiff.inHours}h';
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dt);
    } else {
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return DateFormat('EEE, MMM d \'at\' h:mm a').format(dt);
    }
  }

  String _experienceName(dynamic level) {
    const names = {
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'expert': 'Expert',
    };
    return names[level.toString().split('.').last] ?? level.toString();
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
