import 'dart:math' as math;

import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Neobrutalist card-collage header for crag/gym detail pages.
/// Layers: solid color base -> cross-hatch texture -> floating card shapes ->
/// sticker badges -> dot grid overlay -> bottom gradient.
///
/// Designed to echo the app's card vocabulary (thick borders, hard shadows,
/// colored strips, sticker badges) rather than generative art.
class CollageHeader extends StatefulWidget {
  final String cragId;
  final bool isGym;
  final double scrollFraction;

  const CollageHeader({
    super.key,
    required this.cragId,
    required this.isGym,
    required this.scrollFraction,
  });

  @override
  State<CollageHeader> createState() => _CollageHeaderState();
}

class _CollageHeaderState extends State<CollageHeader>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeIn;
  late final Animation<double> _slideUp;
  late final Animation<double> _cardSlide;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _slideUp = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _cardSlide = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
      ),
    );
    _badgeScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bgColor = widget.isGym ? colors.accentBlue : colors.oliveGreen;
    final accentColor = widget.isGym ? colors.amber : colors.dullOrange;
    final seed = widget.cragId.hashCode;

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value,
          child: Transform.translate(
            offset: Offset(0, _slideUp.value),
            child: child,
          ),
        );
      },
      child: Container(
        color: bgColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final parallax = widget.scrollFraction * h * 0.3;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // ---- Layer 0: Cross-hatch texture ----
                Positioned(
                  left: 0,
                  right: 0,
                  top: -parallax * 0.5,
                  height: h * 1.2,
                  child: CustomPaint(
                    painter: _CrossHatchPainter(
                      color: colors.textOnPrimary.withAlpha(16),
                      spacing: 32,
                      strokeWidth: 0.8,
                    ),
                    size: Size(w, h * 1.2),
                  ),
                ),

                // ---- Layer 1: Floating card shapes ----
                ..._buildFloatingCards(
                  colors: colors,
                  bgColor: bgColor,
                  accentColor: accentColor,
                  width: w,
                  height: h,
                  parallax: parallax,
                  seed: seed,
                ),

                // ---- Layer 2: Sticker badges ----
                ..._buildStickerBadges(
                  colors: colors,
                  bgColor: bgColor,
                  accentColor: accentColor,
                  width: w,
                  height: h,
                  parallax: parallax,
                  seed: seed,
                ),

                // ---- Layer 3: Dot grid overlay ----
                Positioned(
                  left: 0,
                  right: 0,
                  top: -parallax * 0.2,
                  height: h * 1.1,
                  child: CustomPaint(
                    painter: _DotGridPainter(
                      color: colors.textOnPrimary.withAlpha(14),
                      spacing: 20,
                      radius: 1.0,
                    ),
                    size: Size(w, h * 1.1),
                  ),
                ),

                // ---- Layer 4: Bottom gradient for title readability ----
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            bgColor.withAlpha(40),
                            bgColor.withAlpha(160),
                            bgColor.withAlpha(220),
                            bgColor,
                          ],
                          stops: const [0.0, 0.25, 0.45, 0.65, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // ---- Layer 5: Bottom edge border ----
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 3,
                  child: ColoredBox(
                    color: colors.textOnPrimary.withAlpha(40),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating card shapes — decorative neobrutalist cards scattered at angles
  // ---------------------------------------------------------------------------

  List<Widget> _buildFloatingCards({
    required AppColorsExtension colors,
    required Color bgColor,
    required Color accentColor,
    required double width,
    required double height,
    required double parallax,
    required int seed,
  }) {
    final rng = math.Random(seed);
    final cards = <Widget>[];
    final cardSurface = colors.textOnPrimary.withAlpha(18);
    final cardBorder = colors.textOnPrimary.withAlpha(40);
    final cardShadow = colors.textOnPrimary.withAlpha(15);

    // Card 1: Large card top-right — has a colored strip header
    cards.add(
      Positioned(
        right: 15 + rng.nextDouble() * 20,
        top: 50 - parallax * 0.4 + rng.nextDouble() * 10,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.5, 0),
            end: Offset.zero,
          ).animate(_cardSlide),
          child: Transform.rotate(
            angle: 0.06 + rng.nextDouble() * 0.06,
            child: _FloatingCard(
              width: 100 + rng.nextDouble() * 20,
              height: 70 + rng.nextDouble() * 15,
              stripColor: accentColor.withAlpha(50),
              surfaceColor: cardSurface,
              borderColor: cardBorder,
              shadowColor: cardShadow,
              stripHeight: 14,
            ),
          ),
        ),
      ),
    );

    // Card 2: Medium card left side — plain card
    cards.add(
      Positioned(
        left: 20 + rng.nextDouble() * 15,
        top: height * 0.3 - parallax * 0.3 + rng.nextDouble() * 10,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.5, 0),
            end: Offset.zero,
          ).animate(_cardSlide),
          child: Transform.rotate(
            angle: -0.08 - rng.nextDouble() * 0.05,
            child: _FloatingCard(
              width: 80 + rng.nextDouble() * 15,
              height: 55 + rng.nextDouble() * 10,
              stripColor: colors.textOnPrimary.withAlpha(25),
              surfaceColor: cardSurface,
              borderColor: cardBorder,
              shadowColor: cardShadow,
              stripHeight: 12,
            ),
          ),
        ),
      ),
    );

    // Card 3: Small card center-right — lower area
    cards.add(
      Positioned(
        right: width * 0.2 + rng.nextDouble() * 30,
        top: height * 0.5 - parallax * 0.2 + rng.nextDouble() * 10,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0.2),
            end: Offset.zero,
          ).animate(_cardSlide),
          child: Transform.rotate(
            angle: 0.1 + rng.nextDouble() * 0.08,
            child: _FloatingCard(
              width: 65 + rng.nextDouble() * 10,
              height: 45 + rng.nextDouble() * 10,
              stripColor: bgColor.withAlpha(80),
              surfaceColor: cardSurface,
              borderColor: cardBorder,
              shadowColor: cardShadow,
              stripHeight: 10,
            ),
          ),
        ),
      ),
    );

    return cards;
  }

  // ---------------------------------------------------------------------------
  // Sticker badges — bold bordered labels and icon stamps
  // ---------------------------------------------------------------------------

  List<Widget> _buildStickerBadges({
    required AppColorsExtension colors,
    required Color bgColor,
    required Color accentColor,
    required double width,
    required double height,
    required double parallax,
    required int seed,
  }) {
    final rng = math.Random(seed);
    final badges = <Widget>[];

    // Badge 1: Type sticker — "CRAG" or "GYM" (top-left, like a label)
    badges.add(
      Positioned(
        left: 18 + rng.nextDouble() * 25,
        top: 60 - parallax * 0.35 + rng.nextDouble() * 10,
        child: ScaleTransition(
          scale: _badgeScale,
          child: Transform.rotate(
            angle: -0.05 - rng.nextDouble() * 0.06,
            child: _StickerLabel(
              text: widget.isGym ? 'GYM' : 'CRAG',
              icon: widget.isGym ? Icons.fitness_center : Icons.terrain,
              bgColor: accentColor,
              borderColor: colors.borderColor,
              textColor:
                  widget.isGym ? colors.darkNavy : colors.textOnPrimary,
            ),
          ),
        ),
      ),
    );

    // Badge 2: Icon circle stamp (top-right area)
    badges.add(
      Positioned(
        right: 25 + rng.nextDouble() * 20,
        top: height * 0.15 - parallax * 0.25 + rng.nextDouble() * 15,
        child: ScaleTransition(
          scale: _badgeScale,
          child: Transform.rotate(
            angle: 0.08 + rng.nextDouble() * 0.1,
            child: _IconStamp(
              icon: widget.isGym
                  ? Icons.sports_gymnastics
                  : Icons.landscape_rounded,
              size: 40,
              bgColor: colors.textOnPrimary.withAlpha(22),
              borderColor: colors.textOnPrimary.withAlpha(55),
              iconColor: colors.textOnPrimary.withAlpha(120),
            ),
          ),
        ),
      ),
    );

    // Badge 3: Small colored square — decorative accent
    badges.add(
      Positioned(
        left: width * 0.55 + rng.nextDouble() * 30,
        top: height * 0.35 - parallax * 0.2,
        child: ScaleTransition(
          scale: _badgeScale,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: colors.amber.withAlpha(40),
                border: Border.all(
                  color: colors.textOnPrimary.withAlpha(45),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );

    // Badge 4: Another small accent — different color
    badges.add(
      Positioned(
        left: width * 0.15 + rng.nextDouble() * 20,
        top: height * 0.55 - parallax * 0.15,
        child: ScaleTransition(
          scale: _badgeScale,
          child: Transform.rotate(
            angle: -0.15,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(35),
                border: Border.all(
                  color: colors.textOnPrimary.withAlpha(35),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );

    return badges;
  }
}

// =============================================================================
// FLOATING CARD — Decorative neobrutalist card shape with optional color strip
// =============================================================================

class _FloatingCard extends StatelessWidget {
  final double width;
  final double height;
  final Color stripColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color shadowColor;
  final double stripHeight;

  const _FloatingCard({
    required this.width,
    required this.height,
    required this.stripColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.shadowColor,
    required this.stripHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Colored header strip — echoes the ProfileCard/panel pattern
          Container(
            height: stripHeight,
            color: stripColor,
          ),
          // Body area is empty — purely decorative
          const Spacer(),
          // Faint horizontal lines mimicking content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.12,
              vertical: height * 0.08,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 3,
                  width: width * 0.55,
                  decoration: BoxDecoration(
                    color: borderColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 3,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                    color: borderColor.withAlpha(15),
                    borderRadius: BorderRadius.circular(1),
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

// =============================================================================
// STICKER LABEL — Bold type badge (e.g., "CRAG" or "GYM") with icon
// =============================================================================

class _StickerLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _StickerLabel({
    required this.text,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    // ignore: unused_element_parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        boxShadow: [
          BoxShadow(
            color: borderColor.withAlpha(80),
            offset: const Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.spaceMono(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 2,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ICON STAMP — Round bordered icon badge
// =============================================================================

class _IconStamp extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;

  const _IconStamp({
    required this.icon,
    required this.size,
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.5),
      ),
      child: Icon(icon, size: size * 0.48, color: iconColor),
    );
  }
}

// =============================================================================
// PAINTERS
// =============================================================================

/// Cross-hatch pattern — clean geometric texture that echoes the app's
/// grid/structured aesthetic without the complexity of topo contours.
class _CrossHatchPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double strokeWidth;

  _CrossHatchPainter({
    required this.color,
    required this.spacing,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Diagonal lines (\)
    final diagLength = size.width + size.height;
    for (var offset = -size.height; offset < diagLength; offset += spacing) {
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset - size.height, size.height),
        paint,
      );
    }

    // Counter-diagonal lines (/)
    for (var offset = -size.height; offset < diagLength; offset += spacing) {
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CrossHatchPainter old) =>
      old.color != color || old.spacing != spacing;
}

/// Subtle dot grid overlay — adds texture/print feel.
class _DotGridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double radius;

  _DotGridPainter({
    required this.color,
    required this.spacing,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var x = spacing / 2; x < size.width; x += spacing) {
      for (var y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}
