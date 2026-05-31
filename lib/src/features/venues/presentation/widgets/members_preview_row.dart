import 'package:belay_buddy/src/features/auth/domain/app_user.dart';
import 'package:belay_buddy/src/features/venues/domain/crag.dart';
import 'package:belay_buddy/src/features/home_settings/data/home_settings_repository.dart';
import 'package:belay_buddy/src/features/venues/presentation/widgets/members_carousel_sheet.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MembersPreviewRow extends ConsumerWidget {
  final String cragId;
  final Crag crag;
  const MembersPreviewRow({
    super.key,
    required this.cragId,
    required this.crag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final visible = ref.watch(visibleHomeMembersProvider(cragId));
    final memberCount = ref.watch(homeMemberCountProvider(cragId));

    if (memberCount == 0) return const SizedBox.shrink();

    final preview = List<AppUser>.from(visible)..shuffle();
    final shown = preview.take(4).toList();
    final extra = memberCount - shown.length;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showMembersCarousel(context, cragId, crag),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: shown.length * 22.0 + 10,
              height: 30,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < shown.length; i++)
                    Positioned(
                      left: i * 20.0,
                      child: _AvatarDot(
                        initial: shown[i].displayName.isNotEmpty
                            ? shown[i].displayName[0].toLowerCase()
                            : '?',
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: c.ink,
                  ),
                  children: [
                    TextSpan(
                      text: '$memberCount',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${memberCount == 1 ? 'member' : 'members'}${extra > 0 ? ' · +$extra more' : ''}',
                      style: TextStyle(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'see all  →',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.ink,
              ),
            ),
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
      builder: (_) => MembersCarouselSheet(cragId: cragId, crag: crag),
    );
  }
}

class _AvatarDot extends StatelessWidget {
  final String initial;
  const _AvatarDot({required this.initial});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: c.canvas,
        shape: BoxShape.circle,
        border: Border.all(color: c.ink, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: c.ink,
        ),
      ),
    );
  }
}
