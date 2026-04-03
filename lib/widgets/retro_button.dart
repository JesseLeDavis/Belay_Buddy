import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Neobrutalist brand button — hard offset shadow, physical press effect.
class RetroButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final double shadowOffset;
  final IconData? icon;

  const RetroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color = AppColors.darkNavy,
    this.shadowColor = AppColors.darkNavy,
    this.textColor = Colors.white,
    this.shadowOffset = 5.0,
    this.icon,
  });

  /// Outlined variant constructor
  factory RetroButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return RetroButton(
      key: key,
      label: label,
      onPressed: onPressed,
      color: AppColors.surface,
      shadowColor: AppColors.darkNavy,
      textColor: AppColors.darkNavy,
      icon: icon,
    );
  }

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final offset = _isPressed ? 2.0 : widget.shadowOffset;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel:
          isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: _isPressed
            ? (Matrix4.identity()..translate(3.0, 3.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isEnabled
              ? widget.color
              : widget.color.withAlpha(100),
          border: Border.all(
            color: AppColors.darkNavy,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: Offset(offset, offset),
                    blurRadius: 0,
                  ),
                ]
              : const [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.textColor, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              widget.label.toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
