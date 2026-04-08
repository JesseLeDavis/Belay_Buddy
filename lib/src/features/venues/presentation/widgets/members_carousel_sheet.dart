import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MembersCarouselSheet extends ConsumerStatefulWidget {
  final String cragId;
  final Crag crag;
  const MembersCarouselSheet({super.key, required this.cragId, required this.crag});

  @override
  ConsumerState<MembersCarouselSheet> createState() =>
      _MembersCarouselSheetState();
}

class _MembersCarouselSheetState extends ConsumerState<MembersCarouselSheet> {
  late final ScrollController _scrollCtrl;
  static const _slotWidth = 110.0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
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
    final edgeInset = (screenWidth - _slotWidth) / 2;

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
          SizedBox(
            height: 160,
            child: ListView.builder(
              controller: _scrollCtrl,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: edgeInset),
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final user = visible[i];
                final scale = _scaleFor(i, screenWidth, edgeInset);
                final opacity = (0.4 + 0.6 * scale).clamp(0.0, 1.0);
                final color =
                    _avatarColors[user.uid.hashCode % _avatarColors.length];

                final t = ((scale - 0.6) / 0.4).clamp(0.0, 1.0);
                final avatarSize = 48.0 + 32.0 * t;
                final fontSize = 16.0 + 14.0 * t;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/profile/${user.uid}');
                  },
                  child: SizedBox(
                    width: _slotWidth,
                    child: Opacity(
                      opacity: opacity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 80),
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                  color: AppColors.darkNavy, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withAlpha(
                                      (120 * scale).round().clamp(0, 255)),
                                  offset: Offset(4 * scale, 4 * scale),
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
                                  fontSize: fontSize,
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
                              fontSize: scale > 0.85 ? 12 : 10,
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
                                color: scale > 0.85
                                    ? AppColors.textSecondary
                                    : AppColors.textDisabled,
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

  double _scaleFor(int index, double screenWidth, double edgeInset) {
    if (!_scrollCtrl.hasClients) {
      return index == 0 ? 1.0 : (1.0 - index * 0.15).clamp(0.6, 1.0);
    }
    final scrollOffset = _scrollCtrl.offset;
    final itemCenter = edgeInset + index * _slotWidth + _slotWidth / 2;
    final viewCenter = scrollOffset + screenWidth / 2;
    final dist = (itemCenter - viewCenter).abs();
    final normalized = (dist / _slotWidth).clamp(0.0, 2.0);
    return 1.0 - (normalized * 0.2);
  }

  String _firstTagLabel(String tagId) {
    final tag = ClimbingTags.getById(tagId);
    return tag?.label ?? tagId.toUpperCase();
  }
}
