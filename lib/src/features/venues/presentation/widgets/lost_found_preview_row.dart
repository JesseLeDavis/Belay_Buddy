import 'package:belay_buddy/src/features/lost_found/domain/lost_found_item.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LostFoundPreviewRow extends StatelessWidget {
  final LostFoundItem item;
  const LostFoundPreviewRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isFound = item.status == LostFoundStatus.found;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.darkGrey, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isFound ? c.oliveGreen : c.dullOrange,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: c.borderColor, width: 1.5),
            ),
            child: Text(
              isFound ? 'FOUND' : 'LOST',
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: c.textOnPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: GoogleFonts.cabin(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  _categoryName(item.category),
                  style: GoogleFonts.spaceMono(
                      fontSize: 10, color: c.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            _timeAgo(item.createdAt),
            style: GoogleFonts.spaceMono(
                fontSize: 10, color: c.textDisabled),
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

  String _categoryName(LostFoundCategory cat) {
    switch (cat) {
      case LostFoundCategory.gear:
        return 'Gear';
      case LostFoundCategory.clothing:
        return 'Clothing';
      case LostFoundCategory.personalItem:
        return 'Personal Item';
      case LostFoundCategory.rope:
        return 'Rope';
      case LostFoundCategory.other:
        return 'Other';
    }
  }
}
