import 'package:belay_buddy/src/features/lost_found/domain/lost_found_item.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LostFoundPreviewRow extends StatelessWidget {
  final LostFoundItem item;
  const LostFoundPreviewRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isFound = item.status == LostFoundStatus.found;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.darkGrey, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isFound ? AppColors.oliveGreen : AppColors.dullOrange,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.darkNavy, width: 1.5),
            ),
            child: Text(
              isFound ? 'FOUND' : 'LOST',
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
                    color: AppColors.darkNavy,
                  ),
                ),
                Text(
                  _categoryName(item.category),
                  style: GoogleFonts.spaceMono(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            _timeAgo(item.createdAt),
            style: GoogleFonts.spaceMono(
                fontSize: 10, color: AppColors.textDisabled),
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
