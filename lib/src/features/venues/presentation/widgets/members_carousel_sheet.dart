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
  const MembersCarouselSheet({
    super.key,
    required this.cragId,
    required this.crag,
  });

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

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final visible = ref.watch(visibleHomeMembersProvider(widget.cragId));
    final memberCount = ref.watch(homeMemberCountProvider(widget.cragId));
    final hiddenCount = memberCount - visible.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final edgeInset = (screenWidth - _slotWidth) / 2;

    return Container(
      decoration: BoxDecoration(
        color: c.canvas,
        border: Border(
          top: BorderSide(color: c.borderColor, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
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
              child: Row(
                children: [
                  Text(
                    'Locals',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$memberCount',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      color: c.textDisabled,
                      letterSpacing: -0.1,
                    ),
                  ),
                  if (hiddenCount > 0) ...[
                    const Spacer(),
                    Text(
                      '$hiddenCount private',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: c.textDisabled,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 150,
              child: ListView.builder(
                controller: _scrollCtrl,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: edgeInset),
                itemCount: visible.length,
                itemBuilder: (context, i) {
                  final user = visible[i];
                  final scale = _scaleFor(i, screenWidth, edgeInset);
                  final opacity = (0.45 + 0.55 * scale).clamp(0.0, 1.0);
                  final t = ((scale - 0.6) / 0.4).clamp(0.0, 1.0);
                  final avatarSize = 48.0 + 28.0 * t;
                  final fontSize = 18.0 + 12.0 * t;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
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
                                color: c.canvas,
                                shape: BoxShape.circle,
                                border: Border.all(color: c.ink, width: 1.5),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                user.displayName.isNotEmpty
                                    ? user.displayName[0].toLowerCase()
                                    : '?',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w500,
                                  color: c.ink,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user.displayName.split(' ').first,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: scale > 0.85 ? 13 : 12,
                                fontWeight: FontWeight.w600,
                                color: c.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (user.climbingTags.isNotEmpty)
                              Text(
                                _firstTagLabel(user.climbingTags.first)
                                    .toLowerCase(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: scale > 0.85
                                      ? c.textSecondary
                                      : c.textDisabled,
                                  letterSpacing: -0.1,
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
            const SizedBox(height: 18),
          ],
        ),
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
    return tag?.label ?? tagId;
  }
}
