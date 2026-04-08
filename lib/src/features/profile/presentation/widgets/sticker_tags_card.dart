import 'package:belay_buddy/src/common/utils/climbing_tags.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StickerTagsCard extends StatelessWidget {
  final List<String> tags;
  const StickerTagsCard({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: const [
          BoxShadow(
            color: AppColors.darkNavy,
            offset: Offset(4, 4),
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
                horizontal: AppSpacing.sm + 4, vertical: 10),
            color: AppColors.oliveGreen,
            child: Text(
              'VIBE CHECK',
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
                      horizontal: AppSpacing.sm + 4,
                      vertical: AppSpacing.xs + 3,
                    ),
                    decoration: BoxDecoration(
                      color: tag.color,
                      border: Border.all(color: AppColors.darkNavy, width: 2),
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
                        color: Colors.white,
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
