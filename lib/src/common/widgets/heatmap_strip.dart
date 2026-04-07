import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeatmapStrip extends StatelessWidget {
  final Map<DateTime, int> countsByDate;
  final VoidCallback? onTap;

  const HeatmapStrip({super.key, required this.countsByDate, this.onTap});

  Color _dotColor(int count) {
    if (count == 0) return AppColors.darkGrey;
    if (count <= 2) return AppColors.sageLight;
    if (count <= 5) return AppColors.oliveGreen;
    return AppColors.dullOrange;
  }

  String _dayLetter(int weekday) {
    const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return letters[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(7, (i) => today.add(Duration(days: i)));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: days.map((day) {
            final count = countsByDate[day] ?? 0;
            final isToday = day == today;

            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _dayLetter(day.weekday),
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: isToday
                        ? BoxDecoration(
                            border: Border.all(
                                color: AppColors.darkNavy, width: 2),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          )
                        : null,
                    child: Column(
                      children: [
                        Text(
                          '${day.day}',
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _dotColor(count),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
