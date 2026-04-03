import 'package:belay_buddy/models/header_config.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

/// Live preview of the collage header in the admin editor.
/// Renders the 6 panels as a horizontal row with a simulated scroll slider.
class HeaderPreview extends StatefulWidget {
  final String venueId;
  final bool isGym;
  final List<HeaderPanel> panels;

  const HeaderPreview({
    super.key,
    required this.venueId,
    required this.isGym,
    required this.panels,
  });

  @override
  State<HeaderPreview> createState() => _HeaderPreviewState();
}

class _HeaderPreviewState extends State<HeaderPreview> {
  double _scrollFraction = 0.0;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.isGym ? AppColors.accentBlue : AppColors.oliveGreen;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkNavy, width: 2.5),
        boxShadow: const [
          BoxShadow(color: AppColors.darkNavy, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          // Header preview area
          ClipRect(
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Container(
                color: bgColor,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Transform.translate(
                      offset: Offset(0, _scrollFraction * 30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(6, (i) {
                            final panel = widget.panels[i];
                            final prefix =
                                widget.isGym ? 'default_gym' : 'default_crag';
                            final assetPath =
                                'assets/headers/$prefix/panel_${panel.index}.svg';

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: i == 0 ? 0 : 1.5,
                                  right: i == 5 ? 0 : 1.5,
                                ),
                                child: panel.assetUrl != null
                                    ? SvgPicture.network(
                                        panel.assetUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : SvgPicture.asset(
                                        assetPath,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    // Title overlay gradient
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 80,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.darkNavy.withAlpha(160),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sample title
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16,
                      child: Text(
                        'VENUE NAME',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scroll simulator slider
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  'SCROLL',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _scrollFraction,
                    onChanged: (v) => setState(() => _scrollFraction = v),
                    activeColor: AppColors.dullOrange,
                    inactiveColor: AppColors.darkGrey,
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
