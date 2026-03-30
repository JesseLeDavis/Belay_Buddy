import 'package:belay_buddy/models/climbing_post.dart';
import 'package:belay_buddy/providers/firestore_providers.dart';
import 'package:belay_buddy/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// A Neobrutalist card for climbing posts.
class PostCard extends ConsumerWidget {
  final ClimbingPost post;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  bool get _isImmediate => post.type == PostType.immediate;

  Color _stripColor() {
    return _isImmediate ? AppColors.dullOrange : AppColors.oliveGreen;
  }

  String _typeLabel() {
    return _isImmediate ? '\u25CF CLIMBING NOW' : '\u25C6 SCHEDULED';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(post.userId));
    final stripColor = _stripColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.darkNavy, width: 2.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkNavy,
              offset: Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colored top strip — bold color block
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm + 4,
                    vertical: 10,
                  ),
                  color: stripColor,
                  child: Row(
                    children: [
                      Text(
                        _typeLabel(),
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDateTime(post.dateTime),
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        post.title,
                        style: GoogleFonts.cabin(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkNavy,
                          height: 1.2,
                        ),
                      ),

                      // Username
                      const SizedBox(height: AppSpacing.xs),
                      userAsync.when(
                        data: (user) => Text(
                          user?.displayName ?? 'Unknown Climber',
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        loading: () => Text(
                          '...',
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            color: AppColors.textDisabled,
                          ),
                        ),
                        error: (_, __) => Text(
                          'Unknown Climber',
                          style: GoogleFonts.spaceMono(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      // Description
                      if (post.description != null &&
                          post.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          post.description!,
                          style: GoogleFonts.cabin(
                            fontSize: 13,
                            color: AppColors.darkNavy.withAlpha(179),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Dotted separator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: CustomPaint(
                    painter: _DottedLinePainter(color: AppColors.darkNavy),
                    size: const Size(double.infinity, 1),
                  ),
                ),

                // Footer with belay chips
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm + 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          children: [
                            if (post.needsBelay)
                              const _BrandChip(
                                label: 'NEED BELAY',
                                fillColor: AppColors.accentBlue,
                                textColor: Colors.white,
                              ),
                            if (post.offeringBelay)
                              const _BrandChip(
                                label: 'CAN BELAY',
                                fillColor: AppColors.oliveGreen,
                                textColor: Colors.white,
                              ),
                          ],
                        ),
                      ),
                      // Timestamp bottom-right
                      Text(
                        _formatDateTime(post.dateTime),
                        style: GoogleFonts.spaceMono(
                          fontSize: 10,
                          color: AppColors.darkNavy.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Decorative pin at top center
            Positioned(
              top: -5,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.dullOrange,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.darkNavy, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.isNegative) {
      final futureDiff = dateTime.difference(now);
      if (futureDiff.inMinutes < 60) return 'in ${futureDiff.inMinutes}m';
      if (futureDiff.inHours < 24) return 'in ${futureDiff.inHours}h';
      return DateFormat('EEE h:mm a').format(dateTime);
    } else {
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return DateFormat('EEE h:mm a').format(dateTime);
    }
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final Color fillColor;
  final Color textColor;

  const _BrandChip({
    required this.label,
    required this.fillColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkNavy, width: 2),
        color: fillColor,
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;

  _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(120)
      ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
