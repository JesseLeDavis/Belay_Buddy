import 'package:belay_buddy/src/features/venues/domain/header_config.dart';
import 'package:belay_buddy/src/features/venues/data/venues_repository.dart';
import 'package:belay_buddy/src/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Layout definition for each panel in the collage.
/// Values are fractions of the header width/height.
class _PanelLayout {
  final double left;
  final double top;
  final double width;
  final double height;
  final double rotation; // radians
  final int zIndex; // paint order (lower = further back)

  const _PanelLayout({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.rotation = 0,
    this.zIndex = 0,
  });
}

/// Collage-style header with 6 overlapping panels that slide up with a
/// staggered animation, creating a layered picture-book feel.
class CollageHeader extends ConsumerStatefulWidget {
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
  ConsumerState<CollageHeader> createState() => _CollageHeaderState();
}

class _CollageHeaderState extends ConsumerState<CollageHeader>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _slideAnimations;

  static const _panelCount = 6;
  static const _animDuration = Duration(milliseconds: 700);
  static const _staggerInterval = Duration(milliseconds: 100);

  // Layered collage layout — panels overlap and vary in size.
  // Ordered by zIndex (back to front) for painting.
  static const _layouts = [
    // Panel 0: tall left background piece
    _PanelLayout(
      left: -0.02, top: -0.05, width: 0.38, height: 0.85,
      rotation: -0.03, zIndex: 0,
    ),
    // Panel 1: wide top-right background
    _PanelLayout(
      left: 0.55, top: -0.08, width: 0.48, height: 0.65,
      rotation: 0.02, zIndex: 0,
    ),
    // Panel 2: mid-left overlap
    _PanelLayout(
      left: 0.15, top: 0.18, width: 0.35, height: 0.70,
      rotation: 0.025, zIndex: 1,
    ),
    // Panel 3: center-right overlap
    _PanelLayout(
      left: 0.48, top: 0.12, width: 0.40, height: 0.72,
      rotation: -0.02, zIndex: 1,
    ),
    // Panel 4: foreground left-center
    _PanelLayout(
      left: 0.05, top: 0.35, width: 0.42, height: 0.68,
      rotation: 0.015, zIndex: 2,
    ),
    // Panel 5: foreground right
    _PanelLayout(
      left: 0.52, top: 0.30, width: 0.46, height: 0.72,
      rotation: -0.035, zIndex: 2,
    ),
  ];

  // Different parallax speeds per z-layer
  static const _parallaxSpeeds = [0.12, 0.12, 0.25, 0.25, 0.40, 0.40];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_panelCount, (i) {
      return AnimationController(vsync: this, duration: _animDuration);
    });

    _slideAnimations = List.generate(_panelCount, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 1.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      ));
    });

    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() {
    // Animate back panels first, foreground last
    final order = List.generate(_panelCount, (i) => i)
      ..sort((a, b) => _layouts[a].zIndex.compareTo(_layouts[b].zIndex));

    for (var step = 0; step < order.length; step++) {
      final panelIndex = order[step];
      Future.delayed(_staggerInterval * step, () {
        if (mounted) _controllers[panelIndex].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final panels = ref.watch(resolvedHeaderPanelsProvider(widget.cragId));
    final bgColor =
        widget.isGym ? colors.accentBlue : colors.oliveGreen;

    // Sort panels by zIndex so back layers paint first
    final sortedIndices = List.generate(_panelCount, (i) => i)
      ..sort((a, b) => _layouts[a].zIndex.compareTo(_layouts[b].zIndex));

    return ClipRect(
      child: Container(
        color: bgColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Panels in z-order
                for (final i in sortedIndices)
                  _buildPositionedPanel(i, panels[i], w, h, colors),

                // Title readability gradient
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 100,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            colors.shadowColor.withAlpha(180),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPositionedPanel(
    int index,
    HeaderPanel panel,
    double parentW,
    double parentH,
    AppColorsExtension colors,
  ) {
    final layout = _layouts[index];
    final parallaxOffset = widget.scrollFraction * parentH * _parallaxSpeeds[index];

    return Positioned(
      left: layout.left * parentW,
      top: layout.top * parentH + parallaxOffset,
      width: layout.width * parentW,
      height: layout.height * parentH,
      child: SlideTransition(
        position: _slideAnimations[index],
        child: Transform.rotate(
          angle: layout.rotation,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colors.borderColor,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowColor.withAlpha(80),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: ClipRect(
              child: _PanelTile(
                panel: panel,
                isGym: widget.isGym,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single panel tile that renders either a remote SVG or a bundled default.
class _PanelTile extends StatelessWidget {
  final HeaderPanel panel;
  final bool isGym;

  const _PanelTile({required this.panel, required this.isGym});

  @override
  Widget build(BuildContext context) {
    final assetUrl = panel.assetUrl;

    if (assetUrl != null && assetUrl.startsWith('http')) {
      return SvgPicture.network(
        assetUrl,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => _defaultAsset(),
      );
    }

    return _defaultAsset();
  }

  Widget _defaultAsset() {
    final prefix = isGym ? 'default_gym' : 'default_crag';
    final assetPath = 'assets/headers/$prefix/panel_${panel.index}.svg';
    return SvgPicture.asset(
      assetPath,
      fit: BoxFit.cover,
    );
  }
}
