import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const CountBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: c.borderColor, width: 2),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor ?? c.textOnPrimary,
        ),
      ),
    );
  }
}

class PanelFooter extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PanelFooter({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: c.chipBg,
          border: Border(top: BorderSide(color: c.borderColor, width: 1)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: c.borderColor,
          ),
        ),
      ),
    );
  }
}

class SheetTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool enabled;

  const SheetTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.borderColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.cabin(
                        fontSize: 12, color: c.textSecondary),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
