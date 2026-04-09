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
  const MembersPreviewRow({super.key, required this.cragId, required this.crag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final avatarColors = [c.dullOrange, c.accentBlue, c.oliveGreen, c.amber];
    final visible = ref.watch(visibleHomeMembersProvider(cragId));
    final memberCount = ref.watch(homeMemberCountProvider(cragId));

    if (memberCount == 0) return const SizedBox.shrink();

    final preview = List<AppUser>.from(visible)..shuffle();
    final shown = preview.take(4).toList();
    final extra = memberCount - shown.length;

    return GestureDetector(
      onTap: () => _showMembersCarousel(context, cragId, crag),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
        decoration: BoxDecoration(
          color: c.chipBg,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: c.darkGrey, width: 2),
        ),
        child: Row(
          children: [
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
                          color: avatarColors[
                              shown[i].uid.hashCode % avatarColors.length],
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: c.surface, width: 2.5),
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
                  color: c.borderColor,
                ),
              ),
            ),
            if (extra > 0)
              Text(
                '+$extra more',
                style: GoogleFonts.cabin(
                    fontSize: 12, color: c.textSecondary),
              ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'SEE ALL',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: c.accentBlue,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.chevron_right,
                size: 14, color: c.accentBlue),
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
