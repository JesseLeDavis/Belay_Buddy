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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vibes',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tags.map((tagId) {
            final tag = ClimbingTags.getById(tagId);
            if (tag == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: c.canvas,
                border: Border.all(color: c.ink, width: 1.5),
              ),
              child: Text(
                tag.label.toLowerCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: c.ink,
                  letterSpacing: -0.1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
