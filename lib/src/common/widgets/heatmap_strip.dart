import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeatmapStrip extends StatelessWidget {
  final Map<DateTime, int> countsByDate;
  final VoidCallback? onTap;

  const HeatmapStrip({super.key, required this.countsByDate, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(7, (i) => today.add(Duration(days: i)));

    Color dotColor(int count) {
      if (count == 0) return c.darkGrey;
      if (count <= 2) return c.sageLight;
      if (count <= 5) return c.oliveGreen;
      return c.dullOrange;
    }

    String dayLetter(int weekday) {
      const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      return letters[weekday - 1];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: c.background,
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
                    dayLetter(day.weekday),
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: isToday
                        ? BoxDecoration(
                            border: Border.all(
                                color: c.borderColor, width: 2),
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
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: dotColor(count),
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
