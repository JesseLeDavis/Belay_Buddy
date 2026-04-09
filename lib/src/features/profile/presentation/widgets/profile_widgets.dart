import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final Color stripColor;
  final Color titleColor;
  final List<Widget> children;

  const ProfileCard({
    super.key,
    required this.title,
    required this.stripColor,
    required this.titleColor,
    required this.children,
  });

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
            // Colored top strip — bold fill
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.smMd,
                vertical: 10,
              ),
              color: stripColor,
              child: Text(
                title,
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
    );
  }
}

class StatLine extends StatelessWidget {
  final String label;
  final String value;

  const StatLine({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: c.textDisabled,
                ),
              ),
            ),
          if (label.isNotEmpty) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cabin(
                fontSize: 14,
                color: c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
