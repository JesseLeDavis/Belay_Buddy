import 'package:belay_buddy/models/header_config.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PanelUploadCard extends StatelessWidget {
  final HeaderPanel panel;
  final bool isGym;
  final ValueChanged<String?> onAssetChanged;
  final VoidCallback onReset;

  const PanelUploadCard({
    super.key,
    required this.panel,
    required this.isGym,
    required this.onAssetChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final hasCustomAsset = panel.assetUrl != null;
    final prefix = isGym ? 'default_gym' : 'default_crag';
    final defaultPath = 'assets/headers/$prefix/panel_${panel.index}.svg';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: const [
          BoxShadow(
            color: AppColors.darkNavy,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: hasCustomAsset ? AppColors.oliveGreen : AppColors.cork,
              border: const Border(
                bottom: BorderSide(color: AppColors.darkNavy, width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PANEL ${panel.index + 1}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: hasCustomAsset ? Colors.white : AppColors.darkNavy,
                  ),
                ),
                if (hasCustomAsset)
                  Text(
                    'CUSTOM',
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withAlpha(200),
                    ),
                  )
                else
                  Text(
                    'DEFAULT',
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // SVG preview
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: hasCustomAsset
                  ? SvgPicture.network(panel.assetUrl!, fit: BoxFit.contain)
                  : SvgPicture.asset(defaultPath, fit: BoxFit.contain),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.darkNavy, width: 1.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'UPLOAD',
                    icon: Icons.upload_file,
                    color: AppColors.accentBlue,
                    onTap: () {
                      // TODO: Use file_picker to select SVG, upload to
                      // Firebase Storage, then call onAssetChanged(downloadUrl)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload not yet wired to Firebase Storage'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _ActionButton(
                    label: 'RESET',
                    icon: Icons.refresh,
                    color: AppColors.textSecondary,
                    onTap: onReset,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
