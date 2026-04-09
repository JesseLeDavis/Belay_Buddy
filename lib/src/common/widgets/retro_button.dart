import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Neobrutalist brand button — hard offset shadow, physical press effect.
class RetroButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? shadowColor;
  final Color? textColor;
  final double shadowOffset;
  final IconData? icon;
  final bool _isOutlined;

  const RetroButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.shadowColor,
    this.textColor,
    this.shadowOffset = 5.0,
    this.icon,
  }) : _isOutlined = false;

  /// Outlined variant constructor
  const RetroButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  })  : color = null,
        shadowColor = null,
        textColor = null,
        shadowOffset = 5.0,
        _isOutlined = true;

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final effectiveColor = widget._isOutlined
        ? c.surface
        : (widget.color ?? c.borderColor);
    final effectiveShadow = widget.shadowColor ?? c.shadowColor;
    final effectiveText = widget._isOutlined
        ? c.borderColor
        : (widget.textColor ?? c.textOnPrimary);

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
              ? effectiveColor
              : effectiveColor.withAlpha(100),
          border: Border.all(
            color: c.borderColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: effectiveShadow,
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
              Icon(widget.icon, color: effectiveText, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              widget.label.toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: effectiveText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
