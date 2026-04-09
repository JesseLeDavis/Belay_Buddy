import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StickerTagsCard extends StatelessWidget {
  final List<String> tags;
  const StickerTagsCard({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
            color: c.shadowColor,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd, vertical: 10),
            color: c.oliveGreen,
            child: Text(
              'VIBE CHECK',
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.textOnPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm + 2,
              children: tags.map((tagId) {
                final tag = ClimbingTags.getById(tagId);
                if (tag == null) return const SizedBox.shrink();
                final rotation = ClimbingTags.rotationFor(tagId);
                return Transform.rotate(
                  angle: rotation * 3.14159 / 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.smMd,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: tag.color,
                      border: Border.all(color: c.borderColor, width: 2),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      boxShadow: [
                        BoxShadow(
                          color: tag.color.withAlpha(80),
                          offset: const Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      tag.label,
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: tag.color.computeLuminance() > 0.4
                            ? c.textPrimary
                            : c.textOnPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
